import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/renter/renter_bloc.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/repository/renter_repository_impl.dart';
import 'package:unilodge/presentation/widgets/home/listing_cards.dart';

class TypeListingScreen extends StatelessWidget {
  const TypeListingScreen({super.key, required this.listingType});

  final String listingType;

  @override
  Widget build(BuildContext context) {
    // Initialize RenterBloc to fetch listings based on listingType
    return BlocProvider(
      create: (context) => RenterBloc(renterRepository: RenterRepositoryImpl())
        ..add(FetchAllDormsByType(
            listingType)), // Use RenterBloc and dispatch FetchListings event
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: CustomText(
            text: listingType,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        body: BlocBuilder<RenterBloc, RenterState>(
          builder: (context, state) {
            if (state is DormsLoading) {
              return Center(
                  child: CircularProgressIndicator()); // Show loading spinner
            } else if (state is DormsError) {
              return Center(
                child: CustomText(
                  text: state.message,
                  fontSize: 18,
                  color: Colors.red,
                ), // Show error message
              );
            } else if (state is DormsLoaded) {
              final listings = state
                  .allDorms; // Adjust according to your loaded data structure

              if (listings.isEmpty) {
                return Center(
                  child: CustomText(
                    text: 'No listings available',
                    fontSize: 18,
                    color: AppColors.primary,
                  ), // Show message if no listings
                );
              }

              return ListView.builder(
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  final listing = listings[index];
                  return Column(
                    children: [
                      ListingCards(
                        listing: listing, // Pass the whole listing object
                      ),
                      const Divider(
                        height: 30, // Increased height for better spacing
                        color: Color.fromARGB(255, 223, 223, 223),
                      ),
                    ],
                  );
                },
              );
            }
            return SizedBox
                .shrink(); // Return empty widget if none of the states match
          },
        ),
      ),
    );
  }
}
