import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/dummy_data/dummy_yourListing.dart';
import 'package:unilodge/presentation/widgets/favorite/custom_text.dart';
import 'package:unilodge/presentation/widgets/your_listing/listing_card.dart';

class Listings extends StatelessWidget {
  const Listings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const CustomText(
          text: 'Your Listings',
          color: AppColors.textColor,
          fontSize: 18,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/post-accommodation');
        },
        backgroundColor: const Color(0xff2E3E4A),
        child: Icon(
          Icons.add,
          color: Color(0xfffdfdfd),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: dummyYourListings.length,
          itemBuilder: (context, index) {
            final listing = dummyYourListings[index];
          return ListingCard(listing: listing);
        }),
      ),
    );
  }
}
