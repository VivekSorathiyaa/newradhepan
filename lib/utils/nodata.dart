import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopbook/app/utils/app_text_style.dart';
import 'package:shopbook/app/utils/colors.dart';

// ignore: must_be_immutable
class NoData extends StatelessWidget {
  String? noDataText;
  String? lottieJson;
  NoData({
    Key? key,
    this.noDataText,
    this.lottieJson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        alignment: Alignment.bottomCenter,
        children: [
          // lottieJson != null
          // ?
          Lottie.asset(
            'assets/json/nodata.json',
            height: 200,
          ),
          // : Image.asset(
          //     'assets/gif/no-data.gif',
          //   ),
          // const SizedBox(
          //   height: 50,
          // ),
          Text(noDataText ?? 'No Data Found'.toString(),
              style: AppTextStyle.normalBold14
                  .copyWith(color: grey.withOpacity(.5)))
        ],
      ),
    );
  }
}
