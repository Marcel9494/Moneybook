import 'dart:math';

import 'package:flutter/material.dart';

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = Colors.redAccent;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2, // Start at the top (-90 degrees)
      pi, // Sweep 180 degrees (π radians)
      true,
      paint,
    );

    paint.color = Colors.greenAccent;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      pi / 2, // Start at the bottom (90 degrees)
      pi, // Sweep 180 degrees (π radians)
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
