import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class EditListingPost extends StatelessWidget {
  const EditListingPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Listing",
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              onPressed: () {
                print("Save button pressed");
              },
              child: const Text(
                "Save",
              ),
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
