import 'package:flutter/material.dart';
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
            height: 100,
          ),
          SizedBox(
            height: 30,
          ),
          Text("No listings available",
              style: TextStyle(
                color: AppColors.textColor,
              )),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
