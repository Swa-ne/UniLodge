import 'package:flutter/material.dart';
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
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                width: 150,
                height: 150,
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
                    color: const Color(0xFF2E3E4A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  _buildStarRating(rating),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CustomText(
                      text: address,
                      color: const Color(0xFF454545),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomText(
                    text: price,
                    color: const Color(0xFF454545),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
          // hart
          const Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 8),
                Icon(Icons.favorite, color: Colors.red),
              ],
            ),
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
          color: Colors.yellow,
        );
      }),
    );
  }
}
