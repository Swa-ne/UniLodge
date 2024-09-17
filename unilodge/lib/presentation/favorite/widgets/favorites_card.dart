import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/favorite/widgets/custom_text.dart';

class FavoriteCard extends StatelessWidget {
  final String image;
  final String dormName;
  final String address;
  final String price;
  final int rating;

  const FavoriteCard({
    super.key,
    required this.image,
    required this.dormName,
    required this.address,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.transparent,
      elevation: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // img
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                image,
                width: 150,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // dorm deets
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: dormName,
                    color: AppColors.logoTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  _buildStarRating(rating),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xffF8F8F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CustomText(
                      text: address,
                      color: AppColors.formTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  

                  const SizedBox(height: 20),
                  CustomText(
                    text: price,
                    color: AppColors.formTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
          // hart
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Icon(Icons.favorite, color: Color(0xffF04F43)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // rate shehs
  Widget _buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: const Color.fromARGB(255, 245, 231, 110), size: 17,
        );
      }),
    );
  }
}
