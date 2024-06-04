import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
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
  await Firebase.initializeApp(
      // options: FirebaseOptions(
      //     apiKey: 'AIzaSyBsJQvq0Rts7fzbr8LBdahuYVt-s1u-6sA',
      //     appId: '1:789002921776:android:42976942c9afc039e6caf5',
      //     messagingSenderId: '789002921776',
      //     projectId: 'radhe-1fec0')
      );
  AppNotfication().initNotification();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  GestureBinding.instance.resamplingEnabled = true; // Set this flag.
  NetworkDioHttp.setDynamicHeader(
    endPoint: AppConstants.apiEndPoint.toString(),
  );
  runApp(const RadheApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
