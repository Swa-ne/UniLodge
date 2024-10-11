import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.errorIcon,
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(textAlign: TextAlign.center, 'Error: ${errorMessage} wew :000'),
            ),
          ],
        ),
      ),
    );
  }
}
