import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/firestore/v1.dart';
import 'package:flutter/services.dart';

class NotificationService {
  final FirebaseAuth authUser = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> updateUserToken(String userId) async {
    try {
      // Request permission to receive notifications and get device token concurrently
      final NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        throw Exception("User denied notification permission");
      }

      final deviceTokenFuture = _firebaseMessaging.getToken();
      final serviceAccountKeyPath = 'assets/service_account_key.json';

      // Get OAuth 2.0 Access Token using Service Account
      final credentialsFuture =
          rootBundle.loadString(serviceAccountKeyPath).then((key) {
        final credentials =
            auth.ServiceAccountCredentials.fromJson(jsonDecode(key));
        return auth.clientViaServiceAccount(credentials,
            ['https://www.googleapis.com/auth/firebase.messaging']);
      });

      final results = await Future.wait([deviceTokenFuture, credentialsFuture]);
      final String? deviceToken = results[0] as String?;
      final auth.AutoRefreshingAuthClient client =
          results[1] as auth.AutoRefreshingAuthClient;

      if (deviceToken == null) {
        throw Exception("Failed to get device token");
      }

      final accessToken = (await client.credentials).accessToken.data;

      // Update the tokens in Firestore
      await _firestore.collection('users').doc(userId).update({
        'deviceToken': deviceToken,
        'accessToken': accessToken,
      });

      print('Device token and ID token updated successfully');
      print('Device token: $deviceToken');
      return accessToken;
    } catch (e) {
      return null;
      print('Failed to update device token: $e');
    }
  }
// }

  // Future<void> updateUserToken(String userId) async {
  //   try {

  //     // Request permission to receive notifications
  //     NotificationSettings settings =
  //         await _firebaseMessaging.requestPermission(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );

  //     if (settings.authorizationStatus != AuthorizationStatus.authorized) {
  //       throw Exception("User denied notification permission");
  //     }

  //     // Get the device token
  //     String? deviceToken = await _firebaseMessaging.getToken();
  //     if (deviceToken == null) {
  //       throw Exception("Failed to get device token");
  //     }

  //     print('Device token and ID token updated successfully');
  //     print('Device token: $deviceToken');

  //     // Get OAuth 2.0 Access Token using Service Account
  //     String serviceAccountKeyPath =
  //         'assets/service_account_key.json'; // Path to your service account key
  //     final auth.ServiceAccountCredentials credentials =
  //         auth.ServiceAccountCredentials.fromJson(
  //             await rootBundle.loadString(serviceAccountKeyPath));
  //     final auth.AutoRefreshingAuthClient client = await auth
  //         .clientViaServiceAccount(credentials,
  //             ['https://www.googleapis.com/auth/firebase.messaging']);

  //     final accessToken = (await client.credentials).accessToken.data;

  //     // Update the tokens in Firestore
  //     await _firestore.collection('users').doc(userId).update({
  //       'deviceToken': deviceToken,
  //       'accessToken': accessToken,
  //     });
  //   } catch (e) {
  //     print('Failed to update device token: $e');
  //   }
  // }

  Future<void> sendFCMNotification(
      {required String accessToken,
      required String deviceToken,
      required String title,
      required String data}) async {
    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/radhepan-5e6db/messages:send');

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    log("----headers----> ${headers.toString()}");

    final body = jsonEncode({
      'message': {
        'token': deviceToken,
        'notification': {
          'title': title,
          'body': data,
        },
      },
    });

    log("----body----> ${body.toString()}");

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }
}
