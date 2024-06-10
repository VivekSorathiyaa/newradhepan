import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopbook/app/components/image/image_widget.dart';
import 'package:shopbook/app/pages/grand_total_screen.dart';
import 'package:shopbook/app/utils/app_text_style.dart';
import 'package:shopbook/app/utils/colors.dart';
import 'package:shopbook/app/utils/static_decoration.dart';
import 'package:shopbook/app/widget/shodow_container_widget.dart';

import '../components/custom_dialog.dart';
import '../controller/auth_controller.dart';
import 'authentication/create_account_screen.dart';
import 'authentication/notification_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var authController = Get.put(AuthController());

  @override
  void initState() {
    authController.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   title: Text('Profile'),
      // ),
      body: ListView(
        // padding: EdgeInsets.all(20.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: ShadowContainerWidget(
                widget: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: appColor.withOpacity(.2),
                  child: Obx(
                    () => authController.currentUser.value == '' ||
                            authController.currentUser.value == null
                        ? Icon(
                            CupertinoIcons.person,
                            color: appColor,
                          )
                        : NetworkImageWidget(
                            imageUrl: authController.currentUser.value.imageUrl,
                            borderRadius: BorderRadius.circular(30),
                            fit: BoxFit.cover,
                            width: Get.width,
                            height: Get.height,
                          ),
                  ),
                ),
                width10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          "${authController.currentUser.value.name}",
                          style: AppTextStyle.normalBold16
                              .copyWith(color: appColor),
                        ),
                      ),
                      Obx(
                        () => Text(
                          "${authController.currentUser.value.phone}",
                          style: AppTextStyle.normalRegular14
                              .copyWith(color: primaryBlack, fontFamily: ''),
                        ),
                      ),
                      Obx(() =>
                          authController.currentUser.value.businessName != ""
                              ? Text(
                                  "${authController.currentUser.value.businessName}",
                                  style: AppTextStyle.normalRegular14
                                      .copyWith(color: appColor),
                                )
                              : SizedBox()),
                    ],
                  ),
                ),
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ShadowContainerWidget(
              padding: 10,
              widget: Column(
                children: [
                  ListTile(
                    title: Text('Edit Profile'),
                    leading: Icon(Icons.edit),
                    onTap: () {
                      Get.to(() => CreateAccountScreen(
                            userModel: authController.currentUser.value,
                          ));
                      // Navigate to Edit Profile screen
                    },
                  ),
                  ListTile(
                    title: Text('Settings'),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Get.to(() => NotificationSettingsScreen());
                      // Navigate to Settings screen
                    },
                  ),
                  ListTile(
                    title: Text('Grand Total'),
                    leading: Icon(Icons.money),
                    onTap: () {
                      Get.to(() => GrandTotalScreen());

                      // Navigate to Grand Total screen
                    },
                  ),
                  ListTile(
                    title: Text('Help & Support'),
                    leading: Icon(Icons.help),
                    onTap: () {
                      // Navigate to Help & Support screen
                    },
                  ),
                  ListTile(
                    title: Text('About Us'),
                    leading: Icon(Icons.info),
                    onTap: () {
                      // Navigate to About Us screen
                    },
                  ),
                  ListTile(
                    title: Text('Privacy Policy'),
                    leading: Icon(Icons.privacy_tip),
                    onTap: () {
                      // Navigate to Privacy Policy screen
                    },
                  ),
                  ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.logout),
                    onTap: () {
                      CommonDialog.showConfirmationDialog(
                          onOkPress: () {
                            Get.back();
                            authController.logoutUser(context);
                          },
                          context: context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
