import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/home/price_text.dart';

class AdminListingCard extends StatelessWidget {
  final Listing listing;

  const AdminListingCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: GestureDetector(
        onTap: () async {
          context.push('/your-admin-listing-detail', extra: listing);
        },
        child: Container(
          height: 160,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(43, 99, 100, 100),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Opacity(
                        opacity: 0.9,
                        child: Image.network(
                          listing.imageUrl?[0] ?? '',
                          width: 150,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 27.0, right: 15, bottom: 10, left: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listing.property_name ?? '',
                            style: const TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            listing.adddress,
                            style: TextStyle(color: AppColors.textColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              PriceText(
                                  text: listing.price != null
                                      ? 'ETH ${listing.price!}'
                                      : 'N/A'),
                              const Spacer(),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: listing.isAvailable!
                        ? AppColors.greenActive
                        : AppColors.redInactive,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    listing.isAvailable! ? "Available" : "Unavailable",
                    style: const TextStyle(
                      color: AppColors.lightBackground,
                      fontSize: 12, // Make the text smaller
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
