import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class EditListingTextFormField extends StatelessWidget {
  const EditListingTextFormField(
      {super.key,
      required this.label,
      this.keyboardType,
      this.minLines,
      this.maxLines,
      this.error,
      required this.controller});

  final String label;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final String? error;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.blueTextColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(
          color: AppColors.formTextColor,
          height: 1.3,
        ),
        labelText: label,
        hintStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }
}
