import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopbook/app/components/common_methos.dart';
import 'package:shopbook/app/controller/auth_controller.dart';
import 'package:shopbook/app/controller/data_controller.dart';
import 'package:shopbook/app/pages/authentication/create_account_screen.dart';
import 'package:shopbook/app/utils/app_text_style.dart';
import 'package:shopbook/app/utils/colors.dart';
import 'package:shopbook/app/widget/shodow_container_widget.dart';
import 'package:shopbook/models/expenses_model.dart';
import 'package:shopbook/models/user_model.dart';
import 'user_expenses_screen.dart';
import '../components/image/image_widget.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({Key? key}) : super(key: key);

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  final DataController dataController = Get.put(DataController());
  final AuthController authController = Get.put(AuthController());

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
            InkWell(
              onTap: () {
                Get.to(() => CreateAccountScreen(userModel: null));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ShadowContainerWidget(
                  padding: 0,
                  blurRadius: 0.5,
                  color: appColor,
                  widget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: primaryWhite,
                          size: 16,
                        ),
                        Text(
                          "Add Customer",
                          style: AppTextStyle.normalBold12
                              .copyWith(color: primaryWhite),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: StreamBuilder<List<UserModel>>(
            stream: dataController.fetchUsers(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (userSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${userSnapshot.error}'),
                );
              } else if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
                return Center(
                  child: Text('No users found'),
                );
              }

              List<UserModel> users = userSnapshot.data!;

              return FutureBuilder<Map<String, ExpenseModel?>>(
                future: _fetchLatestExpenses(users),
                builder: (context, expenseSnapshot) {
                  if (expenseSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (expenseSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${expenseSnapshot.error}'),
                    );
                  }

                  Map<String, ExpenseModel?> userLatestExpenses =
                      expenseSnapshot.data!;

                  users.sort((a, b) {
                    var aExpense = userLatestExpenses[a.id];
                    var bExpense = userLatestExpenses[b.id];
                    if (aExpense == null && bExpense == null) return 0;
                    if (aExpense == null) return 1;
                    if (bExpense == null) return -1;
                    return bExpense.date.compareTo(aExpense.date);
                  });

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      UserModel user = users[index];
                      ExpenseModel? latestExpense = userLatestExpenses[user.id];

                      return InkWell(
                        onTap: () {
                          Get.to(() => UserExpensesScreen(
                                user: user,
                                isFromAdmin: true,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 4, right: 8, left: 8, top: 4),
                          child: ShadowContainerWidget(
                              padding: 10,
                              widget: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NetworkImageWidget(
                                    imageUrl: user.imageUrl,
                                    height: 45,
                                    width: 45,
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    user.name,
                                                    style: AppTextStyle
                                                        .normalBold14,
                                                  ),
                                                  if (latestExpense != null)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Text(
                                                        CommonMethod.formatDate(
                                                            latestExpense.date),
                                                        style: AppTextStyle
                                                            .normalRegular10
                                                            .copyWith(
                                                                color: primaryBlack
                                                                    .withOpacity(
                                                                        .7)),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            StreamBuilder<List<ExpenseModel>>(
                                              stream: dataController
                                                  .getUserLastExpenses(user.id),
                                              builder:
                                                  (context, expenseSnapshot) {
                                                if (expenseSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator(); // Show loading indicator
                                                } else if (expenseSnapshot
                                                    .hasError) {
                                                  return Text(
                                                      'Error: ${expenseSnapshot.error}'); // Show error message
                                                } else if (!expenseSnapshot
                                                        .hasData ||
                                                    expenseSnapshot
                                                        .data!.isEmpty) {
                                                  return SizedBox(); // Show message for no data
                                                }

                                                // Data is available, build UI
                                                List<ExpenseModel> expenses =
                                                    expenseSnapshot.data!;
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children:
                                                      expenses.map((expense) {
                                                    var index = expenses
                                                        .indexOf(expense);
                                                    return Text(
                                                      '+ ${expense.amount}',
                                                      style: index == 0
                                                          ? AppTextStyle
                                                              .normalBold14
                                                              .copyWith(
                                                                  color:
                                                                      appColor)
                                                          : AppTextStyle
                                                              .normalRegular12
                                                              .copyWith(
                                                                  color: appColor
                                                                      .withOpacity(
                                                                          .8)),
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  );
                },
              );
            }));
  }

  Future<Map<String, ExpenseModel?>> _fetchLatestExpenses(
      List<UserModel> users) async {
    Map<String, ExpenseModel?> userLatestExpenses = {};
    for (var user in users) {
      var latestExpense =
          await dataController.getUserLastExpense(user.id).first;
      userLatestExpenses[user.id] = latestExpense;
    }
    return userLatestExpenses;
  }
}
