import 'package:flutter/material.dart';
import 'package:shopbook/app/utils/app_text_style.dart';
import 'package:shopbook/app/utils/colors.dart';

// ignore: must_be_immutable
class OutlineBorderButton extends StatelessWidget {
  String? title;
  VoidCallback onPressed;
  VoidCallback? onLongPress;
  double? height;
  double? width;
  double? radius;
  double? fontSize;

  Color? textColor;
  Color? borderColor;
  ButtonTextTheme? textTheme;

  OutlineBorderButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.height,
    this.width,
    this.fontSize,
    this.radius,
    this.textColor,
    this.borderColor,
    this.onLongPress,
    this.textTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: BorderSide(color: borderColor ?? appColor, width: 1),
        ),
        onPressed: onPressed,
        child: Text(
          title.toString(),
          style: AppTextStyle.normalSemiBold15.copyWith(color: textColor),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class OutlineIconButton extends StatelessWidget {
  String? title;
  VoidCallback onPressed;
  Color? color;
  Icon icon;

  OutlineIconButton({
    Key? key,
    this.color,
    required this.title,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        )),
      ),
      label: Text(title.toString()),
      icon: icon,
      onPressed: onPressed,
    );
  }
}
