import 'package:flutter/material.dart';

class TextRow extends StatelessWidget {
  final String text;
  final Icon icon;

  const TextRow({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: icon),
          Text(
            text,
            style: const TextStyle(color: Color(0xff434343)),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color.fromARGB(176, 46, 62, 74),
            ),
          )
        ],
      ),
    );
  }
}
