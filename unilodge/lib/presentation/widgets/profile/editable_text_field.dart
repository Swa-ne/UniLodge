import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class EditableTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final String value; 

  EditableTextField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    required this.value,
  }) {
    controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.textColor,
          ),
        ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
