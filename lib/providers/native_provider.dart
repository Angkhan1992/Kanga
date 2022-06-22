import 'package:flutter/services.dart';
import 'package:kanga/utils/constants.dart';

class NativeProvider {
  static const platformSensor = const MethodChannel('$PACKAGENAME/sensor');
  static var platform_apple_sign =
      const MethodChannel('$PACKAGENAME/apple_sign');
  static var platform_calendar = const MethodChannel('$PACKAGENAME/calendar');
  static var platform_apple_video =
      const MethodChannel('$PACKAGENAME/loadVideo');

  void getSensorData(Function(dynamic) returnSensor) async {
    platformSensor.setMethodCallHandler((call) async {
      if (call.method == 'onChanged') {
        returnSensor(call.arguments);
      }
    });
  }

  static Future<String> initAppleSign() async {
    print('init [APPLE]]');
    final result = await platform_apple_sign.invokeMethod('init', '');
    print('[APPLE] response:' + String.fromCharCodes(result));
    return String.fromCharCodes(result);
  }

  static Future<String> addCalendar({
    required String title,
    required String desc,
    required String dateTime,
  }) async {
    final result =
        await platform_calendar.invokeMethod('add', [title, desc, dateTime]);
    return result;
  }

  static Future<String> loadVideoApple(String link) async {
    final result = await platform_apple_video.invokeMethod('play', [link]);
    print('[Native Video] result : $result');
    return result;
  }
}
