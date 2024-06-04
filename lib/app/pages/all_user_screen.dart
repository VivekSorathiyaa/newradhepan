import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:radhe/app/components/common_methos.dart';
import 'package:radhe/app/controller/auth_controller.dart';
import 'package:radhe/app/controller/data_controller.dart';
import 'package:radhe/app/pages/authentication/create_account_screen.dart';
import 'package:radhe/app/utils/app_text_style.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/utils/static_decoration.dart';
import 'package:radhe/app/widget/shodow_container_widget.dart';
import 'package:radhe/models/expenses_model.dart';
import 'package:radhe/models/user_model.dart';
import 'user_expenses_screen.dart';
import '../components/image/image_widget.dart';
import '../components/buttons/text_button.dart';
import '../components/custom_dialog.dart';

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
                  blurRadius: 1,
                  color: appColor,
                  widget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: primaryWhite,
                          size: 20,
                        ),
                        Text(
                          "Add Customer",
                          style: AppTextStyle.normalBold14
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

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserModel user = users[index];

                  return InkWell(
                    onTap: () {
                      Get.to(() => UserExpensesScreen(
                            user: user,
                            isAdmin: true,
                          ));
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 10, left: 10),
                      child: ShadowContainerWidget(
                          // padding: 0,
                          widget: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NetworkImageWidget(
                            imageUrl: user.imageUrl,
                            height: 50,
                            width: 50,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          user.name,
                                          style: AppTextStyle.normalBold16,
                                        ),
                                      ),
                                  StreamBuilder<List<ExpenseModel>>(
  stream: dataController.getUserLastExpenses(user.id),
  builder: (context, expenseSnapshot) {
    if (expenseSnapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // Show loading indicator
    } else if (expenseSnapshot.hasError) {
      return Text('Error: ${expenseSnapshot.error}'); // Show error message
    } else if (!expenseSnapshot.hasData || expenseSnapshot.data!.isEmpty) {
      return Text('No expenses found'); // Show message for no data
    }

    // Data is available, build UI
    List<ExpenseModel> expenses = expenseSnapshot.data!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: expenses.map((expense) {
        var index = expenses.indexOf(expense);
        return Text(
          '+ ${expense.amount}',
          style: index == 0
              ? AppTextStyle.normalBold14.copyWith(color: appColor)
              : AppTextStyle.normalRegular14.copyWith(color: appColor.withOpacity(.8)),
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
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.more_vert),
                          //   onPressed: () {
                          //     CommonDialog.showSimpleDialog(
                          //         title: "Options",
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(20),
                          //           child: Column(
                          //             children: [
                          //               PrimaryTextButton(
                          //                   title: "Edit",
                          //                   onPressed: () {
                          //                     Get.to(() =>
                          //                         CreateAccountScreen(
                          //                             userModel: user));
                          //                   }),
                          //               height20,
                          //               PrimaryTextButton(
                          //                   buttonColor: red,
                          //                   title: "Delete",
                          //                   onPressed: () {
                          //                     CommonDialog
                          //                         .showConfirmationDialog(
                          //                             title:
                          //                                 "Are you sure you want to delete this user? This action will permanently remove the user's account and all associated expenses.",
                          //                             onOkPress: () {
                          //                               Get.back();
                          //                               Get.back();
                          //                               authController
                          //                                   .deleteAuthUser(
                          //                                       context:
                          //                                           context,
                          //                                       userId:
                          //                                           user.id,
                          //                                       phone: user
                          //                                           .phone,
                          //                                       password: user
                          //                                           .password);
                          //                             },
                          //                             context: context);
                          //                   }),
                          //             ],
                          //           ),
                          //         ),
                          //         context: context);
                          //   },
                          // ),
                        ],
                      )),
                    ),
                  );
                },
              );
            }));
  }
}
