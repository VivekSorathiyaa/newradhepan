import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radhe/app/controller/data_controller.dart';
import 'package:radhe/app/utils/app_text_style.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/utils/static_decoration.dart';
import 'package:radhe/app/widget/shodow_container_widget.dart';

class GrandTotalScreen extends StatefulWidget {
  const GrandTotalScreen({Key? key}) : super(key: key);

  @override
  State<GrandTotalScreen> createState() => _GrandTotalScreenState();
}

class _GrandTotalScreenState extends State<GrandTotalScreen> {
  var dataController = Get.put(DataController());

  @override
  void initState() {
    dataController.fetchUsers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Grand Total",
          style: AppTextStyle.homeAppbarTextStyle,
        ),
        iconTheme: IconThemeData(color: primaryWhite),
        backgroundColor: appColor,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              ShadowContainerWidget(
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text("Total Expense"),
                      ],
                    ),
                    StreamBuilder<double>(
                      stream: dataController
                          .getAllTotalExpenseStream(), // Assuming you have userId available
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(); // Show loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          double totalExpense = snapshot.data ??
                              0.0; // Get total expense from snapshot data
                          return Text(
                            '₹ ${totalExpense.round()}', // Display the total expense
                            style: AppTextStyle.normalBold26
                                .copyWith(fontFamily: '', color: appColor),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              height20,
              ShadowContainerWidget(
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text("Total Users"),
                      ],
                    ),
                    Text(
                      '${dataController.userList.length - 1}', // Display the total expense
                      style: AppTextStyle.normalBold26
                          .copyWith(fontFamily: ',', color: appColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
