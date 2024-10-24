import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';

class BookedCard extends StatelessWidget {
  final Listing listing;

  const BookedCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: GestureDetector(
        onTap: () async {
          context.push('/listing-detail', extra: listing);
        },
        child: Container(
          height: 150,
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
          child: Row(
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
                      top: 20.0, right: 15, bottom: 8, left: 15),
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
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            listing.price != null
                                ? 'ETH ${listing.price!}'
                                : 'N/A',
                            style: TextStyle(color: AppColors.textColor),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: listing.isAvailable!
                                ? AppColors.greenActive
                                : AppColors.redInactive,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              listing.isAvailable!
                                  ? "Available"
                                  : "Unavailable",
                              style: const TextStyle(
                                color: AppColors.lightBackground,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
