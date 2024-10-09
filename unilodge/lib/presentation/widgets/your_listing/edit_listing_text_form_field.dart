
import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class EditListingTextFormField extends StatelessWidget {
  const EditListingTextFormField(
      {super.key,
      required this.label,
      required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
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
    );
  }
}
