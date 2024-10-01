import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/home_widgets/nearby_listing_card.dart';

class NearbyProperties extends StatelessWidget {
  const NearbyProperties({super.key, required this.listings});

  final List<Listing> listings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: const BoxDecoration(color: Color(0xFFF3F3F3)),
      child: GridView.builder(
        itemCount: listings.length,
        shrinkWrap:
            true, // allows gridview to size itself based on its children
        physics:
            const NeverScrollableScrollPhysics(), // prevents scrolling as it iz inside a scrollable parent
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cards per roww
          crossAxisSpacing: 4.0, // spacing between columns
          mainAxisSpacing: 4.0, // spacing between rows
        ),
        itemBuilder: (context, index) {
          final property = listings[index];
          return GestureDetector(
            onTap: () {
              context.push('/listing-detail/${property.id}');
            },
            child: NearbyCard(
              imageUrl: property.imageUrl,
              propertyName: property.property_name,
              rating: property.rating,
            ),
          );
        },
      ),
    );
  }
}
