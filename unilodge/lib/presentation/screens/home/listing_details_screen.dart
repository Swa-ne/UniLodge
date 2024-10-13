import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/bloc/chat/chat_bloc.dart';
import 'package:unilodge/bloc/chat/chat_event.dart';
import 'package:unilodge/bloc/chat/chat_state.dart';
import 'package:unilodge/common/widgets/custom_button.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/dummy_data/dummy_data.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/home/nearby_listing.dart';
import 'package:unilodge/presentation/widgets/home/text_row.dart';
import 'package:go_router/go_router.dart';

class ListingDetailScreen extends StatefulWidget {
  final Listing listing;

  const ListingDetailScreen({super.key, required this.listing});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final _chatBloc = BlocProvider.of<ChatBloc>(context);

    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is CreateInboxSuccess) {
          context.push('/chat/${state.inbox.id}', extra: state.inbox);
        } else if (state is CreateInboxError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
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
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.cancel,
                          color: Color.fromARGB(169, 60, 60, 67))),
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
                                  maxHeight: 250, // Set a maximum height
                                  maxWidth: 400, // Set a maximum width
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
                                                'assets/animation/home_loading.json', // Replace with your Lottie animation
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
                          initialRating:
                              widget.listing.rating?.toDouble() ?? 0.0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemSize: 18,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1),
                          itemBuilder: (context, _) => const Icon(
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  "Reviews (0)",
                  style: TextStyle(color: Color(0xff434343), fontSize: 15),
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
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 7,
                    child: CustomButton(
                      text: "Chat with owner",
                      onPressed: () {
                        _chatBloc
                            .add(CreateInboxEvent(widget.listing.owner_id!.id));
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: VerticalDivider(
                      color: Color.fromARGB(75, 67, 67, 67),
                      thickness: 1,
                      width: 20,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
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
      ),
    );
  }
}
