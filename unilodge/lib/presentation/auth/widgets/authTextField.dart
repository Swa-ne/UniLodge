import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;

  const AuthTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType:
          obscureText ? TextInputType.visiblePassword : TextInputType.text,
      obscureText: obscureText,
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
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
    );
  }
}
