import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shopbook/app/components/simmer/transaction_simmer.dart';
import 'package:shopbook/app/controller/auth_controller.dart';
import 'package:shopbook/app/controller/data_controller.dart';
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
  var authController = Get.put(AuthController());

  @override
  void initState() {
    dataController.getAllExpenses();
    super.initState();
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final yesterday = today.subtract(Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return CommonMethod.formatDate(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Obx(
            () => Text(
              authController.currentUser.value.businessName ?? "Shop Book",
              style: AppTextStyle.homeAppbarTextStyle,
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: appColor,
          actions: [
            StreamBuilder<Map<String, double>>(
              stream: dataController.getTotalExpensesForTodayAndYesterday(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                } else if (snapshot.hasError) {
                  return SizedBox();
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
                          style: AppTextStyle.normalRegular14
                              .copyWith(color: primaryWhite.withOpacity(.5)),
                        ),
                      ],
                    ),
                  );
                }
              },
            )
          ]),
      body: Padding(
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

                      // Group expenses by date
                      Map<String, List<ExpenseModel>> groupedExpenses = {};
                      for (var expense in expenses) {
                        String date = _formatDate(expense.date);
                        if (groupedExpenses[date] == null) {
                          groupedExpenses[date] = [];
                        }
                        groupedExpenses[date]!.add(expense);
                      }

                      return Column(
                        children: groupedExpenses.entries.map((entry) {
                          String date = entry.key;
                          List<ExpenseModel> dailyExpenses = entry.value;
                          double totalAmount = dailyExpenses.fold(
                              0.0, (sum, item) => sum + item.amount);

                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: ShadowContainerWidget(
                              padding: 0,
                              // radius: 0,
                              widget: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        '$date',
                                        style: AppTextStyle.normalBold12
                                            .copyWith(color: appColor),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: dailyExpenses.map((expense) {
                                      return ShadowContainerWidget(
                                        // color: appColor,
                                        // borderColor: appColor,
                                        blurRadius: 0,
                                        radius: 0,
                                        widget: Column(
                                          children: [
                                            FutureBuilder<UserModel?>(
                                              future: dataController
                                                  .getUserModel(expense.userId),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return TransactionSimmer();
                                                } else if (snapshot.hasError) {
                                                  return TransactionSimmer();
                                                } else if (snapshot.hasData) {
                                                  UserModel? userModel =
                                                      snapshot.data;
                                                  if (userModel != null) {
                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 6,
                                                          child: Text(
                                                            '${userModel.name}',
                                                            style: AppTextStyle
                                                                .normalRegular14,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${CommonMethod.formatTime(expense.date)}',
                                                          style: AppTextStyle
                                                              .normalRegular12
                                                              .copyWith(
                                                                  color: grey),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            '+ ${expense.amount.round()}',
                                                            style: AppTextStyle
                                                                .normalRegular14,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.end,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return Text(
                                                        'User not found');
                                                  }
                                                } else {
                                                  return Text(
                                                      'No data available'); // No data available in Firestore
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 9),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total',
                                            style: AppTextStyle.normalBold14
                                                .copyWith(color: appColor),
                                          ),
                                        ),
                                        Text(
                                          '₹ ${totalAmount.round()}',
                                          style: AppTextStyle.normalBold14
                                              .copyWith(color: appColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  customHeight(100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
