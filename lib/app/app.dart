import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radhe/app/pages/splash_screen.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/utils/global_singlton.dart';
import '../main.dart';
import '../utils/app_constants.dart';
import '../utils/repository/network_repository.dart';
import 'components/common_methos.dart';

final dataStorage = GetStorage();

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
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
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
  // Timer? _timer;
  late FirebaseMessaging messaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // final homeScreenController = Get.put(HomeScreenController());
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsIOS =
      const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );

  // final appLocationController = Get.put(UserInAppLocation());

  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((deviceToken) {
      setToken(deviceToken);
      notificationConfiguration();
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _configureSelectNotificationSubject();
  }

  setToken(String? deviceToken) async {
    dataStorage.write('FCMToken', deviceToken.toString());
    GlobalSingleton().deviceToken = deviceToken.toString();
  }

  notificationPermision() async {
    await Permission.notification.isGranted.then((value) async {
      if (value) {
        await Permission.notification.request();
      } else {
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
    // await flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    //   onSelectNotification: onSelectNotification,
    // );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            // if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
            // }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        if (notification != null) {
          // await homeScreenController.getNotificationCount();
          showNotification(notification.title!, notification.body!,
              json.encode(message.data));
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        // onSelectNotification(json.encode(message.data));
        selectNotificationStream.add(json.encode(message.data));
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    // _timer?.cancel();
    selectNotificationStream.close();
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   log("---life--->> ${state}");
  //   if (state == AppLifecycleState.paused) {
  //     _timer = Timer(Duration(minutes: 1), () {
  //       // Restart the app
  //       log("Restart Application");
  //       SystemNavigator.pop();
  //       runApp(RadheApp());
  //     });
  //   } else if (state == AppLifecycleState.resumed) {
  //     _timer?.cancel();
  //   }
  // }

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
      log("===payLoadData===   $payLoadData");
      if (payLoadData == null) {
        // await Get.to(const NotificationScreen());
      } else {
        dynamic payload = await json.decode(payLoadData);
        if (payload['type'] == "0" || payload['type'] == 0) {
          // await openVideo(payload['videoId'].toString());
        } else if (payload['type'] == "1" || payload['type'] == 1) {
          // await openVideo(payload['videoId'].toString());
        } else {
          // await Get.to(const NotificationScreen());
        }
      }
    });
  }

  // Future onSelectNotification(String? payLoadData) async {
  //   log("===payload===   $payLoadData");
  //   if (payLoadData == null) {
  //     await Get.to(const NotificationScreen());
  //   } else {
  //     dynamic payload = await json.decode(payLoadData);
  //     if (payload['type'] == "0" || payload['type'] == 0) {
  //       await openVideo(payload['videoId'].toString());
  //     } else if (payload['type'] == "1" || payload['type'] == 1) {
  //       await openVideo(payload['videoId'].toString());
  //     } else if (payload['type'] == "2" || payload['type'] == 2) {
  //       await openProfilePage(payload['followerId'].toString());
  //     } else if (payload['type'] == "3" || payload['type'] == 3) {
  //       await openProfilePage(payload['followerId'].toString());
  //     } else if (payload['type'] == "4" || payload['type'] == 4) {
  //       await Get.to(const NotificationScreen());
  //       // await openProfilePage(payload['followerId'].toString());
  //     } else if (payload['type'] == "5" || payload['type'] == 5) {
  //       if (payload['videoId'] != null) {
  //         await openVideo(payload['videoId'].toString());
  //       } else {
  //         await openFeed(payload['feedId'].toString());
  //       }
  //     } else if (payload['type'] == "6" || payload['type'] == 6) {
  //       if (payload['videoId'] != null) {
  //         await openVideo(payload['videoId'].toString());
  //       } else {
  //         await openFeed(payload['feedId'].toString());
  //       }
  //     } else if (payload['type'] == "7" || payload['type'] == 7) {
  //       await Get.to(ChatScreen(
  //         otherId: payload['senderId'].toString(),
  //         image: AppConstants.imageEndPoint + payload['senderImage'].toString(),
  //         roomId: payload['roomId'].toString(),
  //         name: payload['senderName'].toString(),
  //         function: (value) {},
  //       ));
  //     } else if (payload['type'] == "8" || payload['type'] == 8) {
  //       Get.to(() => UserGigDetailScreen(
  //             gigId: payload['gigId'].toString(),
  //             isFromMyListing: false,
  //             isFromGigBiddedOn: true,
  //           ));
  //     } else if (payload['type'] == "9" || payload['type'] == 9) {
  //       await openFeed(payload['feedId'].toString());
  //     } else if (payload['type'] == "10" || payload['type'] == 10) {
  //       await openFeed(payload['videoId'].toString());
  //     } else {
  //       await Get.to(const NotificationScreen());
  //     }
  //   }
  // }

  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "navigator");

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: _navigatorKey,
      title: 'radhe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // backgroundColor: primaryWhite,
        // scaffoldBackgroundColor: primaryWhite,
        fontFamily: 'Catamaran',
        // hintColor: regularGrey,
        // iconTheme: const IconThemeData(
        //   color: regularGrey,
        //   size: 24,
        // ),
        // appBarTheme: const AppBarTheme(
        //   elevation: 1,
        //   // ignore: deprecated_member_use
        //   // textTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
        //   backgroundColor: primaryWhite,
        //   // foregroundColor: titleBlack,
        //   centerTitle: true,
        // ),
      ),
      home: const SplashScreen(),
    );
  }
}
