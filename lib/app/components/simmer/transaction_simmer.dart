import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TransactionSimmer extends StatelessWidget {
  const TransactionSimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
  children: [
    Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 20.0,
          color: Colors.grey[300],
        ),
      ),
    ),
    SizedBox(width: 8.0),
    Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 20.0,
          color: Colors.grey[300],
        ),
      ),
    ),
    SizedBox(width: 8.0),
    Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 20.0,
          color: Colors.grey[300],
        ),
      ),
    ),
  ],
);

  }
}