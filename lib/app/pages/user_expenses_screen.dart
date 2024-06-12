import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopbook/app/components/buttons/text_button.dart';
import 'package:shopbook/app/components/common_methos.dart';
import 'package:shopbook/app/components/input_text_field_widget.dart';
import 'package:shopbook/app/controller/auth_controller.dart';
import 'package:shopbook/app/controller/data_controller.dart';
import 'package:shopbook/app/pages/user_details_screen.dart';
import 'package:shopbook/app/utils/app_text_style.dart';
import 'package:shopbook/app/utils/colors.dart';
import 'package:shopbook/app/utils/validator.dart';
import 'package:shopbook/app/widget/shodow_container_widget.dart';
import '../../models/expenses_model.dart';
import '../../models/user_model.dart';
import '../components/custom_dialog.dart';

class UserExpensesScreen extends StatefulWidget {
  final UserModel user;
  final bool isFromAdmin;

  const UserExpensesScreen(
      {Key? key, required this.user, required this.isFromAdmin})
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
      if (!widget.isFromAdmin) {
        final UserModel? adminUser =
            await authController.getUserById(widget.user.createdBy);
        if (adminUser != null) {
          adminUserModel.value = adminUser;
        } else {
          print('Admin user not found');
        }
      } else {
        final UserModel? currentUser = await authController.getCurrentUser();
        if (currentUser != null) {
          adminUserModel.value = currentUser;
        } else {
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
        iconTheme: IconThemeData(color: primaryWhite),
        backgroundColor: appColor,
        title: GestureDetector(
          onTap: () {
            if (widget.isFromAdmin) {
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
              Obx(() => adminUserModel.value.businessName != ''
                  ? Text(
                      adminUserModel.value.businessName,
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: primaryWhite),
                    )
                  : SizedBox()),
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

              if (!showTotal && !widget.isFromAdmin) {
                return SizedBox();
              } else {
                return StreamBuilder<double>(
                  stream: controller.getTotalExpenseStream(widget.user.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox();
                    } else if (snapshot.hasError) {
                      return SizedBox();
                    } else {
                      double totalExpense = snapshot.data ?? 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total',
                              style: AppTextStyle.normalRegular12
                                  .copyWith(color: primaryWhite),
                            ),
                            Text(
                              '${totalExpense.round()}',
                              style: AppTextStyle.normalBold14
                                  .copyWith(color: primaryWhite),
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
          if (widget.isFromAdmin)
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }

                var userDoc = snapshot.data!;
                if (!userDoc.exists) {
                  controller.initializeUserDoc(widget.user.id);
                  return SizedBox();
                }

                Map<String, dynamic> data =
                    userDoc.data() as Map<String, dynamic>;
                bool showTotal = data['showTotal'] ?? false;
                controller.showTotal.value = showTotal;

                return Obx(() => Transform.scale(
                      scale:
                          0.7, // Adjust the scale value to make the switch smaller
                      child: Switch(
                        activeColor: primaryWhite,
                        value: controller.showTotal.value,
                        onChanged: (bool value) async {
                          await controller.updateShowTotal(
                              widget.user.id, value);

                          if (value) {
                            controller.startCountdown(widget.user.id);
                          }
                        },
                      ),
                    ));
              },
            ),
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
                            if (widget.isFromAdmin) {
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
                                                      SizedBox(height: 20),
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
                                                          "Are you sure you want to delete this expense data?",
                                                      onOkPress: () {
                                                        Get.back();
                                                        Get.back();
                                                        controller
                                                            .deleteExpense(
                                                                expenseId:
                                                                    expense.id,
                                                                context:
                                                                    context);
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
                SizedBox(height: 100),
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
                SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    controller
                        .addExpense(
                            authController: authController,
                            amount: int.parse(amountController.text),
                            context: context,
                            senderUser: widget.isFromAdmin
                                ? adminUserModel.value
                                : widget.user,
                            receiverUser: widget.isFromAdmin
                                ? widget.user
                                : adminUserModel.value,
                            customerUser: widget.user)
                        .whenComplete(() {
                      amountController.clear();
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: appColor,
                    child: Icon(
                      Icons.send,
                      color: primaryWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
