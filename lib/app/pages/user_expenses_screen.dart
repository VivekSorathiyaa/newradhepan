import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopbook/app/components/buttons/text_button.dart';
import 'package:shopbook/app/components/common_methos.dart';
import 'package:shopbook/app/components/custom_dialog.dart';
import 'package:shopbook/app/components/input_text_field_widget.dart';
import 'package:shopbook/app/controller/auth_controller.dart';
import 'package:shopbook/app/controller/data_controller.dart';
import 'package:shopbook/app/pages/user_details_screen.dart';
import 'package:shopbook/app/utils/app_text_style.dart';
import 'package:shopbook/app/utils/colors.dart';
import 'package:shopbook/app/utils/static_decoration.dart';
import 'package:shopbook/app/utils/validator.dart';
import 'package:shopbook/app/widget/shodow_container_widget.dart';
import 'package:shopbook/models/user_model.dart';

import '../../models/expenses_model.dart';

class UserExpensesScreen extends StatefulWidget {
  final UserModel user;
  final bool isAdmin;

  const UserExpensesScreen(
      {Key? key, required this.user, required this.isAdmin})
      : super(key: key);

  @override
  State<UserExpensesScreen> createState() => _UserExpensesScreenState();
}

class _UserExpensesScreenState extends State<UserExpensesScreen> {
  var controller = Get.put(DataController());
  var authController = Get.put(AuthController());
  final TextEditingController amountController = TextEditingController();
  Rx<UserModel> adminUserModel = UserModel(
          id: "",
          name: "",
          phone: "",
          createdBy: "",
          password: "",
          businessName: '',
          deviceToken: '',
          imageUrl: '',
          accessToken: '',
          showTotal: false)
      .obs;

  @override
  void initState() {
    refreshPage();
    super.initState();
  }

  Future<void> refreshPage() async {
    try {
      if (!widget.isAdmin) {
        final UserModel? adminUser =
            await authController.getUserById(widget.user.createdBy);
        if (adminUser != null) {
          adminUserModel.value = adminUser;
        } else {
          // Handle the case when the admin user is not found
          print('Admin user not found');
        }
      } else {
        final UserModel? currentUser = await authController.getCurrentUser();
        if (currentUser != null) {
          adminUserModel.value = currentUser;
        } else {
          // Handle the case when the current user is not found
          print('Current user not found');
        }
      }
    } catch (e) {
      print('Error refreshing page: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    refreshPage();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: primaryWhite), // Set the drawer icon color here
        backgroundColor: appColor,
        // titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            if (widget.isAdmin) {
              Get.to(() => UserDetailScreen(
                    user: widget.user,
                  ));
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: AppTextStyle.homeAppbarTextStyle,
              ),
              Obx(
                () => adminUserModel.value.businessName != ''
                    ? Text(
                        adminUserModel.value.businessName,
                        style: AppTextStyle.normalRegular14
                            .copyWith(color: primaryWhite),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: widget.user.id.isNotEmpty
                ? FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.user.id)
                    .snapshots()
                : Stream.empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                if (widget.user.id.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.user.id)
                      .set({
                    'showTotal': false,
                  });
                }
                return SizedBox();
              }

              var data = snapshot.data!.data();
              if (data == null ||
                  !(data is Map<String, dynamic>) ||
                  !data.containsKey('showTotal')) {
                if (widget.user.id.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.user.id)
                      .update({'showTotal': false});
                }
                return SizedBox();
              }

              bool showTotal = data['showTotal'];

              if (!showTotal && !widget.isAdmin) {
                return SizedBox();
              } else {
                return StreamBuilder<Map<String, double>>(
                  stream: controller
                      .getTotalExpensesForTodayAndYesterday(widget.user.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          height: 100,
                          child: Center(child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      return SizedBox(
                          height: 100,
                          child: Center(
                              child:
                                  Text('Error: ${snapshot.error.toString()}')));
                    } else {
                      double totalTodayExpense =
                          snapshot.data?['todayTotal'] ?? 0.0;
                      double totalYesterdayExpense =
                          snapshot.data?['yesterdayTotal'] ?? 0.0;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${totalTodayExpense.round()}',
                              style: AppTextStyle.normalBold16
                                  .copyWith(color: primaryWhite),
                            ),
                            Text(
                              '${totalYesterdayExpense.round()}',
                              style: AppTextStyle.normalRegular14.copyWith(
                                  color: primaryWhite.withOpacity(.5)),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              }
            },
          ),

          // if (!widget.isAdmin)
          //   IconButton(
          //       onPressed: () {
          //         CommonDialog.showConfirmationDialog(
          //             onOkPress: () {
          //               Get.back();
          //               authController.signOut();
          //             },
          //             context: context);
          //       },
          //       icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                StreamBuilder<List<ExpenseModel>>(
                  stream: controller.getUserExpenses(widget.user.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: appColor,
                      ));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final expenses = snapshot.data ?? [];
                    if (expenses.isEmpty) {
                      return SizedBox();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return InkWell(
                          onLongPress: () {
                            if (widget.isAdmin) {
                              CommonDialog.showSimpleDialog(
                                  title: "Options",
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        PrimaryTextButton(
                                            title: "Edit",
                                            onPressed: () async {
                                              amountController.text = expense
                                                  .amount
                                                  .round()
                                                  .toString();
                                              setState(() {});

                                              Get.back();
                                              CommonDialog.showSimpleDialog(
                                                  title: "Edit Expense",
                                                  child: Column(
                                                    children: [
                                                      TextFormFieldWidget(
                                                        controller:
                                                            amountController,
                                                        hintText: "Amount",
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                      height20,
                                                      PrimaryTextButton(
                                                          title: "Done",
                                                          onPressed: () async {
                                                            Get.back();
                                                            await controller.updateExpense(
                                                                amount: double.parse(
                                                                    amountController
                                                                        .text),
                                                                userId: expense
                                                                    .userId,
                                                                context:
                                                                    context,
                                                                expenseId:
                                                                    expense.id);

                                                            setState(() {});
                                                          })
                                                    ],
                                                  ),
                                                  context: context);
                                            }),
                                        PrimaryTextButton(
                                            buttonColor: red,
                                            title: "Delete",
                                            onPressed: () async {
                                              await CommonDialog
                                                  .showConfirmationDialog(
                                                      title:
                                                          "Are you sure you want to delete this expense data ?",
                                                      onOkPress: () {
                                                        Get.back();
                                                        Get.back();
                                                        controller
                                                            .deleteExpense(
                                                                expenseId:
                                                                    expense.id,
                                                                context:
                                                                    context);
                                                        setState(() {});
                                                      },
                                                      context: context);
                                            }),
                                      ],
                                    ),
                                  ),
                                  context: context);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            child: ShadowContainerWidget(
                                // padding: 0,

                                widget: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${expense.amount.round()}',
                                    style: AppTextStyle.normalBold14,
                                  ),
                                ),
                                Text(
                                  '${CommonMethod.formatDate(expense.date)}',
                                  style: AppTextStyle.normalRegular14.copyWith(
                                      color: primaryBlack.withOpacity(.5)),
                                ),
                              ],
                            )),
                          ),
                        );
                      },
                    );
                  },
                ),
                customHeight(100)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 12, bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextFormFieldWidget(
                    controller: amountController,
                    hintText: "Enter Value",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      Validators.validateDigits(value!, "Amount");
                    },
                  ),
                ),
                width15,
                InkWell(
                  onTap: () {
                    controller
                        .addExpense(
                            authController: authController,
                            amount: int.parse(amountController.text),
                            context: context,
                            currentUserModel: widget.user,
                            receiverUser: adminUserModel.value)
                        .whenComplete(() {
                      amountController.clear();
                      // descriptionController.clear();
                      setState(() {});
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: appColor,
                    child: Icon(
                      Icons.send,
                      color: primaryWhite,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
