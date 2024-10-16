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

    // Draw the face oval overlay
    var center = Offset(size.width / 2, size.height / 2);
    var radius = size.width / 3; // Adjust the size as needed
    canvas.drawOval(Rect.fromCircle(center: center, radius: radius), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
