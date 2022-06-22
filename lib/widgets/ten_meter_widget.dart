import 'dart:async';
import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/chart_model.dart';
import 'package:kanga/models/measure_model.dart';
import 'package:kanga/models/sensor_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/native_provider.dart';
import 'package:kanga/providers/stt_provider.dart';
import 'package:kanga/providers/tts_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/common_widget.dart';
import 'package:kanga/widgets/measure_widget.dart';
import 'package:kanga/widgets/textfield_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:kanga/utils/extensions.dart';

class TenMeterWidget extends StatefulWidget {
  final Function(dynamic) onResult;
  final bool isSensor;

  const TenMeterWidget({
    Key? key,
    required this.onResult,
    required this.isSensor,
  }) : super(key: key);

  @override
  _TenMeterWidgetState createState() => _TenMeterWidgetState();
}

class _TenMeterWidgetState extends State<TenMeterWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _isDetectable = true;

  var _isPlay = false;
  var _action = MeasureAction.Prepare;
  var _isDone = false;

  Map<String, dynamic> _sensorData = Map();
  List<double> _prepareValues = [];
  List<double> _measureValues = [];

  List<LinearSales> _axisData = [];
  var _measureCounter = 0;

  var _indicateValue = 10;
  var _totalValue = 10;
  var _averageValue = 0.0;

  var _vValue = 0.0;
  var _sValue = 0.0;
  var _isPreDetected = true;
  var _preResult = 0;
  var _sPreValue = 0.0;

  var _strWalker = '';

  KangaSTTProvider? _sttController;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      if (widget.isSensor) {
        _showInformationDialog();
      } else {
        _sttController = KangaSTTProvider.of();
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

    if (_sttController != null) _sttController!.dispose();
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
    } else if (_measureCounter < MEASUREACTIONWALK) {
      if (_action == MeasureAction.PreData) {
        Vibrate.vibrate();
        KangaTTSProvider.of().speak('start');
        if (widget.isSensor) {
          _getAverageValue();
        } else {
          if (_sttController == null) _sttController = KangaSTTProvider.of();
          _sttController!.start(onResult: _voiceDetect);
        }
        _totalValue = 60;
      }
      _action = MeasureAction.Measure;
    } else {
      _action = MeasureAction.Done;
    }

    if (widget.isSensor) {
      _onMeasure();
    }

    if (_onCheckDone()) {
      _action = MeasureAction.Done;
      _measureAction();
      return;
    }

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
          _prepareValues.add(model.z);
          break;
        case MeasureAction.Measure:
          _measureValues.add(model.z);
          break;
        default:
          break;
      }
    }
  }

  void _getAverageValue() {
    _averageValue = 0.0;
    for (var i = 0; i < 10; i++) {
      _averageValue =
          _averageValue + _prepareValues[_prepareValues.length - 1 - i];
    }
    _averageValue = _averageValue / 10.0;
  }

  bool _onCheckDone() {
    if (widget.isSensor) {
      if (_measureValues.isEmpty) {
        return false;
      }
      var value = _measureValues.last;
      var aValue = (value - _averageValue);
      var velocity = _vValue + aValue * 0.1;
      var distance = _vValue * 0.1 + aValue * 0.01 / 2.0;
      if (_isPreDetected && _sValue.abs() > 2.0) {
        _isPreDetected = false;
        _preResult = _measureCounter;
        _sPreValue = _sValue;
      }
      _vValue = velocity;
      _sValue = _sValue + distance;

      _axisData.add(
          new LinearSales(_measureCounter - MEASUREPREDATA, _sValue.abs()));

      if (_sValue.abs() > 2.0) {
        if (_measureCounter - _preResult > 0) {
          var showValue =
              '${(_sValue.abs() - _sPreValue.abs()) / (_measureCounter - _preResult) * 10}';
          _strWalker = '${showValue.get2FormattedValue} m/s';
        }
      }

      return (_sValue.abs() - _sPreValue.abs()) > 10.0;
    } else {
      return _isDone;
    }
  }

  void _voiceDetect(SpeechRecognitionResult result) {
    var detectedWord = result.recognizedWords;
    var lastWord = detectedWord.split(" ").last;
    print('[VOICE] detected ===> $lastWord');

    for (var word in Constants.voiceDetectWords) {
      if (word == lastWord.toLowerCase()) {
        _isDone = true;
        break;
      }
    }
    if (detectedWord[detectedWord.length - 1] == '4' && !_isDone) {
      _isDone = true;
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

        if (widget.isSensor) {
          var resultData = {
            'value': (_sValue.abs() - _sPreValue.abs()) /
                (_measureCounter - _preResult) *
                10,
            'chart': _axisData,
          };
          widget.onResult(resultData);
        } else {
          _sttController!.stop();
        }
        break;
    }
    setState(() {});
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
              S.current.onceDowncountStartTenMeterWalk,
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
        ]);
  }

  @override
  Widget build(BuildContext context) {
    var isHalfMode =
        ((_action == MeasureAction.Measure || _action == MeasureAction.Done) &&
            widget.isSensor);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
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
                        valueT: _indicateValue,
                        strokeWidth: 6,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: offsetBase, vertical: offsetXMd),
                      child: SimpleLineChart(
                        createLineChartData(
                          'Single Leg Balance',
                          [_axisData],
                        ),
                        range: const charts.NumericExtents(-0.5, 12.5),
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
                            S.current.tenMeterWalk,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    color: KangaColor().pinkButtonColor(1)),
                          ),
                          SizedBox(
                            height: offsetXMd,
                          ),
                          widget.isSensor
                              ? Text(
                                  _strWalker.isEmpty ? '--- m/s' : _strWalker,
                                  style: Theme.of(context).textTheme.headline2,
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: offsetXLg),
                                  child: Row(
                                    children: [
                                      if (_action == MeasureAction.Done)
                                        Expanded(
                                          child: Text(
                                            '${(_measureCounter - MEASUREPREDATA) / 10} ${S.current.sec}\n${(100 / (_measureCounter - MEASUREPREDATA)).get2Formatted} m/s',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
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
    var _counter = (_measureCounter - MEASUREPREDATA) / 10;
    FocusScope.of(context).unfocus();
    var resultData = {
      'value': (10 / _counter),
    };
    widget.onResult(resultData);
  }
}
