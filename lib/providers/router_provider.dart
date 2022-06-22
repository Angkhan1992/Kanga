import 'package:flutter/material.dart';
import 'package:kanga/screens/auth/onboard_screen.dart';
import 'package:kanga/screens/main_screen.dart';
import 'package:kanga/screens/splash_screen.dart';
import 'package:kanga/utils/constants.dart';

class RouterProvider {
  static getRoutes() {
    return <String, WidgetBuilder>{
      Constants.route_splash: (context) => SplashScreen(),
      Constants.route_onboard: (context) => OnBoardScreen(),
      Constants.route_main: (context) => MainScreen(),
    };
  }
}
