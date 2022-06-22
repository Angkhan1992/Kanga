import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/screens/main_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/button_widget.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _step = 0;
  var _stepData = [];

  var _appInfo = {};

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      _stepData = [
        {
          'title': S.current.fitnessGoalTitle,
          'answer': [
            S.current.fitnessGoalAnswer1,
            S.current.fitnessGoalAnswer2,
            S.current.fitnessGoalAnswer3,
            S.current.fitnessGoalAnswer4,
            S.current.fitnessGoalAnswer5,
            S.current.fitnessGoalAnswer6,
          ],
          'multi': true,
          'result': [false, false, false, false, false, false],
        },
        {
          'title': S.current.focusOnTitle,
          'answer': [
            S.current.focusOnAnswer1,
            S.current.focusOnAnswer2,
            S.current.focusOnAnswer3,
            S.current.focusOnAnswer4,
          ],
          'multi': true,
          'result': [
            false,
            false,
            false,
            false,
          ],
        },
        {
          'title': S.current.genderTitle,
          'answer': [
            S.current.male,
            S.current.female,
          ],
          'multi': false,
          'result': [
            true,
            false,
          ],
        },
      ];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
          padding: EdgeInsets.all(offsetXMd),
          child: Column(
            children: [
              _stepData.length == 0
                  ? Container()
                  : _step == 3
                      ? _shareWidget()
                      : _stepWidget(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: offsetSm),
                child: KangaButton(
                  btnColor: KangaColor().pinkButtonColor(1),
                  onPressed: () => _step == 3
                      ? _onComplete()
                      : _step == 2
                          ? _onSubmit()
                          : _onNext(),
                  btnText: _step == 3
                      ? S.current.complete.toUpperCase()
                      : _step == 2
                          ? S.current.submit.toUpperCase()
                          : S.current.next.toUpperCase(),
                ),
              ),
            ],
          )),
    );
  }

  _stepWidget() {
    var data = _stepData[_step];
    return Column(
      children: [
        SizedBox(
          height: offsetXMd,
        ),
        Text(
          data['title'],
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(
          height: offsetBase,
        ),
        for (var i = 0; i < data['answer'].length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: offsetSm),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (_step == 2 && data['result'][i]) return;
                  data['result'][i] = !data['result'][i];
                  if (_step == 2 && data['result'][i]) {
                    for (var j = 0; j < data['result'].length; j++) {
                      if (i == j) continue;
                      data['result'][j] = false;
                    }
                  }
                });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(offsetSm),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(offsetBase),
                  child: Row(
                    children: [
                      data['result'][i]
                          ? (data['multi']
                              ? Icon(
                                  Icons.check_circle,
                                  size: offsetLg,
                                  color: KangaColor().pinkButtonColor(0.5),
                                )
                              : Icon(
                                  Icons.radio_button_checked,
                                  size: offsetLg,
                                  color: KangaColor().pinkButtonColor(0.5),
                                ))
                          : (data['multi']
                              ? Icon(
                                  Icons.circle,
                                  size: offsetLg,
                                  color: KangaColor().textGreyColor(0.5),
                                )
                              : Icon(
                                  Icons.radio_button_unchecked,
                                  size: offsetLg,
                                  color: KangaColor().pinkButtonColor(0.5),
                                )),
                      SizedBox(
                        width: offsetBase,
                      ),
                      Expanded(child: Text(data['answer'][i])),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  _shareWidget() {
    return Column(
      children: [
        SizedBox(
          height: offsetXMd,
        ),
        Text(
          S.current.findYourFriends,
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          S.current.addOrInviteDetail,
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(fontStyle: FontStyle.italic),
        ),
        SizedBox(
          height: offsetXMd,
        ),
        Row(
          children: [
            Expanded(
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(offsetSm),
                padding: EdgeInsets.all(offsetSm),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(child: Text(_getLink())),
                    SizedBox(
                      width: offsetBase,
                    ),
                    InkWell(
                      child: Icon(Icons.copy),
                      onTap: () async {
                        await Clipboard.setData(
                            new ClipboardData(text: _getLink()));
                        DialogProvider.of(context).showSnackBar(
                          S.current.copyShareLink,
                          // type: SnackBarType.ERROR,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: offsetBase,
            ),
            InkWell(
              onTap: () {
                Share.share(_getLink());
              },
              child: Container(
                width: offsetXLg,
                height: offsetXLg,
                decoration: BoxDecoration(
                  color: KangaColor().pinkButtonColor(1),
                  borderRadius:
                      BorderRadius.all(Radius.circular(offsetXLg / 2.0)),
                ),
                child: Center(
                  child: Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onNext() {
    setState(() {
      _step++;
    });
  }

  Future<void> _onSubmit() async {
    var result = [];
    for (var data in _stepData) {
      var indexs = [];
      for (var i = 0; i < data['result'].length; i++) {
        if (data['result'][i]) {
          indexs.add('$i');
        }
      }
      result.add(indexs.join(','));
    }
    Map<String, dynamic> param = {};
    if (result[0].isNotEmpty) {
      param['fitness_goal'] = result[0];
    }
    if (result[1].isNotEmpty) {
      param['focus_on'] = result[1];
    }
    param['gender'] = result[2] == '0' ? 'MALE' : 'FEMALE';
    var res = await NetworkProvider.of(context).post(
        Constants.header_auth, Constants.link_complete_profile, param,
        isProgress: true);
    if (res['ret'] == 10000) {
      var _currentUser = UserModel.fromJson(res['result']['user']);
      await _currentUser.save();
      _appInfo = res['result']['app'];
      await PrefProvider().setAppInfo(_appInfo);

      _onNext();

      DialogProvider.of(context).showSnackBar(
        S.current.completeProfile,
        // type: SnackBarType.ERROR,
      );
    } else {
      DialogProvider.of(context).showSnackBar(
        res['msg'],
        type: SnackBarType.ERROR,
      );
    }
  }

  String _getLink() {
    if (Platform.isIOS) {
      return _appInfo['apple'];
    } else {
      return _appInfo['google'];
    }
  }

  void _onComplete() {
    NavigatorProvider.of(context)
        .pushToWidget(screen: MainScreen(), replace: true);
  }
}
