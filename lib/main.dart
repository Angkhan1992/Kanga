import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'package:kanga/providers/inject_provider.dart';
import 'package:kanga/providers/router_provider.dart';
import 'package:kanga/providers/socket_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/utils/constants.dart';

import 'generated/l10n.dart';

Injector? injector;
SocketProvider? socketService;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context!)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class AppInitializer {
  initialise(Injector injector) async {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initBadge();

  InjectProvider().initialise(Injector());
  injector = Injector();
  await AppInitializer().initialise(injector!);

  // HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: getThemeData(),
      initialRoute: Constants.route_splash,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: RouterProvider.getRoutes(),
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  getThemeData() {
    return ThemeData(
      fontFamily: 'Muli',
      brightness: Brightness.dark,
      primaryColor: KangaColor().bubbleConnerColor(1),
      secondaryHeaderColor: KangaColor().mainDarkColor(1),
      scaffoldBackgroundColor: KangaColor().mainDarkColor(1),
      backgroundColor: KangaColor().mainDarkColor(1),
      hintColor: KangaColor().secondDarkColor(1),
      focusColor: KangaColor().accentDarkColor(1),
      textTheme: TextTheme(
        headline6: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
            color: KangaColor().secondDarkColor(1)),
        headline5: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: KangaColor().secondDarkColor(1)),
        headline4: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: KangaColor().secondDarkColor(1)),
        headline3: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: KangaColor().secondDarkColor(1)),
        headline2: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
            color: KangaColor().secondDarkColor(1)),
        headline1: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
            color: KangaColor().secondDarkColor(1)),
        subtitle1: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: KangaColor().secondDarkColor(1)),
        bodyText2: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
            color: KangaColor().secondDarkColor(1)),
        bodyText1: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: KangaColor().secondDarkColor(1)),
        caption:
            TextStyle(fontSize: 14.0, color: KangaColor().secondDarkColor(0.6)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: KangaColor().textGreyColor(0.2),
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(
        color: Color(0xFFDEDEDE),
        thickness: 0.5,
      ),
    );
  }
}
