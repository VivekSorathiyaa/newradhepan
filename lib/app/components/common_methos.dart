import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radhe/app/app.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/utils/static_decoration.dart';

import '../pages/authentication/login_screen.dart';
import '../utils/app_text_style.dart';

import '../widget/shodow_container_widget.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class CommonMethod {
  goToLoginScreen() {
    Get.to(() => LoginScreen());
  }

  checkIsLogin(Widget redirectionWidget) {
    if (dataStorage.read('id') == null) {
      goToLoginScreen();
    } else {
      Get.to(() => redirectionWidget);
    }
  }

  int calculateAge(DateTime birthday) {
    log("---birthday--${birthday}");
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;
    if (currentDate.month < birthday.month ||
        (currentDate.month == birthday.month &&
            currentDate.day < birthday.day)) {
      age--;
    }
    log("===currentAge===$age");
    return age;
  }

  static String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('E, d MMM, y, hh:mm a');
    return formatter.format(dateTime);
  }

  String getFirstWords(String sentence, int wordCounts) {
    return sentence.split(" ").sublist(0, wordCounts).join(" ");
  }

  static void showSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future getXSnackBar(String title, String message, Color? color,
      {Duration? duration}) async {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      duration: duration ?? const Duration(seconds: 2),
      // borderRadius: 0,
      barBlur: 10,
    );
  }

  Widget removeWidget({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: whiteColor,
              ),
            ],
            color: red),
        child: Icon(
          Icons.close,
          size: 12,
          color: whiteColor,
        ),
      ),
    );
  }

  void getXConfirmationSnackBar(
    String title,
    String message,
    Function() onButtonPress,
  ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: onButtonPress,
        child: const Icon(Icons.delete, color: whiteColor),
      ),
      backgroundColor: blue,
      colorText: whiteColor,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 6),
      // borderRadius: 0,
      barBlur: 10,
      icon: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.close,
          color: whiteColor,
        ),
      ),
    );
  }

  FormFieldValidator<String?>? passwordValidator = (value) {
    // Check if the value is null or empty
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    // Check if the password meets the minimum length requirement
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    // Check if the password contains at least one uppercase letter, one lowercase letter, and one digit
    // RegExp regex = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])');
    // if (!regex.hasMatch(value)) {
    //   return 'Password must contain at least one uppercase letter, one lowercase letter, and one digit';
    // }

    // Return null if the password is valid
    return null;
  };

  selectGender(BuildContext context, Function function) {
    String _genderRadioBtnVal = '';

    void _handleGenderChange(String? value) {
      if (value != null) {
        Get.back();
        function(value);
      }
    }

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (BuildContext context) {
          return Container(
            height: 80,
            decoration: BoxDecoration(
              color: offWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio<String>(
                        value: "Male",
                        groupValue: _genderRadioBtnVal,
                        onChanged: _handleGenderChange,
                      ),
                      Text("Male",
                          style: AppTextStyle.normalRegular14
                              .copyWith(color: regularGrey)),
                      Radio<String>(
                        value: "Female",
                        groupValue: _genderRadioBtnVal,
                        onChanged: _handleGenderChange,
                      ),
                      Text("Female",
                          style: AppTextStyle.normalRegular14
                              .copyWith(color: regularGrey)),
                      Radio<String>(
                        value: "Non-binary",
                        groupValue: _genderRadioBtnVal,
                        onChanged: _handleGenderChange,
                      ),
                      Text("Non-binary",
                          style: AppTextStyle.normalRegular14
                              .copyWith(color: regularGrey)),
                      Radio<String>(
                        value: "Other",
                        groupValue: _genderRadioBtnVal,
                        onChanged: _handleGenderChange,
                      ),
                      Text("Other",
                          style: AppTextStyle.normalRegular14
                              .copyWith(color: regularGrey)),
                      width15,
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
