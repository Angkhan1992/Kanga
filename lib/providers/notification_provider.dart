import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kanga/utils/constants.dart';

class NotificationProvider {
  static const keyMessageChannel = 'key_message';
  static const keyNotificationChannel = 'key_notification';

  final BuildContext context;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationProvider(this.context);

  static NotificationProvider of(BuildContext context) {
    return NotificationProvider(context);
  }

  void init() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('show_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(dynamic payload) async {
    print('notification service ===> $payload');
    // switch (payload) {
    //   case keyFriendRequest:
    //     NavigatorService(context).pushToWidget(screen: RequestScreen());
    //     break;
    //   case keyFriendAccept:
    //     NavigatorService(context).pushToWidget(screen: FriendListScreen());
    //     break;
    // }
    if (payload == keyMessageChannel) {
      // NavigatorService(context).pushToWidget(screen: FriendListScreen());
    }
  }

  static void showNotification(
      String title, String description, String type) async {
    upgradeBadge();

    var android = AndroidNotificationDetails(
      'id',
      'channel ',
      channelDescription: 'description',
      priority: Priority.high,
      importance: Importance.max,
    );
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(
      android: android,
      iOS: iOS,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      description,
      platform,
      payload: type,
    );
  }
}
