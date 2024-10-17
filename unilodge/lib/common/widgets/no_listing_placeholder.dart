import 'package:flutter/material.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class NoListingPlaceholder extends StatelessWidget {
  const NoListingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.typeDorm,
            height: 150,
          ),
          const SizedBox(
            height: 30,
          ),
          const CustomText( 
            text: "No listings available.",
            color: AppColors.textColor,
            fontSize: 16,
              ),
          const SizedBox(height: 50)
        ],
      ),
    );
  }
}
