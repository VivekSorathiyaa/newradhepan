import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radhe/app/components/custom_dialog.dart';
import 'package:radhe/app/controller/auth_controller.dart';
import 'package:radhe/app/pages/authentication/create_account_screen.dart';
import 'package:radhe/app/pages/profile_screen.dart';
import 'package:radhe/app/pages/transaction_screen.dart';
import 'package:radhe/app/utils/app_text_style.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/widget/shodow_container_widget.dart';
import 'package:radhe/main.dart';

import 'all_user_screen.dart';
import 'user_expenses_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  var authController = Get.put(AuthController());

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    TransactionScreen(),
    AllUserScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    authController
        .getUserById(authController.auth.currentUser!.uid)
        .whenComplete(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: backgroundColor,
          // appBar: AppBar(
          //   iconTheme: IconThemeData(
          //       color: primaryWhite), // Set the drawer icon color here

          //   backgroundColor: appColor,
          //   title: Text('Radhe Pan - ${authController.currentUserModel.name}',
          //       style: AppTextStyle.homeAppbarTextStyle
          //           .copyWith(color: primaryWhite)),
          //   actions: [
          //     IconButton(
          //         onPressed: () {
          //           CommonDialog.showConfirmationDialog(
          //               onOkPress: () {
          //                 Get.back();
          //                 authController.logoutUser(context);
          //               },
          //               context: context);
          //         },
          //         icon: Icon(
          //           Icons.logout,
          //           color: primaryWhite,
          //         ))
          //   ],
          // ),
          bottomNavigationBar: authController.currentUserModel.phone == adminId
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: appColor.withOpacity(.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: BottomNavigationBar(
                      selectedIconTheme: IconThemeData(
                          color: appColor), // Color of selected icon
                      unselectedIconTheme: IconThemeData(
                          color: Colors.grey), // Color of unselected icon
                      elevation: 13, // Elevation of the bottom navigation bar
                      backgroundColor: Colors
                          .white, // Background color of the bottom navigation bar
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.attach_money),
                          label: 'Transactions',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.people),
                          label: 'Customers',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: 'Profile',
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor:
                          appColor, // Color of the selected item text and icon
                      unselectedLabelStyle: TextStyle(
                          color: Colors.grey), // Style of unselected item label
                      onTap: _onItemTapped,
                    ),
                  ),
                )
              : null,
          body: authController.currentUserModel.phone == adminId
              ? _widgetOptions.elementAt(_selectedIndex)
              : UserExpensesScreen(
                  user: authController.currentUserModel,
                  isAdmin: false,
                )),
    );
  }

  Widget menuTile({required VoidCallback onTap, required String title}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ShadowContainerWidget(
          widget: Text(
            title,
            style: AppTextStyle.normalBold18,
          ),
        ),
      ),
    );
  }
}
