import 'package:flutter/material.dart';
import 'package:radhe/app/components/buttons/text_button.dart';
import 'package:radhe/app/components/image/image_widget.dart';
import 'package:radhe/app/utils/app_text_style.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/app/utils/static_decoration.dart';
import 'package:radhe/app/widget/shodow_container_widget.dart';

import '../../models/product_model.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: ShadowContainerWidget(
        // color: backgroundColor,
        // blurRadius: 0,
        padding: 0,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkImageWidget(
              imageUrl: product.imageUrl, fit: BoxFit.cover,
              height: 100.0, // Adjust image height as needed
              width: double.infinity,

              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            // Image.asset(
            //   product.imageUrl,
            //   fit: BoxFit.cover,
            //   height: 150.0, // Adjust image height as needed
            //   width: double.infinity,
            // ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title + "fekgh  ij grdfgsg hh ygy gyg yg yfdjhgk",
                    style: AppTextStyle.normalBold16,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  customHeight(2),
                  Text(
                    '\₹${product.price}',
                    style: AppTextStyle.normalRegular14.copyWith(color: grey),
                  ),
                  customHeight(2),
                  Container(
                    decoration: BoxDecoration(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
