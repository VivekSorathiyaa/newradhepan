import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:radhe/app/controller/data_controller.dart';

import '../../models/expenses_model.dart';
import '../../models/user_model.dart';
import '../components/common_methos.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/static_decoration.dart';
import '../widget/shodow_container_widget.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var dataController = Get.put(DataController());

  @override
  void initState() {
    dataController.getAllExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                StreamBuilder<List<ExpenseModel>>(
                  stream: dataController.getAllExpenses(),
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
                            color: appColor,
                            borderColor: appColor,
                            padding: 0,
                            widget: Column(
                              children: [
                                FutureBuilder<UserModel?>(
                                  future: dataController
                                      .getUserModel(expense.userId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox();
                                    } else if (snapshot.hasError) {
                                      return SizedBox();
                                    } else if (snapshot.hasData) {
                                      UserModel? userModel = snapshot.data;
                                      if (userModel != null) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${userModel.name}',
                                                  style: AppTextStyle
                                                      .italicRegular15
                                                      .copyWith(
                                                          color: primaryWhite),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${userModel.phone}',
                                                  style: AppTextStyle
                                                      .italicRegular15
                                                      .copyWith(
                                                          fontFamily: '',
                                                          color: primaryWhite),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Text('User not found');
                                      }
                                    } else {
                                      return Text(
                                          'No data available'); // No data available in Firestore
                                    }
                                  },
                                ),
                                ShadowContainerWidget(
                                    padding: 10,
                                    customRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                    blurRadius: 0,
                                    borderColor: Colors.transparent,
                                    widget: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Amount : ${expense.amount}',
                                          style: AppTextStyle.italicRegular15
                                              .copyWith(fontFamily: ""),
                                        ),
                                        // Text(
                                        //   'Remark : ${expense.description}',
                                        //   style: AppTextStyle.normalRegular14,
                                        // ),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Text(
                                              'Date : ${CommonMethod.formatDate(expense.date)}',
                                              style: AppTextStyle
                                                  .italicRegular15
                                                  .copyWith(
                                                      color: hintGrey,
                                                      fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            ),
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
        ],
      ),
    );
  }
}
