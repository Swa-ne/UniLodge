import 'package:flutter/material.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/screens/your_listing/edit_listing_form.dart';

class EditListingPost extends StatelessWidget {
  const EditListingPost({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: const CustomText(
            text: "Edit Listing",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          
          ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: EditListingForm(
        listing: listing,
      ),
    );
  }
}
