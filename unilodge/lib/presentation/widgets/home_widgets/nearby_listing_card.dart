import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
                  child: Image.network(
                    imageUrl,
                    width: 170,
                    height: 100,
                    fit: BoxFit.cover,
                  )),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(propertyName,
                        style: const TextStyle(
                          color: AppColors.textColor,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RatingBar.builder(
                        initialRating: rating.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 18,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                        itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: AppColors.ratingYellow,
                            ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        }),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
