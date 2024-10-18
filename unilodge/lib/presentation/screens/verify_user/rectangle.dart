import 'package:flutter/material.dart';

class RectangleOverlay extends StatelessWidget {
  final Color? color;

  const RectangleOverlay({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centering the entire overlay
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 12), // Adjust padding to fit the screen
        child: AspectRatio(
          aspectRatio: 0.7, // Keep the rectangle in portrait aspect ratio
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: color ?? Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
