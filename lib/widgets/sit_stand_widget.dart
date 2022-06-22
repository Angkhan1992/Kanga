import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/chart_model.dart';
import 'package:kanga/models/measure_model.dart';
import 'package:kanga/models/sensor_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/native_provider.dart';
import 'package:kanga/providers/tts_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/common_widget.dart';
import 'package:kanga/widgets/measure_widget.dart';
import 'package:kanga/widgets/textfield_widget.dart';

class SitStandWidget extends StatefulWidget {
  final Function(dynamic) onResult;
  final bool isSensor;

  const SitStandWidget({
    Key? key,
    required this.onResult,
    required this.isSensor,
  }) : super(key: key);

  @override
  _SitStandWidgetState createState() => _SitStandWidgetState();
}

class _SitStandWidgetState extends State<SitStandWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _isDetectable = true;
  var _isPlay = false;

  var _action = MeasureAction.Prepare;

  Map<String, dynamic> _sensorData = Map();
  List<double> _prepareValues = [];
  List<double> _measureValues = [];

  List<LinearSales> _axisData = [];
  var _measureCounter = 0;

  var _indicateValue = 10;
  var _totalValue = 10;

  var _result = 0;
  var _countController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      if (widget.isSensor) {
        _showInformationDialog();
      } else {
        _isPlay = true;
      }
    });

    NativeProvider().getSensorData((data) => _reload(data));
  }

  @override
  void dispose() {
    super.dispose();

    _isPlay = false;
    _isDetectable = false;
  }

  void _reload(dynamic data) {
    if (!_isPlay) {
      return;
    }
    if (!_isDetectable) {
      return;
    }

    var delay = widget.isSensor ? DELAYTIME - 20 : DELAYTIME;
    Future.delayed(Duration(milliseconds: (delay)), () {
      _isDetectable = true;
    });
    _sensorData = jsonDecode(data);
    _isDetectable = false;
    _updateAction();
  }

  void _updateAction() {
    _measureCounter++;
    if (_measureCounter < MEASUREPREPARE) {
      _action = MeasureAction.Prepare;
    } else if (_measureCounter < MEASUREPREDATA) {
      _action = MeasureAction.PreData;
    } else if (_measureCounter < MEASUREACTION) {
      if (_action == MeasureAction.PreData) {
        Vibrate.vibrate();
        KangaTTSProvider.of().speak('start');
        _totalValue = 30;
      }
      _action = MeasureAction.Measure;
    } else {
      _action = MeasureAction.Done;
      if (widget.isSensor) _onMeasureResult();
      _measureAction();
      return;
    }

    if (widget.isSensor) _onMeasure();

    if (_measureCounter % 10 == 0) {
      _measureAction();
    }
  }

  void _onMeasure() {
    if (widget.isSensor) {
      var jsonSensor = _sensorData[SensorType.ACCELEROMETER] as List<dynamic>;
      var model = AccelerometerModel(
        x: double.parse(jsonSensor[0].toString()),
        y: double.parse(jsonSensor[1].toString()),
        z: double.parse(jsonSensor[2].toString()),
      );
      switch (_action) {
        case MeasureAction.PreData:
          _prepareValues.add(model.x);
          break;
        case MeasureAction.Measure:
          _measureValues.add(model.x);
          _axisData
              .add(new LinearSales(_measureCounter - MEASUREPREDATA, model.y));
          break;
        default:
          break;
      }
    }
  }

  void _measureAction() {
    switch (_action) {
      case MeasureAction.Prepare:
        _indicateValue = ((MEASUREPREDATA - _measureCounter) / 10).floor();
        KangaTTSProvider.of().speak('$_indicateValue');
        break;
      case MeasureAction.PreData:
        _indicateValue = ((MEASUREPREDATA - _measureCounter) / 10).floor();
        KangaTTSProvider.of().speak('$_indicateValue');
        break;
      case MeasureAction.Measure:
        _indicateValue = ((_measureCounter - MEASUREPREDATA) / 10).floor();
        break;
      case MeasureAction.Done:
        _indicateValue = _totalValue;
        _isPlay = false;
        _isDetectable = false;

        Vibrate.vibrate();

        Map<String, dynamic> resultData = {};
        if (widget.isSensor) {
          resultData['value'] = _result;
          resultData['chart'] = _axisData;
          widget.onResult(resultData);
        }
        break;
    }
    setState(() {});
  }

  void _onMeasureResult() {
    var min = _measureValues.reduce((curr, next) => curr < next ? curr : next);
    var max = _measureValues.reduce((curr, next) => curr > next ? curr : next);
    var averageValue = (min + max) / 2.0;

    var prepareSum = 0.0;
    for (var i = 0; i < 10; i++) {
      prepareSum = prepareSum + _prepareValues[_prepareValues.length - 1 - i];
    }
    prepareSum = prepareSum / 10.0;

    var isOver = false;
    var isBeforeStatus = false;
    var delta = 0.0;
    if ((max - min) > 5) {
      delta = (max - min) / 30;
    } else {
      delta = 1.0;
    }

    for (var value in _measureValues) {
      if (value > averageValue + delta) {
        isOver = true;
      }
      if (value < averageValue - delta) {
        isOver = false;
      }
      if (isOver != isBeforeStatus) {
        _result = _result + 1;
        isBeforeStatus = isOver;
      }
    }
    _result = (_result / 2).round();
  }

  void _showInformationDialog() {
    DialogProvider.of(context).kangaBubbleDialog(
      child: Column(
        children: [
          Text(
            S.current.placePhoneDescription,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 18.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: offsetBase,
          ),
          kangaBeltLogo,
          SizedBox(
            height: offsetBase,
          ),
          Text(
            S.current.downcountStandStill,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontSize: 18.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: offsetSm,
          ),
          Text(
            S.current.onceDowncountStartSittoStands,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontSize: 18.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        KangaMeasureDialogButton(
          context,
          action: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          text: S.current.goBack,
        ),
        KangaMeasureDialogButton(
          context,
          action: () {
            Navigator.of(context).pop();
            _isPlay = true;
          },
          text: S.current.start.toUpperCase(),
          isFull: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var isHalfMode =
        ((_action == MeasureAction.Measure || _action == MeasureAction.Done) &&
            widget.isSensor);
    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: offsetXMd),
              padding: EdgeInsets.symmetric(
                  vertical: offsetSm, horizontal: offsetBase),
              decoration: BoxDecoration(
                color: KangaColor().pinkButtonColor(1),
                borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
              ),
              child: Text(widget.isSensor
                  ? S.current.sensorMode.toUpperCase()
                  : S.current.voiceMode.toUpperCase()),
            ),
            Expanded(
              child: (!isHalfMode || !widget.isSensor)
                  ? Center(
                      child: KangaCircleIndicator(
                        context: context,
                        totalSecond: _totalValue,
                        indicatorHeight:
                            _action == MeasureAction.Done ? 200.0 : 250.0,
                        valueT: _indicateValue,
                        strokeWidth: 6,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: offsetBase, vertical: offsetXMd),
                      child: SimpleLineChart(
                        createLineChartData(
                          'Sit to Stand',
                          [_axisData],
                        ),
                        range: (Platform.isIOS)
                            ? const charts.NumericExtents(-10.5, 0.5)
                            : const charts.NumericExtents(-0.5, 10.5),
                      ),
                    ),
            ),
            Container(
              color: KangaColor().bubbleConnerColor(1),
              child: Row(
                children: [
                  if (isHalfMode)
                    Container(
                      width: 200.0,
                      height: 200.0,
                      padding: EdgeInsets.all(offsetBase),
                      child: Center(
                        child: KangaCircleIndicator(
                          context: context,
                          totalSecond: _totalValue,
                          valueT: _indicateValue,
                          strokeWidth: 4,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.current.sitToStand,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    color: KangaColor().pinkButtonColor(1)),
                          ),
                          SizedBox(
                            height: offsetBase,
                          ),
                          widget.isSensor
                              ? Text(
                                  _result == 0 ? '---' : '$_result',
                                  style: Theme.of(context).textTheme.headline2,
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: offsetXLg),
                                  child: Row(
                                    children: [
                                      if (_action == MeasureAction.Done)
                                        Expanded(
                                          child: KangaTextField(
                                            hintText:
                                                S.current.sitToStandCounter,
                                            keyboardType: TextInputType.number,
                                            prefixIcon: Icon(
                                              Icons.confirmation_number,
                                              color:
                                                  KangaColor().textGreyColor(1),
                                            ),
                                            controller: _countController,
                                          ),
                                        ),
                                      SizedBox(
                                        width: offsetBase,
                                      ),
                                      if (_action == MeasureAction.Done)
                                        Expanded(
                                          child: KangaButton(
                                            onPressed: () => _onSubmit(),
                                            btnText: S.current.submit,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    var _counter = _countController.text;
    if (_counter.isEmpty) {
      DialogProvider.of(context).showSnackBar(
        S.current.emptyResult,
        type: SnackBarType.ERROR,
      );
      return;
    }
    FocusScope.of(context).unfocus();
    var resultData = {
      'value': int.parse(_counter),
    };
    widget.onResult(resultData);
  }
}
