import 'dart:async';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/result_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/screens/measure/score_detail_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';
import 'package:kanga/widgets/measure_widget.dart';
import 'package:kanga/widgets/view_score_widget.dart';

class ViewScoreScreen extends StatefulWidget {
  const ViewScoreScreen({Key? key}) : super(key: key);

  @override
  _ViewScoreScreenState createState() => _ViewScoreScreenState();
}

class _ViewScoreScreenState extends State<ViewScoreScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ResultModel> _slbData = [];
  List<ResultModel> _stsData = [];
  List<ResultModel> _tmwData = [];

  var _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    Timer.run(() => _initData());
  }

  void _initData() async {
    var res = await NetworkProvider.of(context).post(
      Constants.header_measure,
      Constants.link_get_result,
      {
        'month': DateFormat('MM').format(_selectedDate),
        'year': DateFormat('yyyy').format(_selectedDate),
      },
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      var resultJson = res['result'];
      List<ResultModel> _results = [];
      for (var json in resultJson) {
        var result = ResultModel.fromJson(json);
        _results.add(result);
      }
      print('result ===> ${_results.length}');

      _slbData.clear();
      _stsData.clear();
      _tmwData.clear();
      for (var model in _results) {
        if (model.type == 'SLB') {
          _slbData.add(model);
        }
        if (model.type == 'STS') {
          _stsData.add(model);
        }
        if (model.type == 'TMW') {
          _tmwData.add(model);
        }
      }
      if (_slbData.isEmpty && _stsData.isEmpty && _tmwData.isEmpty) {
        DialogProvider.of(context).showSnackBar(
          S.current.measureDataEmpty,
          type: SnackBarType.ERROR,
        );
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

  void _showInfoDialog(String title, String detail) {
    DialogProvider.of(context).kangaBubbleDialog(
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 22.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: offsetBase,
          ),
          Text(
            detail,
            style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: 18.0, color: KangaColor().pinkButtonColor(1)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        KangaMeasureDialogButton(
          context,
          action: () => Navigator.of(context).pop(),
          text: S.current.ok,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var leftLegValue = 0.0;
    var rightLegValue = 0.0;
    if (_slbData.isNotEmpty) {
      for (var slb in _slbData) {
        leftLegValue = leftLegValue + double.parse(slb.left_leg);
        rightLegValue = rightLegValue + double.parse(slb.right_leg);
      }
      rightLegValue = rightLegValue / _slbData.length;
      leftLegValue = leftLegValue / _slbData.length;
    }
    var leftLeg = '--- sec';
    var rightLeg = '--- sec';
    if (leftLegValue > 0) {
      leftLeg = '$leftLegValue'.get2FormattedValue + ' sec';
    }
    if (rightLegValue > 0) {
      rightLeg = '$rightLegValue'.get2FormattedValue + ' sec';
    }

    var stsValue = 0;
    if (_stsData.isNotEmpty) {
      for (var sts in _stsData) {
        stsValue = stsValue + sts.sit_stand;
      }
      stsValue = (stsValue / _stsData.length).round();
    }
    var sts = '---';
    if (stsValue > 0) {
      sts = '$stsValue';
    }

    var tmwValue = 0.0;
    if (_tmwData.isNotEmpty) {
      for (var tmw in _tmwData) {
        var velocity = double.parse(tmw.ten_meter) / double.parse(tmw.ten_sec);
        tmwValue = tmwValue + velocity;
      }
      tmwValue = tmwValue / _tmwData.length;
    }
    var tmw = '--- m/s';
    if (tmwValue > 0) {
      tmw = '$tmwValue'.get2FormattedValue + ' m/s';
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          S.current.viewScore,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(offsetBase),
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
            Row(
              children: [
                Expanded(
                    child: DottedLine(
                  dashColor: KangaColor().pinkButtonColor(1),
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: offsetSm,
                    vertical: offsetBase,
                  ),
                  child: Text(S.current.oneMonthAverage),
                ),
                Expanded(
                    child: DottedLine(
                  dashColor: KangaColor().pinkButtonColor(1),
                )),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ViewScoreWidget(
                      context: context,
                      title: S.current.singleLegBalance,
                      body: Row(
                        children: [
                          Expanded(
                            child: ViewValueWidget(
                              context: context,
                              title: S.current.leftLeg,
                              value: leftLeg,
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            width: 1,
                            color: KangaColor().textGreyColor(1),
                          ),
                          Expanded(
                            child: ViewValueWidget(
                              context: context,
                              title: S.current.rightLeg,
                              value: rightLeg,
                            ),
                          ),
                        ],
                      ),
                      onClickInfo: () => _showInfoDialog(
                        S.current.totalTimeBalanced,
                        S.current.balanceControl,
                      ),
                      onClickViewScore: () {
                        if (_slbData.isEmpty) {
                          DialogProvider.of(context).showSnackBar(
                            S.current.measureDataEmpty,
                            type: SnackBarType.ERROR,
                          );
                          return;
                        }
                        NavigatorProvider.of(context).pushToWidget(
                            screen: ScoreDetailScreen(
                                type: 'SLB', selectedDate: _selectedDate));
                      },
                    ),
                    ViewScoreWidget(
                      context: context,
                      title: S.current.sitToStand,
                      body: Center(
                        child: ViewValueWidget(
                          context: context,
                          title: S.current.repeatTimes,
                          value: sts,
                        ),
                      ),
                      onClickInfo: () => _showInfoDialog(
                        S.current.totalSitToStands,
                        S.current.standsControl,
                      ),
                      onClickViewScore: () {
                        if (_stsData.isEmpty) {
                          DialogProvider.of(context).showSnackBar(
                            S.current.measureDataEmpty,
                            type: SnackBarType.ERROR,
                          );
                          return;
                        }
                        NavigatorProvider.of(context).pushToWidget(
                            screen: ScoreDetailScreen(
                                type: 'STS', selectedDate: _selectedDate));
                      },
                    ),
                    ViewScoreWidget(
                      context: context,
                      title: S.current.tenMeterWalk,
                      body: Center(
                        child: ViewValueWidget(
                          context: context,
                          title: S.current.velocity,
                          value: tmw,
                        ),
                      ),
                      onClickInfo: () => _showInfoDialog(
                        S.current.tenMeterTime,
                        S.current.tenMeterControl,
                      ),
                      onClickViewScore: () {
                        if (_tmwData.isEmpty) {
                          DialogProvider.of(context).showSnackBar(
                            S.current.measureDataEmpty,
                            type: SnackBarType.ERROR,
                          );
                          return;
                        }
                        NavigatorProvider.of(context).pushToWidget(
                            screen: ScoreDetailScreen(
                                type: 'TMW', selectedDate: _selectedDate));
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
