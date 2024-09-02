import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  final String text;
  final String imageUrl;
  final Color color;

  const Cards({
    super.key,
    required this.text,
    required this.imageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        width: 175,
        height: 110,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: Color(0xff5E5E5E)),
            ),
            const Spacer(), // Pushes the image to the bottom
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                imageUrl,
                width: 85,
                height: 85,
              ),
            ),
          ],
        ),
      ),
    );
  }
}