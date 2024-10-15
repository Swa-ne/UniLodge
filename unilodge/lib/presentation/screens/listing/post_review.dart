import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/listing/listing_bloc.dart';
import 'package:unilodge/bloc/listing/listing_event.dart';
import 'package:unilodge/bloc/listing/listing_state.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/presentation/widgets/home/text_row.dart';

class PostReview extends StatelessWidget {
  const PostReview({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final listingBloc = BlocProvider.of<ListingBloc>(context);
    List<String> imagePaths = listing.imageUrl ?? [];
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
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(imagePaths[index]),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 100);
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
              // _buildInfoRow('Property Name:', listing.property_name),
              // _buildInfoRow('Property Type:', listing.selectedPropertyType),
              // _buildInfoRow('Address:', listing.address),
              // _buildInfoRow('Price:', listing.price),
              // _buildInfoRow('Description:', listing.description),
              // _buildInfoRow('Lease Terms:', listing.leastTerms),
              // const SizedBox(height: 20),
              // const Text(
              //   'Amenities:',
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // ),
              // if (listing.amenities != null && listing.amenities!.isNotEmpty)
              //   ...listing.amenities!
              //       .map((amenity) => Text('- $amenity'))
              //       .toList()
              // else
              //   const Text('No amenities selected'),
              // const SizedBox(height: 10),
              // const Text(
              //   'Utilities:',
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // ),
              // if (listing.utilities != null && listing.utilities!.isNotEmpty)
              //   ...listing.utilities!
              //       .map((utility) => Text('- $utility'))
              //       .toList()
              // else
              //   const Text('No utilities selected'),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 16.0),
                child: Text(listing.property_name ?? '',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff434343))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextRow(text1: "Address:", text2: listing.adddress),
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: const Color.fromARGB(6, 0, 0, 0)),
                child: ExpansionTile(
                  backgroundColor: const Color.fromARGB(5, 0, 0, 0),
                  title: const Text(
                    "Amenities",
                    style: TextStyle(color: Color(0xff434343), fontSize: 15),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display amenities
                          if (listing.amenities != null &&
                              listing.amenities!.isNotEmpty)
                            ...listing.amenities!
                                .map((amenity) => Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
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
                                              color: AppColors.formTextColor,
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
                                  fontSize: 15, color: AppColors.formTextColor),
                            ),
                          const SizedBox(height: 20),
                          const Text(
                            'Utilities:',
                            style: TextStyle(
                                color: Color(0xff434343), fontSize: 15),
                          ),
                          if (listing.utilities != null &&
                              listing.utilities!.isNotEmpty)
                            ...listing.utilities!
                                .map((utility) => Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
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
                                              color: AppColors.formTextColor,
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
                                  fontSize: 15, color: AppColors.formTextColor),
                            ),
                          const SizedBox(height: 20),
                        ],
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
                  listing.description ?? "No description available",
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
                              listing.leastTerms ?? "No lease terms available",
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
                    context.pop(); // Go back to the previous page
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
                const SizedBox(width: 20),
                BlocBuilder<ListingBloc, ListingState>(
                  builder: (context, state) {
                    bool isSubmitting = state is SubmittingState;
                    return ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              listingBloc
                                  .add(CreateListing(imageFiles, listing));
                            },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            isSubmitting ? Colors.grey : AppColors.primary,
                        minimumSize: const Size(120, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(0, 0, 131, 231)),
                              ),
                            )
                          : const Text('Submit'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to display key-value info rows
  Widget _buildInfoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        '$title ${value ?? "N/A"}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
