import 'package:flutter/material.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class StatusText extends StatelessWidget {
  const StatusText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // TODO: change this accdg to the state from bloc
        color: "pending" == "pending"
            ? AppColors.pending
            : "pending" == "declined"
                ? AppColors.redInactive
                : AppColors.greenActive,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomText(
        text: "Pending",
        color: AppColors.lightBackground,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
