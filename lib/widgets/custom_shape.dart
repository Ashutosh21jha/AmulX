import 'dart:ui' as ui;
import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(-40, -60);
    path_0.cubicTo(-40, -63.866, -106.866, -67, -103, -67);
    path_0.lineTo(426, -67);
    path_0.cubicTo(429.866, -67, 433, -63.866, 433, -60);
    path_0.lineTo(433, 220.068);
    path_0.cubicTo(443, 233.99, 437.491, 234.858, 436.285, 231.126);
    path_0.lineTo(436.285, 231.126);
    path_0.cubicTo(406.994, 140.474, 297.095, 105.709, 220.997, 163.023);
    path_0.lineTo(140.082, 223.966);
    path_0.lineTo(140.082, 223.966);
    path_0.cubicTo(66.0062, 273.664, -27.2773, 285.204, -111.23, 255.057);
    path_0.lineTo(-119.49, 252.091);
    path_0.cubicTo(-119.796, 251.981, -50, 251.691, -120, 251.365);
    path_0.lineTo(-50, -70);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    // paint0Fill.color = const Color(0xff2F80ED).withOpacity(1.0);
    paint0Fill.shader = ui.Gradient.linear(
        const Offset(0.0, 0.0),
        const Offset(600.0, 0.0),
        <Color>[
          const Color(0xff00084B).withOpacity(1.0),
          const Color(0xff2E55C0).withOpacity(1.0),
          const Color(0xff148BFA).withOpacity(1.0)
        ],
        <double>[0.0, 0.4, 1.0],
        TileMode.clamp);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
