import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radhe/app/components/buttons/text_button.dart';
import 'package:radhe/app/components/common_methos.dart';
import 'package:radhe/app/components/custom_dialog.dart';
import 'package:radhe/app/components/input_text_field_widget.dart';
import 'package:radhe/app/controller/auth_controller.dart';
import 'package:radhe/app/controller/data_controller.dart';
import 'package:radhe/app/utils/app_text_style.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/utils/static_decoration.dart';
import 'package:radhe/app/utils/validator.dart';
import 'package:radhe/app/widget/shodow_container_widget.dart';
import 'package:radhe/models/user_model.dart';

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
          accessToken: '')
      .obs;

  @override
  void initState() {
    refreshPage();
    super.initState();
  }

  refreshPage() async {
    if (!widget.isAdmin) {
      final UserModel? user =
          await authController.getUserById(widget.user.createdBy);
      adminUserModel.value = user ?? adminUserModel.value;
    } else {
      final UserModel? currentUser = await authController.getCurrentUser();
      adminUserModel.value = currentUser ??
          adminUserModel
              .value; // Provide a default UserModel or adjust as necessary
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
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.name,
              style: AppTextStyle.homeAppbarTextStyle,
            ),
            Obx(
              () => Text(
                adminUserModel.value.businessName,
                style:
                    AppTextStyle.normalRegular14.copyWith(color: primaryWhite),
              ),
            ),
          ],
        ),
        actions: [
          StreamBuilder<double>(
            stream: controller.getTotalExpenseStream(
                widget.user.id), // Assuming you have userId available
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(); // Show loading indicator while fetching data
              } else if (snapshot.hasError) {
                return SizedBox();
              } else {
                double totalExpense = snapshot.data ??
                    0.0; // Get total expense from snapshot data
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total', // Display the total expense
                        style: AppTextStyle.normalRegular14
                            .copyWith(color: primaryWhite),
                      ),
                      Text(
                        '${totalExpense.round()}', // Display the total expense
                        style: AppTextStyle.normalBold16
                            .copyWith(color: primaryWhite),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          // if (!widget.isAdmin)
          IconButton(
              onPressed: () {
                CommonDialog.showConfirmationDialog(
                    onOkPress: () {
                      Get.back();
                      authController.signOut();
                    },
                    context: context);
              },
              icon: Icon(Icons.logout))
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
                      return Center(child: Text('No expenses found'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return InkWell(
                          onTap: () {
                            CommonDialog.showSimpleDialog(
                                title: "Options",
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      PrimaryTextButton(
                                          title: "Edit",
                                          onPressed: () async {
                                            amountController.text =
                                                expense.amount.toString();
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
                                                              context: context,
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
                                                      controller.deleteExpense(
                                                          expenseId: expense.id,
                                                          context: context);
                                                      setState(() {});
                                                    },
                                                    context: context);
                                          }),
                                    ],
                                  ),
                                ),
                                context: context);
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
                                  flex: 4,
                                  child: Text(
                                    '₹ ${expense.amount.round()}',
                                    style: AppTextStyle.normalBold14,
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    '${CommonMethod.formatDate(expense.date)}',
                                    style: AppTextStyle.normalRegular14
                                        .copyWith(color: hintGrey),
                                  ),
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
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
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
                            amount: double.parse(amountController.text),
                            context: context,
                            userModel: widget.user)
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
