import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/home_widgets/textRow.dart';

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
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel,
                        color: Color.fromARGB(169, 60, 60, 67))),
                Spacer(),
                GestureDetector(
                    onTap: () async {
                      _displayBottomSheet(context);
                    },
                    child: Icon(Icons.more_vert)),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(listing.imageUrl,
                    width: double.infinity, height: 200, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Text(listing.property_name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff434343))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextRow(text1: "Address:", text2: listing.address),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextRow(
                  text1: "Owner Information:", text2: listing.ownerInfo),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextRow(text1: "Amenities:", text2: listing.amenities[0]),
            ),
            SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "Description",
                style: TextStyle(color: Color(0xff434343), fontSize: 15),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                listing.description,
                style: TextStyle(color: AppColors.formTextColor, fontSize: 15),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: const Divider(
                  height: 20, color: Color.fromARGB(255, 223, 223, 223)),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text("Rating: ",
                      style: TextStyle(color: Color(0xff434343), fontSize: 15)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RatingBar.builder(
                        initialRating: listing.rating.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 18,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1),
                        itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: AppColors.ratingYellow,
                            ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        }),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "Reviews (14)",
                style: TextStyle(color: Color(0xff434343), fontSize: 15),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "dropdown reviews or direct to another screen",
                style: TextStyle(color: AppColors.formTextColor, fontSize: 15),
              ),
            ),
            SizedBox(height: 30),
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
        builder: (context) => Container(
              height: 150,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: GestureDetector(
                      onTap: () {
                        context.push("/edit-listing-post");
                      },
                      child: Row(
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
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
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
