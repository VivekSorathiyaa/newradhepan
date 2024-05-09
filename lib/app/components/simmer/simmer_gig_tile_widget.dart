import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/static_decoration.dart';

class SimmerGigTileWidget extends StatefulWidget {
  const SimmerGigTileWidget({Key? key}) : super(key: key);

  @override
  State<SimmerGigTileWidget> createState() => _SimmerGigTileWidgetState();
}

class _SimmerGigTileWidgetState extends State<SimmerGigTileWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...List.generate(
          20,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: EdgeInsets.only(top: index == 0 ? 15 : 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                            decoration: BoxDecoration(
                                color: yellow,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              index % 2 == 0 ? "zzzzz" : "zzzzzzzzzz",
                              style: AppTextStyle.normalSemiBold18
                                  .copyWith(height: 1.1),
                            )),
                      ),
                      width10,
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                            decoration: BoxDecoration(
                                color: yellow,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              index % 2 != 0 ? "zzzzzzz" : "zzzzzzzzzzzzz",
                              style: AppTextStyle.normalSemiBold18
                                  .copyWith(height: 1.1),
                            )),
                      ),
                    ],
                  ),
                  height10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                                color: yellow,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              "zzzz",
                              style: AppTextStyle.normalRegular12
                                  .copyWith(color: appColor),
                            ),
                          )),
                      width8,
                      Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                                color: yellow,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              "zzzzzzzzz",
                              style: AppTextStyle.normalRegular12
                                  .copyWith(color: hintGrey),
                            ),
                          )),
                    ],
                  ),
                  height20,
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: yellow,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ).toList()
      ],
    );
  }
}
