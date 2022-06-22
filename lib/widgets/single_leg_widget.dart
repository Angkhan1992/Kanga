import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:kanga/widgets/common_widget.dart';
import 'package:kanga/widgets/measure_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SingleLegWidget extends StatefulWidget {
  final Function(dynamic) onResult;
  final bool isSensor;

  const SingleLegWidget({
    Key? key,
    required this.onResult,
    required this.isSensor,
  }) : super(key: key);

  @override
  _SingleLegWidgetState createState() => _SingleLegWidgetState();
}

class _SingleLegWidgetState extends State<SingleLegWidget> {
  var _isRightMode = true;
  var _isDetectable = true;

  var _isPlay = false;
  var _action = MeasureAction.Prepare;
  var _repeat = 0;
  var _isDone = false;

  Map<String, dynamic> _sensorData = Map();
  List<double> _prepareValues = [];
  List<double> _measureValues = [];

  List<double> _result = [];
  List<List<LinearSales>> _resultAxis = [];

  List<LinearSales> _axisData = [];
  var _measureCounter = 0;

  var _indicateValue = 10;
  var _totalValue = 10;
  var _averageValue = 0.0;

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

  void _resetData() {
    setState(() {
      _isPlay = true;
      _isDetectable = true;
      _isDone = false;
      _action = MeasureAction.Prepare;

      _sensorData.clear();
      _prepareValues.clear();
      _measureValues.clear();
      _axisData.clear();

      _measureCounter = 0;
      _indicateValue = 10;
      _totalValue = 10;
      _averageValue = 0.0;
    });
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
        if (widget.isSensor) {
          _getAverageValue();
        } else {
          if (_sttController == null) _sttController = KangaSTTProvider.of();
          _sttController!.start(onResult: _voiceDetect);
        }
        _totalValue = 30;
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
          _prepareValues.add(model.y);
          break;
        case MeasureAction.Measure:
          _measureValues.add(model.y);
          _axisData
              .add(new LinearSales(_measureCounter - MEASUREPREDATA, model.y));
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
      if (_measureValues.length < 25) {
        return false;
      }
      var value = _measureValues.last;
      if (_isRightMode) {
        if (Platform.isAndroid) {
          return value < _averageValue;
        } else {
          return value > _averageValue;
        }
      }
      if (Platform.isAndroid) {
        return value > _averageValue;
      } else {
        return value < _averageValue;
      }
    } else {
      return _isDone;
    }
  }

  void _voiceDetect(SpeechRecognitionResult result) {
    var detectedWord = result.recognizedWords;
    print('[VOICE] detected ===> $detectedWord');

    var lastWord = detectedWord.split(" ").last;

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

        _result.add((_measureCounter - MEASUREPREDATA) / 10);
        if (widget.isSensor) {
          _resultAxis.add(_axisData);
        } else {
          _sttController!.stop();
        }

        _repeat++;
        if (_repeat == 6) {
          _repeat = 5;
          Map<String, dynamic> resultData = {};
          resultData['value'] = _result;
          if (widget.isSensor) {
            resultData['chart'] = _resultAxis;
          }
          widget.onResult(resultData);
        } else {
          if (_repeat == 3) {
            KangaTTSProvider.of().speak('Left Leg');
            _isRightMode = false;
          }
          Future.delayed(Duration(milliseconds: (1000)), () => _resetData());
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
            S.current.afterDowncountDescRightLeg,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontSize: 18.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: offsetBase,
          ),
          Text(
            S.current.singleLegOptionalDesc,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 13.0,
                ),
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
                  child: SingleLegBottomWidget(
                    context: context,
                    title: _isRightMode
                        ? S.current.rightLeg.toUpperCase()
                        : S.current.leftLeg.toUpperCase(),
                    repeat: _repeat % 3,
                    isHalf: isHalfMode,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
