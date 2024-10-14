import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/favorite/custom_text.dart';

class PriceText extends StatelessWidget {
  const PriceText({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 235, 235, 235),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomText(
        text: text,
        color: AppColors.formTextColor,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
