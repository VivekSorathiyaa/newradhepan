import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:radhe/app/components/buttons/text_button.dart';
import 'package:radhe/app/components/custom_dialog.dart';
import 'package:radhe/app/controller/auth_controller.dart';
import 'package:radhe/app/controller/data_controller.dart';
import 'package:radhe/app/pages/authentication/create_account_screen.dart';
import 'package:radhe/app/utils/static_decoration.dart';
import 'package:radhe/app/widget/shodow_container_widget.dart';

import '../../models/user_model.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import 'user_expenses_screen.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({Key? key}) : super(key: key);

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  final DataController controller = Get.put(DataController());
  final AuthController authController = Get.put(AuthController());
  @override
  void initState() {
    controller.fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColor,
        child: Icon(
          Icons.add,
          color: backgroundColor,
        ),
        onPressed: () {
          Get.to(() => CreateAccountScreen(userModel: null));
        },
      ),
      body: Obx(() {
        if (controller.userList.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: controller.userList.length,
            itemBuilder: (context, index) {
              UserModel user = controller.userList[index];
              return InkWell(
                onTap: () {
                  Get.to(() => UserExpensesScreen(
                        user: user,
                        isAdmin: true,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: ShadowContainerWidget(
                      padding: 0,
                      widget: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShadowContainerWidget(
                              color: appColor,
                              widget: Text(
                                "${index + 1}",
                                style: AppTextStyle.normalBold16
                                    .copyWith(color: primaryWhite),
                              )),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: AppTextStyle.normalBold18,
                                  ),
                                  Text(
                                    "Phone - ${user.phone}",
                                    style: AppTextStyle.normalRegular14
                                        .copyWith(fontFamily: ''),
                                  ),
                                  Text(
                                    "Password - ${user.password}",
                                    style: AppTextStyle.normalRegular14
                                        .copyWith(fontFamily: ''),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              CommonDialog.showSimpleDialog(
                                  title: "Options",
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        PrimaryTextButton(
                                            title: "Edit",
                                            onPressed: () {
                                              Get.to(() => CreateAccountScreen(
                                                  userModel: user));
                                            }),
                                        height20,
                                        PrimaryTextButton(
                                            buttonColor: red,
                                            title: "Delete",
                                            onPressed: () {
                                              CommonDialog
                                                  .showConfirmationDialog(
                                                      title:
                                                          "Are you sure you want to delete this user? This action will permanently remove the user's account and all associated expenses.",
                                                      onOkPress: () {
                                                        Get.back();
                                                        Get.back();
                                                        authController
                                                            .deleteAuthUser(
                                                                context:
                                                                    context,
                                                                userId: user.id,
                                                                phone:
                                                                    user.phone,
                                                                password: user
                                                                    .password);
                                                      },
                                                      context: context);
                                            }),
                                      ],
                                    ),
                                  ),
                                  context: context);
                            },
                          ),
                        ],
                      )),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
