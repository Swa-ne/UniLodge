import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:lottie/lottie.dart';
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
  bool _isAvailableBool = true;
  @override
  void initState() {
    super.initState();
    _isAvailableBool = widget.listing.isAvailable!;
  }

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
            _isAvailableBool = !_isAvailableBool;
          });
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
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
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.listing.imageUrl != null &&
                          widget.listing.imageUrl!.isNotEmpty
                      ? SizedBox(
                          height: 200,
                          child: InstaImageViewer(
                            child: Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 250,
                                  maxWidth: 400,
                                ),
                                child: PageView.builder(
                                  itemCount: widget.listing.imageUrl!.length,
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      widget.listing.imageUrl![index],
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Container(
                                            width: 360,
                                            height: 200,
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
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      : Image.network(
                          '',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 16.0),
                    child: Text(
                      widget.listing.property_name ?? "Unnamed Property",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff434343),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: _isAvailableBool
                            ? AppColors.greenActive
                            : AppColors.redInactive,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        _isAvailableBool ? "Available" : "Unavailable",
                        style:
                            const TextStyle(color: AppColors.lightBackground),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:
                    TextRow(text1: "Address:", text2: widget.listing.adddress),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextRow(
                  text1: "Owner:",
                  text2: widget.listing.owner_id?.full_name ??
                      "No owner information",
                ),
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: const Color.fromARGB(6, 0, 0, 0)),
                child: ExpansionTile(
                  backgroundColor: const Color.fromARGB(5, 0, 0, 0),
                  title: Text(
                    "Amenities",
                    style: TextStyle(color: Color(0xff434343), fontSize: 15),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: widget.listing.amenities != null &&
                              widget.listing.amenities!.isNotEmpty
                          ? Column(
                              children: widget.listing.amenities![0]
                                  .split(',')
                                  .map((amenity) => Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              size: 18,
                                              color: AppColors.greenActive,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              amenity.trim(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: AppColors.formTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            )
                          : const Text(
                              "No amenities available",
                              style: TextStyle(
                                  fontSize: 15, color: AppColors.formTextColor),
                            ),
                    ),
                  ],
                ),
              ),
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
                  widget.listing.description ?? "No description available",
                  style: const TextStyle(
                      color: AppColors.formTextColor, fontSize: 15),
                ),
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: const Color.fromARGB(6, 0, 0, 0)),
                child: ExpansionTile(
                  backgroundColor: const Color.fromARGB(5, 0, 0, 0),
                  title: Text(
                    "Lease Terms",
                    style: TextStyle(color: Color(0xff434343), fontSize: 15),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.listing.leastTerms ??
                                  "No lease terms available",
                              style: TextStyle(
                                color: AppColors.formTextColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                        initialRating: widget.listing.rating?.toDouble() ?? 0.0,
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
                        updateOnDrag: false,
                        ignoreGestures: true,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  "Reviews (14)",
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
    final listingBloc = BlocProvider.of<ListingBloc>(context);
    return showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.lightBackground,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => SizedBox(
              height: 250,
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
                        listingBloc.add(DeleteListing(widget.listing.id!));
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
                        listingBloc.add(ToggleListing(widget.listing.id!));
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Toggle post's visibility",
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
