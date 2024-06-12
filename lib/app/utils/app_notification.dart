import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotification {
  static const notificationChannelId = "radhe";
  late AndroidInitializationSettings initializationSettingsAndroid;
  late AndroidNotificationChannel androidNotificationChannel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // Handle local notification tapped logic here
      },
    );

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    androidNotificationChannel = const AndroidNotificationChannel(
      notificationChannelId,
      'radhe',
      description: 'Channel to show the app notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log("-----onMessageonMessage-----");
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;

    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           androidNotificationChannel.id,
    //           androidNotificationChannel.name,
    //           channelDescription: androidNotificationChannel.description,
    //           icon: android.smallIcon,
    //         ),
    //       ),
    //     );
    //   }
    // });
 
 
  }
}
