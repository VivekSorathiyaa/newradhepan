import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/authentication/login_screen.dart';
import 'pages/main_home_screen.dart';

User? currentUser = FirebaseAuth.instance.currentUser;

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class RadheApp extends StatefulWidget {
  const RadheApp({Key? key}) : super(key: key);

  @override
  _RadheAppState createState() => _RadheAppState();
}

class _RadheAppState extends State<RadheApp> with WidgetsBindingObserver {
  late FirebaseMessaging messaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late TextToSpeech tts; // Initialize TTS object

  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsIOS =
      const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );

  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    tts = TextToSpeech(); // Initialize TTS object
    messaging.getToken().then((deviceToken) {
      setToken(deviceToken);
      notificationConfiguration();
    });
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    _configureSelectNotificationSubject();
  }

  setToken(String? deviceToken) async {
    // Do something with the device token if needed
  }

  notificationPermission() async {
    await Permission.notification.isGranted.then((value) async {
      if (!value) {
        await Permission.notification.request();
      }
    });
  }

  notificationConfiguration() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            selectNotificationStream.add(notificationResponse.payload);
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        log("---onMessage----");
        RemoteNotification? notification = message.notification;
        if (notification != null) {
          showNotification(notification.title!, notification.body!,
              json.encode(message.data));

          DocumentSnapshot document = await FirebaseFirestore.instance
              .collection('settings')
              .doc('showNotificationSound')
              .get();

          if (document['enabled']) {
            speakNotification(notification.body!);
          } // Speak notification text
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        selectNotificationStream.add(json.encode(message.data));
      },
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      TextToSpeech tts =
          TextToSpeech(); // Initialize TTS object in background handler
      await tts.setLanguage('en-IN');
      // await tts.setRate(
      //     0.8); // Decrease the speech rate to 0.5 (half the normal speed)
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('settings')
          .doc('showNotificationSound')
          .get();

      if (document['enabled']) {
        await tts.speak(notification.body!);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    selectNotificationStream.close();
    tts.stop(); // Stop TTS when app is disposed
    super.dispose();
  }

  showNotification(String title, String message, dynamic payload) async {
    var android = const AndroidNotificationDetails(
      'channel id',
      'channel NAME',
      channelDescription: 'CHANNEL DESCRIPTION',
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
    );
    var iOS = const DarwinNotificationDetails();
    var platform = NotificationDetails(iOS: iOS, android: android);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platform,
      payload: payload,
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payLoadData) async {
      print("----payLoadData----$payLoadData");
      if (payLoadData == null) {
        // Handle null payload
      } else {
        dynamic payload = await json.decode(payLoadData);
        // Handle payload according to your requirements
      }
    });
  }

  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "navigator");

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Shop Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: currentUser != null ? MainHomeScreen() : LoginScreen(),
    );
  }

  void speakNotification(String message) async {
    // await tts.setLanguage('en-US'); // Set language for TTS
    await tts.setLanguage('en-IN');
    // await tts.setRate(
    //     0.8); // Decrease the speech rate to 0.5 (half the normal speed)

    // await tts.setRate(1.0); // Set speech rate
    await tts.speak(message); // Speak the message
  }
}
