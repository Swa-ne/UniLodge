import 'package:flutter/material.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class LogoutConfirmBottomSheet extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutConfirmBottomSheet({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomText(
            text: 'Are you sure you want to logout?',
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Center(
                child: CustomText(
              text: 'Logout',
              color: AppColors.textColor,
              fontSize: 18,
            )),
            onTap: () {
              onLogout();
            },
          ),
          ListTile(
            title: const Center(
                child: CustomText(
                    text: 'Cancel', color: AppColors.textColor, fontSize: 18)),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
