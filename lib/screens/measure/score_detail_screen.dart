import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/chart_model.dart';
import 'package:kanga/models/result_model.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/compare_provider.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';
import 'package:kanga/widgets/measure_widget.dart';

class ScoreDetailScreen extends StatefulWidget {
  final String type;
  final DateTime selectedDate;

  const ScoreDetailScreen({
    Key? key,
    required this.type,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _ScoreDetailScreenState createState() => _ScoreDetailScreenState();
}

class _ScoreDetailScreenState extends State<ScoreDetailScreen> {
  var _screenshotController = ScreenshotController();

  var title = '';
  var yAxis = '';
  var _selectedDate = DateTime.now();

  List<TimeSeriesSales> _selectedItems = [];
  List<List<TimeSeriesSales>> _chartData = [];

  StreamController<List<TimeSeriesSales>> _chartController =
      StreamController.broadcast();

  var _user = UserModel();

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.selectedDate;

    Timer.run(() {
      switch (widget.type) {
        case 'SLB':
          title = S.current.singleLegBalance;
          yAxis = S.current.second;
          break;
        case 'STS':
          title = S.current.sitToStand;
          yAxis = S.current.times;
          break;
        case 'TMW':
          title = S.current.tenMeterWalk;
          yAxis = S.current.meterSecond;
          break;
      }

      _chartController.add(_selectedItems);

      _initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initData() async {
    _user = (await PrefProvider().getUser())!;
    var res = await NetworkProvider.of(context).post(
      Constants.header_measure,
      Constants.link_get_result,
      {
        'month': DateFormat('MM').format(_selectedDate),
        'year': DateFormat('yyyy').format(_selectedDate),
        'type': widget.type,
      },
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      var resultJson = res['result'];
      List<ResultModel> _result = [];
      for (var json in resultJson) {
        var result = ResultModel.fromJson(json);
        _result.add(result);
      }
      _result.sort((a, b) => a.date_time.compareTo(b.date_time));

      _chartData.clear();
      if (_result.isNotEmpty) {
        List<List<ResultModel>> sortedResult = [];
        List<ResultModel> subResult = [];
        ResultModel currentModel = _result.first;
        for (var result in _result) {
          if (currentModel.date_time != result.date_time) {
            sortedResult.add(subResult);
            subResult = [];
            currentModel = result.clone();
          }
          subResult.add(result);
        }
        sortedResult.add(subResult);

        List<ResultModel> showData = [];
        for (var dateResult in sortedResult) {
          var leftLeg = 0.0;
          var rightLeg = 0.0;
          var sitStand = 0;
          var tenSec = 0.0;
          for (var model in dateResult) {
            leftLeg = leftLeg + double.parse(model.left_leg);
            rightLeg = rightLeg + double.parse(model.right_leg);
            sitStand = sitStand + model.sit_stand;
            tenSec = tenSec + double.parse(model.ten_sec);
          }
          var showResult = ResultModel(
            left_leg: '${leftLeg / dateResult.length}'.get2FormattedValue,
            right_leg: '${rightLeg / dateResult.length}'.get2FormattedValue,
            ten_sec: '${tenSec / dateResult.length}'.get2FormattedValue,
            sit_stand: (sitStand / dateResult.length).round(),
            mode: dateResult.first.mode,
            type: dateResult.first.type,
            date_time: dateResult.first.date_time,
          );
          showData.add(showResult);
        }

        _chartData.clear();
        if (widget.type == 'SLB') {
          List<TimeSeriesSales> leftChart = [];
          List<TimeSeriesSales> rightChart = [];
          for (var result in showData) {
            var leftData = TimeSeriesSales(
                result.date_time.getDateYMD, double.parse(result.left_leg));
            var rightData = TimeSeriesSales(
                result.date_time.getDateYMD, double.parse(result.right_leg));
            leftChart.add(leftData);
            rightChart.add(rightData);
          }
          _chartData.add(leftChart);
          _chartData.add(rightChart);

          _selectedItems.add(leftChart.last);
          _selectedItems.add(rightChart.last);
        } else if (widget.type == 'STS') {
          List<TimeSeriesSales> measureData = [];
          for (var result in showData) {
            var measure = TimeSeriesSales(
                result.date_time.getDateYMD, result.sit_stand.floorToDouble());
            measureData.add(measure);
          }
          _chartData.add(measureData);
          _selectedItems.add(measureData.last);
        } else {
          List<TimeSeriesSales> measureData = [];
          for (var result in showData) {
            var measure = TimeSeriesSales(
                result.date_time.getDateYMD, 10 / double.parse(result.ten_sec));
            measureData.add(measure);
          }
          _chartData.add(measureData);
          _selectedItems.add(measureData.last);

          Future.delayed(Duration(milliseconds: 200), () {
            _chartController.add(_selectedItems);
          });
        }
      }
      setState(() {});
    }
  }

  void _changeDate() async {
    await showMonthPicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null && _selectedDate != date) {
        setState(() {
          _selectedDate = date;
          _initData();
        });
      }
    });
  }

  String getRiskResult() {
    var riskResult = '';
    if (_selectedItems.isNotEmpty) {
      switch (widget.type) {
        case 'SLB':
          var measure =
              (_selectedItems.first.value + _selectedItems.last.value) / 2.0;
          riskResult = CompareProvider.of(context).slb(_user, measure);
          break;
        case 'STS':
          var measure = _selectedItems.first.value;
          riskResult = CompareProvider.of(context).sts(_user, measure.round());
          break;
        case 'TMW':
          var measure = _selectedItems.first.value;
          riskResult = CompareProvider.of(context).tmw(_user, measure);
          break;
      }
    }
    return riskResult;
  }

  void _takeScreenshot() async {
    _screenshotController
        .capture()
        .then((Uint8List? image) => _showShareDialog(image!))
        .catchError((onError) {
      print(onError);
    });
  }

  void _showShareDialog(Uint8List image) {
    DialogProvider.of(context).kangaBubbleDialog(
      child: Column(
        children: [
          Text(
            S.current.shareResult.toUpperCase(),
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: offsetBase,
          ),
          Container(
            height: 250.0,
            child: Image.memory(image),
          ),
        ],
      ),
      actions: [
        KangaMeasureDialogButton(
          context,
          action: () => Navigator.of(context).pop(),
          text: S.current.cancel,
        ),
        KangaMeasureDialogButton(
          context,
          action: () {
            Navigator.of(context).pop();
            _share(image);
          },
          text: S.current.share,
          isFull: true,
        ),
      ],
    );
  }

  void _share(Uint8List image) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/measure.png').create();
    await imagePath.writeAsBytes(image);

    /// Share Plugin
    await Share.shareFiles(
      [imagePath.path],
      subject: 'KangaBalance',
      text:
          'Measure Result for ${_user.getName()} - ${DateFormat('MMM, yyyy').format(_selectedDate)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.share), onPressed: () => _takeScreenshot()),
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(offsetBase),
          child: Column(
            children: [
              InkWell(
                onTap: () => _changeDate(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: offsetXSm,
                    horizontal: offsetSm,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(offsetBase),
                      )),
                  child: Text(
                    DateFormat('MMM, yyyy').format(_selectedDate),
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: offsetBase,
              ),
              widget.type == 'SLB'
                  ? Container(
                      height: 44,
                      margin: EdgeInsets.only(bottom: offsetSm),
                      padding: EdgeInsets.symmetric(horizontal: offsetXMd),
                      decoration: BoxDecoration(
                        color: KangaColor().bubbleConnerColor(1),
                        borderRadius:
                            BorderRadius.all(Radius.circular(offsetXMd)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  S.current.leftLeg.toUpperCase(),
                                  textAlign: TextAlign.right,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: offsetSm),
                                    height: 5,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xff32a157),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(offsetBase)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: offsetBase,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  S.current.rightLeg.toUpperCase(),
                                  textAlign: TextAlign.right,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: offsetSm),
                                    height: 5,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xfff6e94f),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(offsetBase)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Divider(),
              Expanded(
                child: Row(
                  children: [
                    RotatedBox(
                      child: Text(
                        yAxis,
                      ),
                      quarterTurns: -1,
                    ),
                    SizedBox(
                      width: offsetSm,
                    ),
                    Expanded(
                      child: _chartData.isEmpty
                          ? Container()
                          : SelectionChart(
                              onSelection:
                                  (charts.SelectionModel<dynamic> model) {
                                final selectedDatum = model.selectedDatum;
                                final selectDate =
                                    selectedDatum.first.datum.time;
                                _selectedItems.clear();
                                for (var chart in _chartData) {
                                  var selectedItem =
                                      TimeSeriesSales.getValueFromTime(
                                          chart, selectDate);
                                  _selectedItems.add(selectedItem!);
                                }
                                _chartController.add(_selectedItems);
                              },
                              seriesList:
                                  createSelectionChartData(title, _chartData),
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: offsetSm,
              ),
              Text(S.current.date),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultWidget() {
    var valueTextTheme = Theme.of(context).textTheme.headline3;
    var riskTextTheme = Theme.of(context).textTheme.headline2!.copyWith(
          color: KangaColor().pinkButtonColor(1),
        );
    var titleTextTheme = Theme.of(context).textTheme.caption;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        StreamBuilder(
          stream: _chartController.stream,
          builder: (context, snapshot) {
            print('[STREAM _selectedItems : ${_selectedItems.length}]');

            var firstTime = _selectedItems.isEmpty
                ? DateTime.now()
                : _selectedItems.first.time;
            var firstValue = _selectedItems.isEmpty
                ? '---'
                : _selectedItems.first.value.get2Formatted;
            var lastValue = _selectedItems.isEmpty
                ? '---'
                : _selectedItems.last.value.get2Formatted;
            return snapshot.data == null
                ? Container()
                : Container(
                    padding: EdgeInsets.all(offsetBase),
                    child: widget.type == 'SLB'
                        ? Column(
                            children: [
                              Text(
                                'Date : ${DateFormat('MM/dd/yyyy').format(firstTime)}',
                                style: titleTextTheme,
                              ),
                              SizedBox(
                                height: offsetXSm,
                              ),
                              Text(
                                '${S.current.leftLeg} : $firstValue sec',
                                style: valueTextTheme,
                              ),
                              SizedBox(
                                height: offsetXSm,
                              ),
                              Text(
                                '${S.current.rightLeg} : $lastValue sec',
                                style: valueTextTheme,
                              ),
                              SizedBox(
                                height: offsetSm,
                              ),
                              Text(
                                getRiskResult(),
                                style: riskTextTheme,
                              ),
                            ],
                          )
                        : widget.type == 'STS'
                            ? Column(
                                children: [
                                  Text(
                                    'Date : ${DateFormat('MM/dd/yyyy').format(firstTime)}',
                                    style: titleTextTheme,
                                  ),
                                  SizedBox(
                                    height: offsetSm,
                                  ),
                                  Text(
                                    '${S.current.repeatTimes} : $firstValue',
                                    style: valueTextTheme,
                                  ),
                                  SizedBox(
                                    height: offsetBase,
                                  ),
                                  Text(
                                    getRiskResult(),
                                    style: riskTextTheme,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    'Date : ${DateFormat('MM/dd/yyyy').format(firstTime)}',
                                    style: titleTextTheme,
                                  ),
                                  SizedBox(
                                    height: offsetSm,
                                  ),
                                  Text(
                                    '${S.current.velocity} : $firstValue m/s',
                                    style: valueTextTheme,
                                  ),
                                  SizedBox(
                                    height: offsetBase,
                                  ),
                                  Text(
                                    getRiskResult(),
                                    style: riskTextTheme,
                                  ),
                                ],
                              ),
                  );
          },
        ),
      ],
    );
  }
}
