import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/provider/favorite_provider.dart';

class ListingCards extends StatefulWidget {
  final Listing listing;

  const ListingCards({
    super.key,
    required this.listing,
  });

  @override
  State<ListingCards> createState() => _ListingCardsState();
}

class _ListingCardsState extends State<ListingCards> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          context.push('/listing-detail', extra: widget.listing);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Optional: Add a background color
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Opacity(
                    opacity: 0.9,
                    child: widget.listing.imageUrl != null &&
                            widget.listing.imageUrl!.isNotEmpty
                        ? Image.network(
                            widget.listing.imageUrl![
                                0], 
                            width: 360,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Container(
                                  width: 360,
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                      valueColor: AlwaysStoppedAnimation(
                                          AppColors.linearOrange),
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
                          widget.listing.property_name ?? '',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(
                          Icons.star,
                          color: Color(0xffFFB800),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.listing.rating ?? 0}(14)",
                          style: const TextStyle(color: AppColors.textColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.listing.adddress,
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.listing.price != null
                              ? '₱${widget.listing.price!}'
                              : 'N/A',
                          style: const TextStyle(color: AppColors.textColor),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            provider.toggleFavorite(widget.listing);
                          },
                          child: Icon(
                            provider.isExist(widget.listing)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: const Color(0xffF04F43),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
