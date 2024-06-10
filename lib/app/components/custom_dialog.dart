import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shopbook/app/utils/app_asset.dart';
import 'package:shopbook/app/utils/colors.dart';
import 'package:shopbook/app/utils/static_decoration.dart';
import 'package:shopbook/app/widget/shodow_container_widget.dart';

import '../utils/app_text_style.dart';
import 'buttons/text_button.dart';

class CommonDialog {
  static Future<void> showConfirmationDialog({
    String? title,
    String? message,
    Widget? bodyWiget,
    TextStyle? messageTextStyle,
    TextStyle? titleTextStyle,
    required Function() onOkPress,
    required BuildContext context,
    Function()? onBackPress,
  }) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AlertDialog(
          backgroundColor: Colors.white, // Set background color to white
          insetPadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.all(15),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Center(
              child: Text(
            title ?? 'Confirmation',
            style: titleTextStyle ??
                AppTextStyle.normalBold18.copyWith(color: appColor),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              bodyWiget ??
                  AspectRatio(
                    aspectRatio: 2 / 2, 
                    child: SvgPicture.asset(
                      AppAsset.bgAcceptBid,
                      // width: 100,
                      // height: 100,
                    ),
                  ),
              height20,
              Center(
                child: Text(
                  message ?? "Are you sure ?",
                  style: messageTextStyle ??
                      AppTextStyle.normalBold16
                          .copyWith(color: appColor, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              height20,
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: onBackPress ??
                            () {
                              Get.back();
                            },
                        child: ShadowContainerWidget(
                            padding: 0,
                            blurRadius: 1,
                            radius: 8,
                            widget: SizedBox(
                              height: 36,
                              child: Center(
                                child: Text(
                                  "No",
                                  style: AppTextStyle.normalBold14
                                      .copyWith(color: appColor),
                                ),
                              ),
                            )),
                      ),
                    ),
                    width15,
                    Expanded(
                      child: InkWell(
                        onTap: onOkPress,
                        child: ShadowContainerWidget(
                            padding: 0,
                            blurRadius: 1,
                            radius: 8,
                            borderColor: appColor,
                            color: appColor,
                            widget: SizedBox(
                              height: 36,
                              child: Center(
                                child: Text(
                                  "Yes",
                                  style: AppTextStyle.normalBold14
                                      .copyWith(color: whiteColor),
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showSimpleDialog({
    String? title,
    bool? hideContent,
    Widget? titleWidget,
    required Widget child,
    required BuildContext context,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: primaryBlack.withOpacity(.3),
      builder: (BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AlertDialog(
          backgroundColor: primaryWhite, // Set background color to white
          insetPadding: EdgeInsets.symmetric(horizontal: 15),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          contentPadding: EdgeInsets.symmetric(
              horizontal: hideContent != null && hideContent ? 0 : 15),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: titleWidget ??
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: SvgPicture.asset(
                        AppAsset.icArrowBack,
                        color: appColor,
                        width: 23,
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        title ?? '',
                        style: AppTextStyle.normalBold18
                            .copyWith(color: appColor, height: 1.3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: customWidth(23)),
                ],
              ),
          content: Container(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: hideContent != null && hideContent ? 0 : 20),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
