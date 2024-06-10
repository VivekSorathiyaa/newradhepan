// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:shopbook/app/pages/authentication/login_screen.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shopbook/app/utils/app_text_style.dart';
// import 'package:shopbook/app/utils/colors.dart';
// import 'package:shopbook/app/utils/static_decoration.dart';
// import 'package:shopbook/app/utils/ui.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// import '../utils/global_singlton.dart';
// import 'main_home_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   late FirebaseMessaging messaging;
//   static final dataStorage = GetStorage();
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final AndroidInitializationSettings initializationSettingsAndroid =
//       const AndroidInitializationSettings('@mipmap/ic_launcher');
//   final DarwinInitializationSettings initializationSettingsIOS =
//       const DarwinInitializationSettings(
//     requestSoundPermission: true,
//     requestBadgePermission: true,
//     requestAlertPermission: true,
//   );

//   Future onSelectNotification(String? payLoadData) async {
//     log("===payload===   $payLoadData");
//     if (payLoadData == null) {
//       // await Get.to(const NotificationScreen());
//     } else {
//       dynamic payload = await json.decode(payLoadData);
//       if (payload['type'] == "0" || payload['type'] == 0) {
//         // await openVideo(payload['videoId']);
//       } else if (payload['type'] == "1" || payload['type'] == 1) {
//         // await openVideo(payload['videoId'].toString());
//       } else {
//         // await Get.to(const NotificationScreen());
//       }
//     }
//   }

//   setToken(String? deviceToken) async {
//     dataStorage.write('FCMToken', deviceToken.toString());
//     GlobalSingleton().deviceToken = deviceToken.toString();
//   }

//   Timer? timer;
//   @override
//   void dispose() {
//     super.dispose();
//     timer?.cancel();
//   }

//   @override
//   void initState() {
//     startTime();
//     super.initState();
//     messaging = FirebaseMessaging.instance;
//     messaging.getToken().then((deviceToken) {
//       setToken(deviceToken);
//     });
//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//     //   getLocation();
//     // });
//   }

//   notifcationPermistion() async {
//     await Permission.notification.request();
//   }

//   startTime() async {
//     timer = Timer(
//       const Duration(milliseconds: 1000),
//       () async {
//         User? currentUser = FirebaseAuth.instance.currentUser;
//         if (currentUser != null) {
//           Get.offAll(() => MainHomeScreen());
//         } else {
//           Get.offAll(() => LoginScreen());
//         }
//         // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//         //   notifcationPermistion();
//         //   getLocation();
//         // });
//       },
//     );
//   }

//   getLocation() async {
//     // if (dataStorage.read('latitude') == null ||
//     //     dataStorage.read('longitude') == null) {
//     //   final Position position = await CommonRepository.getCurrentLocation();
//     //   dataStorage.write('latitude', position.latitude);
//     //   dataStorage.write('longitude', position.longitude);
//     // }

//     await getInitialMessage();
//   }

//   Future getInitialMessage() async {
//     RemoteMessage? fcmMessage;
//     await messaging.getInitialMessage().then((value) {
//       fcmMessage = value;
//     });

//     NotificationAppLaunchDetails? localMessage;
//     await flutterLocalNotificationsPlugin
//         .getNotificationAppLaunchDetails()
//         .then((value) {
//       localMessage = value;
//     });
//     if (fcmMessage == null &&
//         (localMessage?.didNotificationLaunchApp == false)) {
//     } else {
//       onSelectNotification(json.encode(fcmMessage!.data));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: whiteColor,
//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 30),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 2,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: UiInterface.mainLogo()),
//                   // customHeight(20),
//                   Text(
//                     'shop book',
//                     style: AppTextStyle.normalBold50.copyWith(color: appColor),
//                     textAlign: TextAlign.center,
//                   ),
//                   customHeight(40),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Text(
//                   'Copyright © 2008-2025 shop book',
//                   textAlign: TextAlign.center,
//                   style: AppTextStyle.normalRegular12.copyWith(color: hintGrey),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
