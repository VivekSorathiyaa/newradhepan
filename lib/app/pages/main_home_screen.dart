import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:radhe/app/components/custom_dialog.dart';
import 'package:radhe/app/controller/auth_controller.dart';
import 'package:radhe/app/pages/authentication/create_account_screen.dart';
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
  var authController = Get.put(AuthController());

  @override
  void initState() {
    authController
        .getUserById(authController.auth.currentUser!.uid)
        .whenComplete(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: primaryWhite), // Set the drawer icon color here

          backgroundColor: appColor,
          title: Text('Radhe Pan - ${authController.currentUserModel.name}',
              style: AppTextStyle.homeAppbarTextStyle
                  .copyWith(color: primaryWhite)),
          actions: [
            IconButton(
                onPressed: () {
                  CommonDialog.showConfirmationDialog(
                      onOkPress: () {
                        Get.back();
                        authController.logoutUser(context);
                      },
                      context: context);
                },
                icon: Icon(
                  Icons.logout,
                  color: primaryWhite,
                ))
          ],
        ),
        body: authController.currentUserModel.phone == adminId
            ? AllUserScreen()
            : UserExpensesScreen(
                user: authController.currentUserModel,
              ));
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
