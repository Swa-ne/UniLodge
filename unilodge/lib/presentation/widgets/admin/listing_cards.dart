import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/renter/renter_bloc.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/home/price_text.dart';

class ListingCards extends StatelessWidget {
  final Listing listing;

  const ListingCards({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          context.push('/admin/listing-details', extra: listing);
        },
        child: BlocBuilder<RenterBloc, RenterState>(
          builder: (context, state) {
            bool isSaved = false;

            if (state is AllDormsLoaded) {
              isSaved = state.savedDorms
                  .any((savedListing) => savedListing.id == listing.id);
            }

            return Container(
              child: Column(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Opacity(
                        opacity: 0.9,
                        child: listing.imageUrl != null &&
                                listing.imageUrl!.isNotEmpty
                            ? Image.network(
                                listing.imageUrl![0],
                                width: 360,
                                height: 200,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return SizedBox(
                                      width: 360,
                                      height: 200,
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
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              listing.property_name ?? '',
                              style: const TextStyle(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          listing.adddress,
                          style: const TextStyle(color: AppColors.textColor),
                        ),
                        Row(
                          children: [
                            PriceText(
                                text: listing.price != null
                                    ? '₱${listing.price!}'
                                    : 'N/A'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
