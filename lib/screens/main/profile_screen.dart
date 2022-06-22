import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/class_model.dart';
import 'package:kanga/models/result_model.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/compare_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/screens/profile/achieve_screen.dart';
import 'package:kanga/screens/profile/edit_profile_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';
import 'package:kanga/widgets/common_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _scrollController = ScrollController();
  var _sessions = [];
  var _user = UserModel();
  var _achieveIndex = 0;

  var _isLoaded = false;

  List<ResultModel> _results = [];
  var _fallRisk = '---';

  var _classNo = '---';
  List<OnDemandModel> _demands = [];

  @override
  void initState() {
    super.initState();
    Timer.run(() => _getData());
  }

  void _getData() async {
    setState(() => _isLoaded = false);
    var res = await NetworkProvider.of(context).post(
      Constants.header_profile,
      Constants.link_get_profile,
      {},
    );
    if (res['ret'] == 10000) {
      _user = UserModel.fromJson(res['result']['user']);
      await _user.save();

      _results.clear();
      for (var json in res['result']['fall']) {
        var model = ResultModel.fromJson(json);
        _results.add(model);
      }
      if (_user.getAge() > 0 && _user.getAge() < 100) {
        _checkFallRisk();
      }

      _demands.clear();
      for (var json in res['result']['demand']) {
        var model = OnDemandModel.fromJson(json);
        _demands.add(model);
      }

      List<ClassModel> _classes = [];
      for (var json in res['result']['classes']) {
        var model = ClassModel.fromJson(json);
        _classes.add(model);
      }
      print('[PROFILE] account: ${_classes.length}');

      _classNo = '${_classes.length}';

      _achieveIndex = 0;
      for (var achieve in kAchievements) {
        if ((achieve['value'] as int) > int.parse(_classNo)) {
          print('[Achieve] content: $achieve');
          _achieveIndex = kAchievements.indexOf(achieve) - 1;
          break;
        }
      }

      _sessions.clear();
      for (var demand in _demands) {
        if (demand.classes == 0) continue;
        int _demandSum = 0;
        for (var _class in _classes) {
          if (_class.demand_id == demand.id) {
            _demandSum++;
          }
        }
        _sessions.add({
          'title': demand.name,
          'value': _demandSum,
          'total': demand.classes,
        });
      }
      print('[Profile] ${_sessions.toString()}');
    }

    setState(() => _isLoaded = true);
  }

  void _checkFallRisk() {
    if (_results.isEmpty) return;
    var sum = 0;
    for (var result in _results) {
      var measure =
          (double.parse(result.left_leg) + double.parse(result.right_leg)) /
              2.0;
      var resStr = CompareProvider.of(context).slb(_user, measure);
      if (resStr != S.current.notAtRisk) {
        sum++;
      }
    }
    setState(() {
      _fallRisk = '$sum';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          S.current.profile,
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                NavigatorProvider.of(context).pushToWidget(
                    screen: EditProfileScreen(
                      currentUser: _user,
                    ),
                    pop: (reload) {
                      if (reload != null) _getData();
                    });
              }),
        ],
      ),
      body: _isLoaded
          ? SingleChildScrollView(
              controller: _scrollController,
              child: _user.id == null
                  ? Container()
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 180.0,
                          color: KangaColor().pinkButtonColor(1),
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(offsetBase),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 120.0,
                                        decoration: BoxDecoration(
                                            color:
                                                KangaColor().textGreyColor(1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(offsetBase)),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.0,
                                            )),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(offsetBase)),
                                          child: CachedNetworkImage(
                                            imageUrl: _user.avatar,
                                            height: double.infinity,
                                            placeholder: (context, url) =>
                                                Padding(
                                              padding: const EdgeInsets.all(
                                                  offsetBase),
                                              child: Stack(
                                                children: [
                                                  Center(
                                                      child: Image.asset(
                                                    'assets/images/logo.png',
                                                    width: 60.0,
                                                    height: 60.0,
                                                  )),
                                                  Center(
                                                      child:
                                                          CupertinoActivityIndicator()),
                                                ],
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.account_circle,
                                              size: 80,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: offsetBase,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _user.getName(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3,
                                              ),
                                              Text(
                                                '${(_user.getAge() > 100 || _user.getAge() < 1) ? '---' : _user.getAge()} Years',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(fontSize: 16.0),
                                              ),
                                              Spacer(),
                                              Text(
                                                '${S.current.memberSince}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              Text(
                                                _user.reg_date.getDateYMD
                                                    .getDateMY,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: offsetMd,
                                decoration: BoxDecoration(
                                  color: KangaColor().bubbleColor(1.0),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(offsetMd),
                                    topRight: Radius.circular(offsetMd),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: KangaColor().bubbleColor(1),
                          padding: EdgeInsets.only(
                              bottom: offsetBase,
                              left: offsetBase,
                              right: offsetBase),
                          child: Row(
                            children: [
                              KangaProfileValue(
                                context: context,
                                value: _fallRisk,
                                title: S.current.fallRisk,
                              ),
                              SizedBox(
                                width: offsetSm,
                              ),
                              KangaProfileValue(
                                context: context,
                                value: _classNo,
                                title: S.current.noOfClasses,
                              ),
                              SizedBox(
                                width: offsetXMd,
                              ),
                              InkWell(
                                onTap: () async {
                                  var appInfo =
                                      await PrefProvider().getAppInfo();
                                  print('[Profile] $appInfo');
                                  var googleStoreLink =
                                      appInfo['google'] ?? 'Google Store Link';
                                  var appleStoreLink =
                                      appInfo['apple'] ?? 'Apple Store Link';
                                  Share.share(
                                    '${S.current.shareAppContent}\nAppStore Link: $appleStoreLink\nGoogle Store Link: $googleStoreLink',
                                    subject: S.current.kangaBalance,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.group_add_sharp,
                                      color: KangaColor.kangaButtonBackColor,
                                    ),
                                    Text(
                                      S.current.invite,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            color:
                                                KangaColor.kangaButtonBackColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 0.5,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(offsetBase),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.current.achievements,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  InkWell(
                                    onTap: () => NavigatorProvider.of(context)
                                        .pushToWidget(
                                      screen: AchieveScreen(
                                        classIndex: _achieveIndex,
                                        monthIndex: _user.monthIndex(),
                                      ),
                                    ),
                                    child: Text(
                                      S.current.seeAll,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: offsetBase,
                              ),
                              _achieveIndex < 0
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: offsetBase),
                                      child: Text(
                                        S.current.notAwardYet,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    )
                                  : AchieveClass(
                                      context,
                                      achieve: kAchievements[_achieveIndex],
                                      isActive: true,
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          height: 0.5,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(offsetBase),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.current.sessionComplete,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              // Icon(Icons.arrow_drop_up_rounded),
                              for (var session in _sessions) ...{
                                KangaProfileClass(
                                  context: context,
                                  title: session['title'],
                                  value: session['value'],
                                  total: session['total'],
                                ),
                              }
                            ],
                          ),
                        ),
                      ],
                    ),
            )
          : EmptyWidget(context),
    );
  }
}
