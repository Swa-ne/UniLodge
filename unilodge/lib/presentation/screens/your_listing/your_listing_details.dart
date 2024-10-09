import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/home/text_row.dart';

class YourListingDetails extends StatelessWidget {
  const YourListingDetails({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.cancel,
                        color: Color.fromARGB(169, 60, 60, 67))),
                const Spacer(),
                GestureDetector(
                    onTap: () async {
                      _displayBottomSheet(context);
                    },
                    child: const Icon(Icons.more_vert)),
                const SizedBox(
                  width: 10,
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: listing.imageUrl != null
                    ? Image.network(
                        listing.imageUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/placeholder.png', // Fallback placeholder
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Text(
                listing.property_name ??
                    "Unnamed Property", // Fallback if property_name is null
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff434343),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextRow(
                text1: "Address:",
                text2: listing.address ??
                    "No address provided", // Fallback if address is null
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextRow(
                text1: "Owner Information:",
                text2: listing.ownerInfo ??
                    "No owner information", // Fallback if ownerInfo is null
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextRow(
                text1: "Amenities:",
                text2:
                    (listing.amenities != null && listing.amenities!.isNotEmpty)
                        ? listing.amenities![0]
                        : "No amenities available", // Fallback for amenities
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "Description",
                style: TextStyle(color: Color(0xff434343), fontSize: 15),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                listing.description ??
                    "No description available", // Fallback if description is null
                style: const TextStyle(
                    color: AppColors.formTextColor, fontSize: 15),
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Divider(
                  height: 20, color: Color.fromARGB(255, 223, 223, 223)),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text("Rating: ",
                      style: TextStyle(color: Color(0xff434343), fontSize: 15)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RatingBar.builder(
                      initialRating: listing.rating?.toDouble() ??
                          0.0, // Fallback if rating is null
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 18,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: AppColors.ratingYellow,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "Reviews (14)", // Can be dynamically updated if needed
                style: TextStyle(color: Color(0xff434343), fontSize: 15),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "dropdown reviews or direct to another screen",
                style: TextStyle(color: AppColors.formTextColor, fontSize: 15),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.lightBackground,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => SizedBox(
              height: 150,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: GestureDetector(
                      onTap: () {
                        context.push("/edit-listing-post/${listing.id}");
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 12),
                          Text("Edit post",
                              style: TextStyle(color: AppColors.textColor)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Remove post",
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
}
