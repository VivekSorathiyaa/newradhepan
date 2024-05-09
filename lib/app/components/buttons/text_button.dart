import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:radhe/app/utils/app_text_style.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/utils/static_decoration.dart';

// ignore: must_be_immutable
class PrimaryTextButton extends StatelessWidget {
  String? title;
  VoidCallback onPressed;
  Color? buttonColor;
  Color? textColor;
  double? width;
  double? height;
  BorderRadiusGeometry? borderRadius;
  bool autofocus;
  bool isdisable;

  PrimaryTextButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.width,
    this.borderRadius,
    this.height,
    this.isdisable = false,
    this.autofocus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      autofocus: autofocus,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? primaryWhite,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? circular15BorderRadius,
        ),
        disabledForegroundColor: primaryWhite.withOpacity(0.38),
        backgroundColor: isdisable
            ? (buttonColor?.withOpacity(0.1) ?? appColor.withOpacity(0.1))
            : buttonColor ?? appColor,
        fixedSize: Size(
          width ?? MediaQuery.of(context).size.width,
          height ?? 45,
        ),
        alignment: Alignment.center,
        textStyle: AppTextStyle.normalSemiBold15.copyWith(color: textColor),
      ),
      onPressed: isdisable ? null : onPressed,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title.toString(),
          softWrap: true,
          textAlign: TextAlign.center,
          style: AppTextStyle.normalSemiBold15.copyWith(color: whiteColor),
        ),
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String? imageLink;
  final IconData? iconLink;
  final String? buttonName;
  final Color? buttonColor;
  final Color? borderdColor;
  final double? iconHeight;
  final VoidCallback? onPressed;

  const ImageButton({
    Key? key,
    this.width,
    this.height,
    this.textStyle,
    this.buttonColor,
    this.imageLink,
    this.iconLink,
    this.iconHeight,
    required this.onPressed,
    required this.buttonName,
    this.borderdColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: height ?? 50,
        width: width ?? double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: circular30BorderRadius,
          color: buttonColor ?? whiteColor,
          border: Border.all(color: borderdColor ?? borderColor, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageLink != null
                ? SvgPicture.asset(
                    imageLink.toString(),
                    height: iconHeight ?? 26,
                  )
                : Icon(
                    iconLink,
                    color: primaryWhite,
                    size: iconHeight ?? 26,
                  ),
            width15,
            Text(buttonName.toString(),
                style: textStyle ?? AppTextStyle.normalSemiBold14),
          ],
        ),
      ),
    );
  }
}
