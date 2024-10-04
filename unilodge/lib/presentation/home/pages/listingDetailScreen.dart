import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:unilodge/common/widgets/customButton.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/dummy_data/dummy_data.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/home/widgets/nearbyListing.dart';
import 'package:unilodge/presentation/home/widgets/textRow.dart';

class ListingDetailScreen extends StatelessWidget {
  final Listing listing;

  const ListingDetailScreen({Key? key, required this.listing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: (){
      // },
      // child: Icon(Icons.message, color: Color(0xfffdfdfd),),
      // backgroundColor: Color(0xff2E3E4A),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel,
                        color: Color.fromARGB(169, 60, 60, 67))),
              ],
            ),
            SizedBox(
              height: 20,
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "Nearby Listings",
                style: TextStyle(color: Color(0xff434343), fontSize: 15),
              ),
            ),
            // i should pass the data here
            NearbyProperties(listings: dummyListings)
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 59, 59, 59).withOpacity(1),
                spreadRadius: 10,
                blurRadius: 30,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 65,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  flex: 7,
                  child: CustomButton(
                    text: "Chat with owner",
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: const VerticalDivider(
                    color: Color.fromARGB(75, 67, 67, 67),
                    thickness: 1,
                    width: 20,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.favorite_border,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
