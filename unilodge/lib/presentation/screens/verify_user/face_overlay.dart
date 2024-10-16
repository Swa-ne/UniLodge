import 'package:flutter/material.dart';

class FaceOverlay extends StatelessWidget {
  const FaceOverlay({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FaceOverlayPainter(),
    );
  }
}

class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    var center = Offset(size.width / 2, size.height / 2);
    var width = size.width / 1.3;
    var height = size.height / 1.8;
    canvas.drawOval(
        Rect.fromCenter(center: center, width: width, height: height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
