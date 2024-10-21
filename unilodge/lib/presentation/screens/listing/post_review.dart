import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/bloc/listing/listing_bloc.dart';
import 'package:unilodge/bloc/listing/listing_event.dart';
import 'package:unilodge/bloc/listing/listing_state.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/presentation/widgets/home/text_row.dart';

class PostReview extends StatefulWidget {
  const PostReview({super.key, required this.listing});

  final Listing listing;

  @override
  _PostReviewState createState() => _PostReviewState();
}

class _PostReviewState extends State<PostReview> {
  bool isLoading = false;
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final listingBloc = BlocProvider.of<ListingBloc>(context);
    List<String> imagePaths = widget.listing.imageUrl ?? [];
    List<File> imageFiles = imagePaths.map((path) => File(path)).toList();

    return BlocListener<ListingBloc, ListingState>(
      listener: (context, state) {
        if (state is ListingCreated) {
          listingBloc.add(FetchListings());
          context.go("/home");
        } else if (state is ListingCreationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
          setState(() {
            isLoading = false;
            isSubmitted = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios, color: AppColors.textColor),
              onPressed: () {
                context.push("/listings");
              },
            )),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Review your listing',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Uploaded images:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (imagePaths.isNotEmpty)
                    SizedBox(
                      height: 230,
                      width: 380,
                      child: PageView.builder(
                        itemCount: imagePaths.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(imagePaths[index]),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image,
                                      size: 100);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const Text('No images uploaded'),
                  const SizedBox(height: 20),
                  // Information rows
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 16.0),
                    child: Text(widget.listing.property_name ?? '',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff434343))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:
                        TextRow(text1: "Price:", text2: widget.listing.price!),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextRow(
                        text1: "Wallet address:",
                        text2: widget.listing.walletAddress!),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextRow(
                        text1: "Address:", text2: widget.listing.adddress),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                        dividerColor: const Color.fromARGB(6, 0, 0, 0)),
                    child: ExpansionTile(
                      backgroundColor: const Color.fromARGB(5, 0, 0, 0),
                      title: const Text(
                        "Amenities",
                        style:
                            TextStyle(color: Color(0xff434343), fontSize: 15),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.listing.amenities != null &&
                                  widget.listing.amenities!.isNotEmpty)
                                ...widget.listing.amenities!
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
                                                amenity,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.formTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList()
                              else
                                const Text(
                                  "No amenities available",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.formTextColor),
                                ),
                              const SizedBox(height: 20),
                              const Text(
                                'Utilities:',
                                style: TextStyle(
                                    color: Color(0xff434343), fontSize: 15),
                              ),
                              if (widget.listing.utilities != null &&
                                  widget.listing.utilities!.isNotEmpty)
                                ...widget.listing.utilities!
                                    .map((utility) => Padding(
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
                                                utility,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      AppColors.formTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList()
                              else
                                const Text(
                                  "No utilities available",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.formTextColor),
                                ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Text(
                      "Description",
                      style: TextStyle(color: Color(0xff434343), fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Text(
                      widget.listing.description ?? "No description available",
                      style: const TextStyle(
                          color: AppColors.formTextColor, fontSize: 15),
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                        dividerColor: const Color.fromARGB(6, 0, 0, 0)),
                    child: ExpansionTile(
                      backgroundColor: const Color.fromARGB(5, 0, 0, 0),
                      title: const Text(
                        "Lease Terms",
                        style:
                            TextStyle(color: Color(0xff434343), fontSize: 15),
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
                ],
              ),
            ),
            if (isLoading)
              Center(
                child: SizedBox(
                  width: 360,
                  height: 200,
                  child: Center(
                    child: Lottie.asset(
                      'assets/animation/home_loading.json',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.horizontal(),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.black, width: 1),
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Back"),
                ),
                ElevatedButton(
                  onPressed: isSubmitted ||
                          isLoading 
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                            isSubmitted = true; 
                          });
                          listingBloc.add(CreateListing(
                            imageFiles,
                            widget.listing,
                          ));
                        },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        isLoading ? Colors.grey : AppColors.primary,
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
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
