import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // bool _notificationsEnabled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: AppTextStyle.homeAppbarTextStyle,
        ),
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        backgroundColor: appColor,
        iconTheme: IconThemeData(color: primaryWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // StreamBuilder<DocumentSnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection('settings')
            //       .doc('showGrandTotal')
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return Center(child: CircularProgressIndicator());
            //     }

            //     if (!snapshot.data!.exists) {
            //       FirebaseFirestore.instance
            //           .collection('settings')
            //           .doc('showGrandTotal')
            //           .set({
            //         'enabled': false,
            //       });
            //       return SizedBox();
            //     }

            //     bool showGrandTotal = snapshot.data!.get('enabled');

            //     return Center(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: <Widget>[
            //           SwitchListTile(
            //             activeColor: appColor,
            //             title: Text('Show Grand Total'),
            //             value: showGrandTotal,
            //             onChanged: (bool value) async {
            //               await FirebaseFirestore.instance
            //                   .collection('settings')
            //                   .doc('showGrandTotal')
            //                   .update({
            //                 'enabled': value,
            //               });

            //               if (value) {
            //                 _startCountdown();
            //               }
            //             },
            //           ),
            //           SizedBox(height: 20),
            //         ],
            //       ),
            //     );
            //   },
            // ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('settings')
                  .doc('showNotification')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.data!.exists) {
                  FirebaseFirestore.instance
                      .collection('settings')
                      .doc('   ')
                      .set({
                    'enabled': true,
                  });
                  return SizedBox();
                }

                bool showNotification = snapshot.data!.get('enabled');

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SwitchListTile(
                        activeColor: appColor,
                        title: Text('Show Notification'),
                        value: showNotification,
                        onChanged: (bool value) async {
                          await FirebaseFirestore.instance
                              .collection('settings')
                              .doc('showNotification')
                              .update({
                            'enabled': value,
                          });
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('settings')
                  .doc('showNotificationEnable')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.data!.exists) {
                  FirebaseFirestore.instance
                      .collection('settings')
                      .doc('   ')
                      .set({
                    'enabled': true,
                  });
                  return SizedBox();
                }

                bool showNotification = snapshot.data!.get('enabled');

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SwitchListTile(
                        activeColor: appColor,
                        title: Text('Show Notification'),
                        value: showNotification,
                        onChanged: (bool value) async {
                          await FirebaseFirestore.instance
                              .collection('settings')
                              .doc('showNotification')
                              .update({
                            'enabled': value,
                          });
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('settings')
                  .doc('showNotificationSound')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.data!.exists) {
                  FirebaseFirestore.instance
                      .collection('settings')
                      .doc('showNotificationSound')
                      .set({
                    'enabled': true,
                  });
                  return SizedBox();
                }

                bool showNotification = snapshot.data!.get('enabled');

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SwitchListTile(
                        activeColor: appColor,
                        title: Text('Notification sound'),
                        value: showNotification,
                        onChanged: (bool value) async {
                          await FirebaseFirestore.instance
                              .collection('settings')
                              .doc('showNotificationSound')
                              .update({
                            'enabled': value,
                          });
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // void _startCountdown() {
  //   _timer = Timer.periodic(Duration(seconds: 15), (Timer timer) {
  //     setState(() {
  //       timer.cancel();
  //       _updateGrandTotalPreference(false);
  //     });
  //   });
  // }

  // void _updateGrandTotalPreference(bool value) async {
  //   await FirebaseFirestore.instance
  //       .collection('settings')
  //       .doc('showGrandTotal')
  //       .update({
  //     'enabled': value,
  //   });
  // }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }
}
