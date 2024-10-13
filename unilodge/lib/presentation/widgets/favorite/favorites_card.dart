import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/bloc/renter/renter_bloc.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/favorite/custom_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCard extends StatelessWidget {
  final Listing listing;

  const FavoriteCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/listing-detail', extra: listing);
      },
      child: Card(
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
                  child:
                      listing.imageUrl != null && listing.imageUrl!.isNotEmpty
                          ? Image.network(
                              listing.imageUrl![0],
                              width: 150,
                              height: 120,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
            IconButton(
              icon: const Icon(Icons.favorite, color: Color(0xffF04F43)),
              onPressed: () async {
                final bool? confirmed = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Unsaved'),
                      content: const Text(
                          'Are you sure you want to unsave this dorm?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed == true) {
                  // Call the delete function
                  context.read<RenterBloc>().add(DeleteSavedDorm(listing.id!));
                  print("successfully removeddfkjasdklfja");
                  // Optionally, refresh or perform any additional action after deletion
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
