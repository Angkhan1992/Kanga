import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/inapp_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/screens/html_view_screen.dart';
import 'package:kanga/screens/more/feedback_screen.dart';
import 'package:kanga/screens/more/membership_screen.dart';
import 'package:kanga/screens/more/share_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var scrollController = ScrollController();
  var options = [];

  String appName = 'Kanga Balance Version: ';
  String appVersion = '1.0';

  InAppModel? _inAppInfo;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      options = [
        {
          'title': S.current.account,
          'items': [
            {
              'title': S.current.memberships,
              'icon': Icon(Icons.account_balance_wallet),
              'switch': false,
              'action': () => _inAppInfo == null
                  ? DialogProvider.of(context).showSnackBar(
                      'Loading items now...',
                      type: SnackBarType.INFO,
                    )
                  : NavigatorProvider.of(context).pushToWidget(
                      screen: MembershipScreen(
                      model: _inAppInfo!,
                    )),
            },
            {
              'title': S.current.appServiceAndDevice,
              'icon': Icon(Icons.app_settings_alt),
              'switch': false,
              'action': () => launch('https://www.kangabalance.com/'),
            },
            {
              'title': S.current.feedback,
              'icon': Icon(Icons.feedback),
              'switch': false,
              'action': () => NavigatorProvider.of(context)
                  .pushToWidget(screen: FeedbackScreen()),
            },
            {
              'title': S.current.share,
              'icon': Icon(Icons.share),
              'switch': false,
              'action': () => NavigatorProvider.of(context)
                  .pushToWidget(screen: ShareScreen()),
            },
          ],
        },
        {
          'title': S.current.preference,
          'items': [
            {
              'title': S.current.emailNotification,
              'icon': Icon(Icons.notifications),
              'switch': true,
              'value': true,
            },
            {
              'title': S.current.pushNotification,
              'icon': Icon(Icons.notifications),
              'switch': true,
              'value': true,
            },
          ],
        },
        {
          'title': S.current.learnMore,
          'items': [
            {
              'title': S.current.privacyPolicy,
              'icon': Icon(Icons.privacy_tip),
              'switch': false,
              'action': () => NavigatorProvider.of(context).pushToWidget(
                  screen: HtmlViewScreen(
                      title: S.current.privacyPolicy,
                      viewType: HtmlViewType.PrivacyPolicy)),
            },
            {
              'title': S.current.termsOfServices,
              'icon': Icon(Icons.bookmark),
              'switch': false,
              'action': () => NavigatorProvider.of(context).pushToWidget(
                  screen: HtmlViewScreen(
                      title: S.current.termsOfServices,
                      viewType: HtmlViewType.TermsService)),
            },
            {
              'title': S.current.logout,
              'icon': Icon(Icons.logout),
              'switch': true,
              'value': null,
              'action': _onLogout,
            },
          ],
        },
      ];
      _initData();
    });

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
      setState(() {});
    });
  }

  void _initData() async {
    setState(() {});
    try {
      var resp = await NetworkProvider.of(context).post(
        Constants.header_profile,
        Constants.link_get_membership,
        {},
      );
      if (resp['ret'] == 10000) {
        _inAppInfo = InAppModel.fromJson(resp['result']);
      }
    } catch (e) {
      DialogProvider.of(context).showSnackBar(
        e.toString(),
        type: SnackBarType.ERROR,
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Container(),
        title: Text(
          S.current.more,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: offsetSm),
          child: Column(
            children: [
              Column(
                children: options.map((option) {
                  return Column(
                    children: [
                      SizedBox(
                        height: offsetSm,
                      ),
                      Padding(
                        child: Row(
                          children: [
                            Text(
                              option['title'],
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Spacer(),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: offsetMd, vertical: offsetBase),
                      ),
                      Container(
                        color: KangaColor().textGreyColor(0.3),
                        child: ListView.separated(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: (option['items'] as List).length,
                          itemBuilder: (context, i) {
                            var item = (option['items'] as List)[i];
                            return InkWell(
                              onTap: item['action'],
                              child: Container(
                                height: 52.0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: offsetMd,
                                ),
                                child: Row(
                                  children: [
                                    item['icon'],
                                    SizedBox(
                                      width: offsetBase,
                                    ),
                                    Expanded(
                                      child: Text(
                                        item['title'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                      ),
                                    ),
                                    !item['switch']
                                        ? Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12.0,
                                          )
                                        : item['value'] == null
                                            ? Container()
                                            : Container(
                                                height: 12.0,
                                                child: CupertinoSwitch(
                                                  value: item['value'],
                                                  activeColor: KangaColor()
                                                      .pinkButtonColor(1),
                                                  trackColor: KangaColor()
                                                      .accentColor(1),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      item['value'] =
                                                          !item['value'];
                                                    });
                                                  },
                                                ),
                                              ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: offsetBase),
                              child: Divider(),
                            );
                          },
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
              SizedBox(
                height: offsetBase,
              ),
              Text(
                '$appName$appVersion',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: KangaColor().textGreyColor(1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogout() async {
    await PrefProvider().setToken('');
    Navigator.of(context)
        .pushReplacementNamed(Constants.route_onboard, arguments: 0);
  }
}
