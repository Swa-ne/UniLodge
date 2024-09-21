import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class NearbyCard extends StatelessWidget {
  const NearbyCard(
      {super.key,
      required this.imageUrl,
      required this.propertyName,
      required this.rating});

  final String imageUrl;
  final String propertyName;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(imageUrl, width: 170, height: 100, fit: BoxFit.cover,)),
            ),
            Text(propertyName),
            Text(rating.toString())
          ],
        ),
      ),
    );
  }
}
