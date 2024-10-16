import 'package:flutter/material.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class NoFavsPlaceholder extends StatelessWidget {
  const NoFavsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.noFavs,
            height: 150,
          ),
          const SizedBox(
            height: 30,
          ),
          const CustomText( 
            text: "No favorites found.",
            color: AppColors.textColor,
            fontSize: 16,
              ),
          const SizedBox(height: 50)
        ],
      ),
    );
  }
}
