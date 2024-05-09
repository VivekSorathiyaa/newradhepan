import 'dart:math';

import 'package:flutter/material.dart';
import 'package:radhe/app/utils/app_text_style.dart';
import 'package:radhe/app/utils/colors.dart';

class TriangleWidget extends StatelessWidget {
  const TriangleWidget(
      {Key? key,
      required this.width,
      required this.height,
      required this.color,
      required this.text})
      : super(key: key);
  final double height;
  final double width;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: TrianglePainter(
              strokeColor: color.withOpacity(.5),
              paintingStyle: PaintingStyle.fill),
          child: SizedBox(
            width: width,
            height: height,
          ),
        ),
        Transform.translate(
          offset: const Offset(-5, -5),
          child: Transform.rotate(
            angle: -pi / 4,
            child: Text(
              text,
              style: AppTextStyle.normalRegular12.copyWith(color: whiteColor),
            ),
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x, 0)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
