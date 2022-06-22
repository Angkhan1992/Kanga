import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/screens/auth/complete_profile_screen.dart';
import 'package:kanga/screens/auth/onboard_screen.dart';
import 'package:kanga/screens/main_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      onCheckData();
    });
  }

  void onCheckData() async {
    var res = await NetworkProvider.of(context).post(Constants.header_auth, Constants.link_login_token, {});
    var appInfo = res['app_info'];
    await PrefProvider().setAppInfo(appInfo);

    if (res['ret'] == 10000) {
      var token = res['result']['token'];
      await PrefProvider().setToken(token);
      var _currentUser = UserModel.fromJson(res['result']);
      await _currentUser.save();

      if (_currentUser.step == '0') {
        NavigatorProvider.of(context).pushToWidget(
          screen: MainScreen(),
          replace: true,
        );
      } else {
        NavigatorProvider.of(context).pushToWidget(
          screen: CompleteProfileScreen(),
          replace: true,
        );
      }
    } else {
      NavigatorProvider(context).pushToWidget(screen: OnBoardScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: KangaColor().mainDarkColor(1),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 150,
            height: 120,
          ),
        ),
      ),
    );
  }
}
