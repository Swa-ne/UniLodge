import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/bloc/booking_bloc/booking_event.dart';
import 'package:unilodge/bloc/listing/listing_bloc.dart';
import 'package:unilodge/bloc/listing/listing_event.dart';
import 'package:unilodge/bloc/listing/listing_state.dart';
import 'package:unilodge/bloc/booking_bloc/booking_bloc.dart';
import 'package:unilodge/common/widgets/custom_confirm_dialog.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/home/price_text.dart';
import 'package:unilodge/presentation/widgets/home/text_row.dart';
import 'package:unilodge/presentation/widgets/listing/tab_bar.dart';

class YourListingDetails extends StatefulWidget {
  const YourListingDetails({super.key, required this.listing});

  final Listing listing;

  @override
  State<YourListingDetails> createState() => _YourListingDetailsState();
}

class _YourListingDetailsState extends State<YourListingDetails> {
  bool _isAvailableBool = true;

  // Sample bookings data
  List<Map<String, dynamic>> bookingsData = [];

  @override
  void initState() {
    super.initState();
    _isAvailableBool = widget.listing.isAvailable ?? true;

    // Initialize bookings data

    // Fetch bookings for this listing by triggering an event in the BookingBloc
    final bookingBloc = BlocProvider.of<BookingBloc>(context, listen: false);
    bookingBloc.add(FetchBookingsForListingEvent(widget.listing.id!));
  }

  @override
  Widget build(BuildContext context) {
    final listingBloc = BlocProvider.of<ListingBloc>(context);
    // final bookingBloc = BlocProvider.of<BookingBloc>(context);

    return BlocListener<ListingBloc, ListingState>(
      listener: (context, state) {
        if (state is SuccessDeleted) {
          listingBloc.add(FetchListings());
          context.go("/listings");
        } else if (state is SuccessToggle) {
          listingBloc.add(FetchListings());
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
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.cancel,
                        color: Color.fromARGB(169, 60, 60, 67)),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      _displayBottomSheet(context);
                    },
                    child: const Icon(Icons.more_vert),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 20),
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
                                constraints: const BoxConstraints(
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
                                          return SizedBox(
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
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property Name and ETH Price Row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.listing.property_name ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff434343),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                                width: 8), // Add some space before the price
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0), // Move ETH price to the left
                              child: PriceText(
                                text: widget.listing.price != null
                                    ? 'ETH ${widget.listing.price!}'
                                    : 'N/A',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status on Top of Property Name
                  // Positioned(
                  //   top: 0, // Position the status on top of property name
                  //   left: 16, // Align it with the left padding of the text
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: _isAvailableBool
                  //           ? AppColors.greenActive
                  //           : AppColors.redInactive,
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 8, vertical: 4),
                  //     child: Text(
                  //       _isAvailableBool ? "Available" : "Unavailable",
                  //       style: const TextStyle(
                  //         color: AppColors.lightBackground,
                  //         fontSize: 12, // Smaller font for the status
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextRow(
                    text1: "Wallet address:",
                    text2: widget.listing.walletAddress!),
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
                  title: const Text(
                    "Amenities and Utilities",
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
                                              style: const TextStyle(
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
              const SizedBox(height: 45),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(
                    height: 20, color: Color.fromARGB(255, 223, 223, 223)),
              ),
              const SizedBox(height: 45),
              BookingManagementWidget(listingId: widget.listing.id!),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future _displayBottomSheet(BuildContext context) {
    final listingBloc = BlocProvider.of<ListingBloc>(context);

    Future<void> _showConfirmationDialog({
      required BuildContext context,
      required String title,
      required String content,
      required VoidCallback onConfirm,
      Color yesButtonColor = AppColors.redInactive,
    }) async {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return ConfirmationDialog(
            title: title,
            content: content,
            onConfirm: onConfirm,
            yesButtonColor: yesButtonColor,
          );
        },
      );
    }

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.lightBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.edit, color: AppColors.primary),
            title: const CustomText(
              text: "Edit post",
              color: AppColors.textColor,
              fontSize: 14,
            ),
            onTap: () {
              _showConfirmationDialog(
                context: context,
                title: "Edit Listing",
                content: "Are you sure you want to edit this post?",
                onConfirm: () {
                  context.push("/edit-listing-post", extra: widget.listing);
                },
                yesButtonColor: AppColors.primary,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: AppColors.primary),
            title: const CustomText(
              text: "Remove post",
              color: AppColors.textColor,
              fontSize: 14,
            ),
            onTap: () {
              _showConfirmationDialog(
                context: context,
                title: "Remove Post",
                content: "Are you sure you want to remove this post?",
                onConfirm: () {
                  listingBloc.add(DeleteListing(widget.listing.id!));
                  Navigator.pop(context);
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.visibility, color: AppColors.primary),
            title: const Text(
              "Toggle post's visibility",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 14, // Smaller font size
              ),
            ),
            onTap: () {
              _showConfirmationDialog(
                context: context,
                title: "Toggle Visibility",
                content:
                    "Are you sure you want to toggle the visibility of this post?",
                onConfirm: () {
                  listingBloc.add(ToggleListing(widget.listing.id!));
                  Navigator.pop(context);
                },
              );
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
