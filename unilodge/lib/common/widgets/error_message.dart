import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.errorIcon,
            height: 100,
          ),
          const SizedBox(height: 20),
          Text('Error: ${errorMessage} :000'),
        ],
      ),
    );
  }
}
