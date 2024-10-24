import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/crypto/price_text.dart';
import 'package:unilodge/presentation/widgets/home/text_row.dart';

class BookedListingDetails extends StatefulWidget {
  const BookedListingDetails({super.key, required this.listing});

  final Listing listing;

  @override
  State<BookedListingDetails> createState() => _BookedListingDetailsState();
}

class _BookedListingDetailsState extends State<BookedListingDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
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
                        color: AppColors.primary)),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PriceText(
                    text: widget.listing.price != null
                        ? 'ETH ${widget.listing.price!}'
                        : 'N/A'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextRow(text1: "Address:", text2: widget.listing.adddress),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              widget.listing.description ?? "No description available",
              style:
                  const TextStyle(color: AppColors.formTextColor, fontSize: 15),
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
        ],
      ),
    );
  }
}
