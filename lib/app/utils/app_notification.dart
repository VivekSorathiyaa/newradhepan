// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:tap_digital/main.dart';

// class AppNoification {
//   Future initTOken() async {
//     await getFcmToken();
//   }

//   Future getFcmToken() async {
//     String FCMTOken = await FirebaseMessaging.instance.getToken() ?? "";
//     dataStorages.write("FCM", FCMTOken);
//     return FCMTOken;
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_utils/src/platform/platform.dart';

import '../app.dart';

class AppNotfication {
  static const notificationChannelId = "radhe";

  Future initNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    print('User granted permission: ${settings.authorizationStatus}');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      // notificationCategories: darwinNotificationCategories,
    );

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    androidNotificationChannel = const AndroidNotificationChannel(
      notificationChannelId, //'''agenda_boa_notification_channel', // id
      'radhe', // title
      description: 'Channel to show the app notifications.',
      // description
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );
    // create the channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    startBackGroundNotification();
  }

  static final firebaseMsg = FirebaseMessaging.instance;

  Future startBackGroundNotification() async {
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundmsg);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidInitializationSettings initializationSettingsAndroid;

  // create a notification channel in Android
  late AndroidNotificationChannel androidNotificationChannel;
}

//fcm bg. notifications
Future firebaseBackgroundmsg(RemoteMessage message) async {
  log("messagevvvvvv");

  log(message.notification!.title.toString());
}
