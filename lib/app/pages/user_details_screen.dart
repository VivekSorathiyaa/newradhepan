import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopbook/app/utils/app_text_style.dart';
import 'package:shopbook/app/utils/colors.dart';
import 'package:shopbook/models/user_model.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Details",
          style: AppTextStyle.homeAppbarTextStyle,
        ),
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        backgroundColor: appColor,
        iconTheme: IconThemeData(color: primaryWhite),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.user.imageUrl),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  widget.user.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text(widget.user.phone),
                      ),
                      ListTile(
                        leading: Icon(Icons.business_rounded),
                        title: Text(widget.user.businessName),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Security Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.security),
                        title: Text(widget.user.password),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.user.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          var userDoc = snapshot.data!;
                          if (!userDoc.exists) {
                            _initializeUserDoc(widget.user.id);
                            return Center(child: CircularProgressIndicator());
                          }

                          Map<String, dynamic> data =
                              userDoc.data() as Map<String, dynamic>;
                          bool showTotal = data['showTotal'] ?? false;

                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ListTile(
                                  // leading: Icon(Icons.timelapse_sharp),
                                  title: SwitchListTile(
                                    activeColor: appColor,
                                    title: Text('Show Total'),
                                    value: showTotal,
                                    onChanged: (bool value) async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.user.id)
                                          .update({
                                        'showTotal': value,
                                      });

                                      if (value) {
                                        _startCountdown();
                                      }
                                    },
                                  ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 10), () {
      setState(() {
        _updateTotalPreference(false);
      });
    });
  }

  void _updateTotalPreference(bool value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.id)
        .update({
      'showTotal': value,
    });
  }

  Future<void> _initializeUserDoc(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'showTotal': false,
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
