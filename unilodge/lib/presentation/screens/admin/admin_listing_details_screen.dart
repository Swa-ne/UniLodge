import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/bloc/renter/renter_bloc.dart';
import 'package:unilodge/common/widgets/shimmer_loading.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/admin/status_text.dart';
import 'package:unilodge/presentation/widgets/home/price_text.dart';
import 'package:unilodge/presentation/widgets/home/text_row.dart';

class AdminListingDetailScreen extends StatefulWidget {
  final Listing listing;

  const AdminListingDetailScreen({super.key, required this.listing});

  @override
  State<AdminListingDetailScreen> createState() =>
      _AdminListingDetailScreenState();
}

class _AdminListingDetailScreenState extends State<AdminListingDetailScreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RenterBloc>(context).add(FetchAllDorms());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RenterBloc, RenterState>(
          listener: (context, state) {
            if (state is DormsLoading) {
              const SizedBox(
                height: 800,
                child: ShimmerLoading(),
              );
            } else if (state is AllDormsLoaded) {
              setState(() {
                isSaved = state.savedDorms.any(
                    (savedListing) => savedListing.id == widget.listing.id);
              });
            }
          },
        ),
      ],
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
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.cancel,
                          color: Color.fromARGB(169, 60, 60, 67))),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: StatusText(),
                  )
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
                    child: Text(widget.listing.property_name ?? '',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff434343))),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PriceText(
                        text: widget.listing.price != null
                            ? '₱${widget.listing.price!}'
                            : 'N/A'),
                  ),
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
                    text2: widget.listing.owner_id?.full_name ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextRow(
                    text1: "Type:",
                    text2: widget.listing.selectedPropertyType ?? ''),
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
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: const Color.fromARGB(6, 0, 0, 0)),
                child: ExpansionTile(
                  backgroundColor: const Color.fromARGB(5, 0, 0, 0),
                  title: const Text(
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
                              style: const TextStyle(
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

              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              //   child: Text(
              //     "dropdown reviews or direct to another screen",
              //     style:
              //         TextStyle(color: AppColors.formTextColor, fontSize: 15),
              //   ),
              // ),
              const SizedBox(height: 30),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              //   child: Text(
              //     "Nearby Listings",
              //     style: TextStyle(color: Color(0xff434343), fontSize: 15),
              //   ),
              // ),
              // i should pass the data here
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
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            height: 65,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.redInactive,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Decline",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.greenActive,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Approve",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
