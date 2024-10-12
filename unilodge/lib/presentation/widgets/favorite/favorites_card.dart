import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/favorite/custom_text.dart';

class FavoriteCard extends StatelessWidget {
  final Listing listing;

  const FavoriteCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      color: Colors.transparent,
      elevation: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Opacity(
                opacity: 0.9,
                child: listing.imageUrl != null &&
                        listing.imageUrl!.isNotEmpty
                    ? Image.network(
                        listing.imageUrl![0],
                        width: 150,
                        height: 120,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return SizedBox(
                              width: 150,
                              height: 120,
                              child: Center(
                                child: Lottie.asset(
                                  'assets/animation/home_loading.json',
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : const SizedBox(
                        width: 360,
                        height: 200,
                        child: Center(
                          child: Text('No Image Available'),
                        ),
                      ),
              ),
            ),
          ),
          // Dorm details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: listing.property_name ?? 'No property name',
                    color: AppColors.logoTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8F8F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CustomText(
                      text: listing.adddress,
                      color: AppColors.formTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomText(
                    text: listing.price ?? 'Price not available',
                    color: AppColors.formTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
          // Favorite icon
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Icon(Icons.favorite, color: Color(0xffF04F43)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
