import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/listing/listing_bloc.dart';
import 'package:unilodge/bloc/listing/listing_event.dart';
import 'package:unilodge/bloc/listing/listing_state.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/home/text_row.dart';

class YourListingDetails extends StatefulWidget {
  const YourListingDetails({super.key, required this.listing});

  final Listing listing;

  @override
  State<YourListingDetails> createState() => _YourListingDetailsState();
}

class _YourListingDetailsState extends State<YourListingDetails> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ListingBloc, ListingState>(
      listener: (context, state) {
        if (state is SuccessDeleted) {
          context.go("/listings");
        } else if (state is ToggleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is DeletionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is SuccessToggle) {
          setState(() {
            // widget.listing.isAvailable = !(widget.listing.isAvailable!);
          });
        }
      },
      child: Scaffold(
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
                  child: widget.listing.imageUrl != null
                      ? Image.network(
                          widget.listing.imageUrl?[0] ?? '',
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
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 16.0),
                child: Text(
                  widget.listing.property_name ??
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
                  text2: widget.listing.address ??
                      "No address provided", // Fallback if address is null
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextRow(
                  text1: "Owner Information:",
                  text2: widget.listing.owner_id ??
                      "No owner information", // Fallback if owner_id is null
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextRow(
                  text1: "Amenities:",
                  text2: (widget.listing.amenities != null &&
                          widget.listing.amenities!.isNotEmpty)
                      ? widget.listing.amenities![0]
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
                  widget.listing.description ??
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
                        style:
                            TextStyle(color: Color(0xff434343), fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2.0, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RatingBar.builder(
                        initialRating: widget.listing.rating?.toDouble() ??
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
                  style:
                      TextStyle(color: AppColors.formTextColor, fontSize: 15),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future _displayBottomSheet(BuildContext context) {
    final _listingBloc = BlocProvider.of<ListingBloc>(context);
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
                        context.push("/edit-listing-post",
                            extra: widget.listing);
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
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: GestureDetector(
                      onTap: () {
                        _listingBloc.add(DeleteListing(widget.listing.id!));
                      },
                      child: const Row(
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
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: GestureDetector(
                      onTap: () {
                        _listingBloc.add(DeleteListing(widget.listing.id!));
                      },
                      child: Row(
                        children: [
                          Icon(
                            widget.listing.isAvailable!
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.listing.isAvailable!
                                ? "Hide post"
                                : "Show post",
                            style: const TextStyle(color: AppColors.textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
