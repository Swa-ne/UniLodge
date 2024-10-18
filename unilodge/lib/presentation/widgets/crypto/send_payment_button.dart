import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class SendPaymentCrypto extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double fontSize;
  final double borderRadius;
  final double paddingVertical;
  final double height;

  const SendPaymentCrypto({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.fontSize = 18,
    this.borderRadius = 10,
    this.paddingVertical = 12,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        minimumSize: Size(double.infinity, height),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
