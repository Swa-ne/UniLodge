import 'package:flutter/material.dart';

class TextRow extends StatelessWidget {
  final String text1;
  final String text2;

  const TextRow({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            text1,
            style: TextStyle(fontSize: 15, color: Color(0xff434343)),
          ),
          Spacer(),
          Text(text2, style: TextStyle(fontSize: 15, color: Color(0xff434343)))
        ],
      ),
    );
  }
}
