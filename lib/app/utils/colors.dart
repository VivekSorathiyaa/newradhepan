// 11184E

import 'package:flutter/material.dart';

Map<String, Color> colorStyles = {
  'primary': Colors.blue,
  'ligth_font': Colors.black54,
  'gray': Colors.black45,
  'white': Colors.white
};
// const Color appColor = Color(0xffECE03C);
// const Color appColor = Color(0xffF5CB39);
const Color appColor = Color(0xff236F85);
const Color lightPurpelColor = Color(0xffDED2FF);
const Color offWhite = Color(0xffF7F7F7);
const Color whiteColor = Color(0xffFFFFFF);
const Color blackColor = Color(0xff000000);
const Color backgroundColor = Color(0xffF5F6F8);
const Color backgroundColor1 = Color(0xffE5E5E5);
const Color textColor = Color(0xff171321);
const Color likeColor = Color(0xffff7b8f);
const Color perotColor = Color(0xff01AE12);
const Color lightgreycolor = Color(0xffE9E9E9);
const Color textFieldColor = Color(0xffF7F7F7);

Gradient likeGradient =
    const LinearGradient(colors: [Color(0xffff7b8f), Color(0xffFF5F77)]);

const Color containerGrey = Color(0xffE7E7E9);
const Color backgroundGrey = Color(0xffECEFF3);
const Color lightGrey = Color(0xffF4F4F5);
const Color hintGrey = Color(0xffBABABA);
const Color contentGrey = Color(0xff969498);
const Color regularGrey = Color(0xff7F7D89);
const Color darkGreyBlue = Color(0xff2B2C36); //505050
const Color? titleBlack = Color(0xff333333);

const Color lightappColor = Color(0xffFFE7E7);
const Color red = Color(0xffE22A2A);
const Color success = Color(0xff5FB924);
const Color infoDialog = Color(0xff79B3E4);
const Color blue = Color(0xff083CF8);
const Color yellow = Color(0xffFFCC00);
const Color borderGrey = Color(0xffDBDBDB);

Color borderColor = const Color(0xffEBEBEB);
const Color greyWhiteColor = Color(0xffEDF2F8);
const Color primaryGreenColor = Color(0xff0C831F);

Color lightSilver = const Color(0xffF7F7F7);
Color darkSilver = const Color(0xffE4E4E4);
Color grey = const Color(0xff999999);
Color purpleblue = const Color(0xffECE03C);

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

const MaterialColor primaryWhite = MaterialColor(
  _whitePrimaryValue,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(_whitePrimaryValue),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);
const int _whitePrimaryValue = 0xFFFFFFFF;

const int _scaffoldValue = 0xFFFAFAFA;
const MaterialColor scaffoldColor = MaterialColor(
  _scaffoldValue,
  <int, Color>{
    50: Color(0xFFFAFAFA),
    100: Color(0xFFFAFAFA),
    200: Color(0xFFFAFAFA),
    300: Color(0xFFFAFAFA),
    400: Color(0xFFFAFAFA),
    500: Color(_whitePrimaryValue),
    600: Color(0xFFFAFAFA),
    700: Color(0xFFFAFAFA),
    800: Color(0xFFFAFAFA),
    900: Color(0xFFFAFAFA),
  },
);
