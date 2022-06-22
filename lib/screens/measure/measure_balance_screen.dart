import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/inapp_model.dart';
import 'package:kanga/models/measure_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/screens/measure/view_score_screen.dart';
import 'package:kanga/screens/more/membership_screen.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';
import 'package:kanga/widgets/measure_widget.dart';
import 'package:kanga/widgets/single_leg_widget.dart';
import 'package:kanga/widgets/sit_stand_widget.dart';
import 'package:kanga/widgets/ten_meter_widget.dart';
import 'package:kanga/widgets/view_score_widget.dart';

class MeasureBalanceScreen extends StatefulWidget {
  final MeasureModel measure;
  final bool isSensor;

  const MeasureBalanceScreen({
    Key? key,
    required this.measure,
    this.isSensor = true,
  }) : super(key: key);

  @override
  _MeasureBalanceScreenState createState() => _MeasureBalanceScreenState();
}

class _MeasureBalanceScreenState extends State<MeasureBalanceScreen> {
  var _screenIndex = 0;
  var _screens = [];

  @override
  void initState() {
    super.initState();

    _checkMeasureType();

    Timer.run(() {
      _screens = [
        SingleLegWidget(
          onResult: (result) => _completeDialog(result),
          isSensor: widget.isSensor,
        ),
        SitStandWidget(
          onResult: (result) => _completeDialog(result),
          isSensor: widget.isSensor,
        ),
        TenMeterWidget(
          onResult: (result) => _completeDialog(result),
          isSensor: widget.isSensor,
        ),
      ];
      setState(() {});
    });
  }

  void _checkMeasureType() {
    switch (widget.measure.title.toLowerCase()) {
      case 'single leg balance':
        _screenIndex = 0;
        break;
      case 'sit to stands':
        _screenIndex = 1;
        break;
      case '10-meter walk':
        _screenIndex = 2;
        break;
      default:
        _screenIndex = 0;
        break;
    }
  }

  void _completeDialog(dynamic result) {
    var resultString = '';
    switch (_screenIndex) {
      case 0:
        resultString = S.current.completeSingleLeg;
        break;
      case 1:
        resultString = S.current.completeSitStand;
        break;
      case 2:
        resultString = S.current.completeTenWalker;
        break;
      default:
        resultString = S.current.completeSingleLeg;
        break;
    }
    DialogProvider.of(context).kangaBubbleDialog(
      child: Column(
        children: [
          Text(
            S.current.greatJob.toUpperCase(),
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: offsetBase,
          ),
          Text(
            resultString,
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
            _viewScore(result);
          },
          text: S.current.viewScore,
        ),
      ],
    );
  }

  void _viewScore(dynamic result) async {
    var user = (await PrefProvider().getUser())!;
    DialogProvider.of(context).kangaBubbleDialog(
      child: Column(
        children: [
          Text(
            S.current.viewScore.toUpperCase(),
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: offsetXMd,
          ),
          _screenIndex == 0
              ? singleLegDialogWidget(
                  context,
                  user: user,
                  data: result['value'],
                )
              : _screenIndex == 1
                  ? sitStandDialogWidget(
                      context,
                      user: user,
                      data: result['value'],
                    )
                  : tenMeterDialogWidget(
                      context,
                      user: user,
                      velocity: result['value'],
                      time: 10 / result['value'],
                      distance: 10,
                    ),
        ],
      ),
      actions: [
        KangaMeasureDialogButton(
          context,
          action: () {
            Navigator.of(context).pop();
            _onSubmit(result);
          },
          text: S.current.ok,
        ),
      ],
    );
  }

  void _onSubmit(dynamic result) async {
    var param = {
      'date_time': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'mode': widget.isSensor ? 'Sensor' : 'Voice',
      'type': _screenIndex == 0
          ? 'SLB'
          : _screenIndex == 1
              ? 'STS'
              : 'TMW',
    };
    switch (_screenIndex) {
      case 0:
        var left = 0.0;
        var right = 0.0;
        for (var i = 0; i < result['value'].length; i++) {
          var value = result['value'][i];
          if (i < 3) {
            right = right + value;
          } else {
            left = left + value;
          }
        }
        right = right / 3.0;
        left = left / 3.0;
        param['left_leg'] = '$left'.get2FormattedValue;
        param['right_leg'] = '$right'.get2FormattedValue;
        break;
      case 1:
        param['sit_stand'] = result['value'].toString();
        break;
      case 2:
        param['ten_sec'] = '${10 / result['value']}'.get2FormattedValue;
        param['ten_meter'] = '10';
        break;
    }

    var res = await NetworkProvider.of(context).post(
      Constants.header_measure,
      Constants.link_add_result,
      param,
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      var res = await NetworkProvider.of(context).post(
        Constants.header_auth,
        Constants.link_check_expired,
        {},
        isProgress: true,
      );
      if (res['ret'] == 10000) {
        if (res['result'] != 'false') {
          _showMembershipDialog();
          return;
        }
        NavigatorProvider.of(context).pushToWidget(
          screen: ViewScoreScreen(),
          replace: true,
        );
      } else {
        DialogProvider.of(context).showSnackBar(
          S.current.severError,
          type: SnackBarType.ERROR,
        );
        return;
      }
    }
  }

  void _showMembershipDialog() {
    DialogProvider.of(context).kangaBubbleDialog(
      child: Column(
        children: [
          Text(
            S.current.accountExpiredTitle,
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(
            height: offsetBase,
          ),
          Text(
            S.current.accountExpiredDesc1,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontSize: 16.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: offsetSm,
          ),
          Text(
            S.current.accountExpiredDesc2,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
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
          text: S.current.cancel,
        ),
        KangaMeasureDialogButton(
          context,
          action: () async {
            Navigator.of(context).pop();
            try {
              var resp = await NetworkProvider.of(context).post(
                Constants.header_profile,
                Constants.link_get_membership,
                {},
              );
              if (resp['ret'] == 10000) {
                var inAppInfo = InAppModel.fromJson(resp['result']);
                NavigatorProvider.of(context).pushToWidget(
                  screen: MembershipScreen(
                    model: inAppInfo,
                  ),
                );
              }
            } catch (e) {
              DialogProvider.of(context).showSnackBar(
                e.toString(),
                type: SnackBarType.ERROR,
              );
            }
          },
          text: S.current.gotoMembership.toUpperCase(),
          isFull: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.timer,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: _screens.isEmpty ? Container() : _screens[_screenIndex],
    );
  }
}
