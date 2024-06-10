import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:text_to_speech/text_to_speech.dart';
// import 'package:text_to_speech/text_to_speech.dart';
import 'app/app.dart';
import 'app/utils/app_notification.dart';
import 'utils/app_constants.dart';
import 'utils/network_dio/network_dio.dart';

GlobalKey bottomNavigationGlobaleKey = GlobalKey();
const String adminPassword = "12345678";
const String adminPhone = "9898153998";
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  await Firebase.initializeApp();
  AppNotification().initNotification();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  GestureBinding.instance.resamplingEnabled = true; // Set this flag.
  NetworkDioHttp.setDynamicHeader(
    endPoint: AppConstants.apiEndPoint.toString(),
  );
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundmsg);

  runApp(const RadheApp());
}

Future firebaseBackgroundmsg(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
  TextToSpeech tts = TextToSpeech();
  await tts.setLanguage('en-IN');
  // await tts.setRate(0.8);

  if (message.notification != null) {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('settings')
        .doc('showNotificationSound')
        .get();

    if (document['enabled']) {
      await tts.speak(message.notification!.body ?? '');
    }
    log(message.notification!.title ?? '');
  }
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
