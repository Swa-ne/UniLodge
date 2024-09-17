import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget icon;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          elevation: 0,
          backgroundColor: Color(0xffF8F8F8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(double.infinity, 60),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: icon,
            ),
            Expanded(
              flex: 8,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.formTextColor, // Change text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
