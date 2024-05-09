import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:radhe/app/components/buttons/text_button.dart';
import 'package:radhe/app/components/common_methos.dart';
import 'package:radhe/app/components/custom_dialog.dart';
import 'package:radhe/app/components/input_text_field_widget.dart';
import 'package:radhe/app/controller/data_controller.dart';
import 'package:radhe/app/utils/app_text_style.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/utils/static_decoration.dart';
import 'package:radhe/app/utils/validator.dart';
import 'package:radhe/app/widget/shodow_container_widget.dart';
import 'package:radhe/models/user_model.dart';

import '../../models/expenses_model.dart';

class UserExpensesScreen extends StatefulWidget {
  final UserModel user; // ID of the current user

  const UserExpensesScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserExpensesScreen> createState() => _UserExpensesScreenState();
}

class _UserExpensesScreenState extends State<UserExpensesScreen> {
  var controller = Get.put(DataController());
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: primaryWhite), // Set the drawer icon color here
        backgroundColor: appColor,
        title: Text(widget.user.name,
            style:
                AppTextStyle.homeAppbarTextStyle.copyWith(color: primaryWhite)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColor,
        child: Icon(
          Icons.add,
          color: primaryWhite,
        ),
        onPressed: () {
          CommonDialog.showSimpleDialog(
              title: "Add Expense",
              child: Column(
                children: [
                  TextFormFieldWidget(
                    controller: amountController,
                    hintText: "Amount",
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    validator: (value) {
                      Validators.validateDigits(value!, "Amount");
                    },
                  ),
                  height16,
                  TextFormFieldWidget(
                    controller: descriptionController,
                    hintText: "Description",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  height16,
                  PrimaryTextButton(
                      title: "Add",
                      onPressed: () {
                        Get.back();

                        controller
                            .addExpense(
                                amount: double.parse(amountController.text),
                                description: descriptionController.text,
                                userId: widget.user.id,
                                context: context)
                            .whenComplete(() {
                          amountController.clear();
                          descriptionController.clear();
                          setState(() {});
                        });
                      })
                ],
              ),
              context: context);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ShadowContainerWidget(
                color: appColor.withOpacity(.1),
                blurRadius: 0,
                borderColor: appColor,
                widget: StreamBuilder<double>(
                  stream: controller.getTotalExpenseStream(
                      widget.user.id), // Assuming you have userId available
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(); // Show loading indicator while fetching data
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      double totalExpense = snapshot.data ??
                          0.0; // Get total expense from snapshot data
                      return Text(
                        'Total Udhar : $totalExpense', // Display the total expense
                        style: AppTextStyle.normalBold16,
                      );
                    }
                  },
                )),
          ),
          Expanded(
            child: ListView(
              // shrinkWrap: true,
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
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: ShadowContainerWidget(
                              padding: 10,
                              widget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount : ${expense.amount}',
                                    style: AppTextStyle.normalBold14
                                        .copyWith(fontFamily: ""),
                                  ),
                                  Text(
                                    'Remark : ${expense.description}',
                                    style: AppTextStyle.normalRegular14,
                                  ),
                                  Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                        'Date : ${CommonMethod.formatDate(expense.date)}',
                                        style: AppTextStyle.italicRegular15
                                            .copyWith(color: hintGrey),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        );
                      },
                    );
                  },
                ),
                customHeight(100)
              ],
            ),
          ),
        ],
      ),
    );
  }
}