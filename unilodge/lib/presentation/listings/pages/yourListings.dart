import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/dummy_yourListing.dart';
import 'package:unilodge/presentation/favorite/widgets/custom_text.dart';
import 'package:unilodge/presentation/listings/widgets/listingCard.dart';

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
          context.go('/post-accommodation');
        },
        child: Icon(
          Icons.add,
          color: Color(0xfffdfdfd),
        ),
        backgroundColor: Color(0xff2E3E4A),
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
