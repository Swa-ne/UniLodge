import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/home/pages/listingDetailScreen.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListingDetailScreen(
                listing: widget.listing, 
              ),
            ),
          );
        },
        child: Container(
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.network(
                      widget.listing.imageUrl,
                      width: 360,
                      height: 200,
                      fit: BoxFit.cover,
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
                          widget.listing.property_name,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.star,
                          color: Color(0xffFFB800),
                        ),
                        Text(
                          widget.listing.rating.toString() + "(14)",
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.listing.address,
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.listing.price,
                          style: TextStyle(color: AppColors.textColor),
                        ),
                        Spacer(),
                        Icon(
                          Icons.favorite,
                          color: Color(0xffF04F43),
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
