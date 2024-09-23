import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/dummy_data/dummy_data.dart';
import 'package:unilodge/presentation/home/widgets/listingCards.dart';

class TypeListingScreen extends StatelessWidget {
  const TypeListingScreen({super.key, required this.appbarTitle});

  final String appbarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appbarTitle, style: TextStyle(
              color: AppColors.textColor,
              fontSize: 18,
            ),),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: dummyListings.length,
                itemBuilder: (context, index) {
                  final listing = dummyListings[index];
                  return Column(
                    children: [
                      ListingCards(
                        listing: listing, // Pass the whole listing object
                      ),
                      const Divider(
                        height: 20,
                        color: Color.fromARGB(255, 223, 223, 223),
                      ),
                    ],
                  );
                },
              ),
            ),
          ]),
        ));
  }
}
