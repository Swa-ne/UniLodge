import 'package:flutter/material.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/home/pages/listingDetailScreen.dart';

class ListingCards extends StatefulWidget {
  final String imageUrl;
  final String property_name;
  final String address;
  final String price;

  const ListingCards({
    super.key,
    required this.imageUrl,
    required this.property_name,
    required this.address,
    required this.price,
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
                listing: Listing(
                  property_name: widget.property_name,
                  address: widget.address,
                  price: widget.price,
                  description:
                      "Description here", // You might need to pass this from a real source
                  ownerInfo:
                      "Owner info here", // You might need to handle this differently
                  amenities: [
                    "Amenity1",
                    "Amenity2"
                  ], // Handle this based on real data
                  imageUrl: widget.imageUrl,
                ),
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
                      widget
                          .imageUrl, // Use widget.imageUrl instead of AppImages.dorm1
                      width: 345,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.property_name,
                          style: TextStyle(
                            color: Color(0xff454545),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.star,
                          color: Color(0xffFFB800),
                        ),
                        Text("4.9(14)",
                            style: TextStyle(color: Color(0xff454545)))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.address,
                      style: TextStyle(color: Color(0xff454545)),
                    ),
                    Row(
                      children: [
                        Text(widget.price,
                            style: TextStyle(color: Color(0xff454545))),
                        Spacer(),
                        Icon(
                          Icons.favorite,
                          color: Color(0xffF04F43),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
