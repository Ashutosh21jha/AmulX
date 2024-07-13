import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String deviceToken = '';

  void initLocalNotifications(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {});
  }

  void requestPermission() async {
    await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
  }

  Future<void> getDeviceToken() async {
    deviceToken = await _firebaseMessaging.getToken() ?? "";
    Get.find<Logger>().i('Device Token  => $deviceToken');
  }

  Future<void> checkForTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      deviceToken = token;
      print('onTokenRefresh: $token');
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(180000).toString(), // id
      'High Importance Notifications', // title
      importance: Importance.max,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(channel.id, channel.name,
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    Future.delayed(
        Duration.zero,
        () => _flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title!,
            message.notification!.body!,
            notificationDetails));
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // String title = message.notification?.title ?? '';
      // String body = message.notification?.body ?? '';

      showNotification(message);
    });
  }
}
