import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/common/widgets/custom_button.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class IdDetails extends StatelessWidget {
  const IdDetails({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CustomText(
          text: "Get Verified",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Prepare a valid ID',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
                children: [
                  selfieOption(
                    'Readable information on ID',
                    'assets/images/verify_user/readable.webp',
                  ),
                  selfieOption(
                    'Upload a real ID, not a photocopy',
                    'assets/images/verify_user/real_id.webp',
                  ),
                  selfieOption(
                    'ID photo must match your selfie',
                    'assets/images/verify_user/match.webp',
                  ),
                  selfieOption(
                    'All information must be correct',
                    'assets/images/verify_user/correct.webp',
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 16), // Add some space between GridView and the button
            // SizedBox(
            //   width: double
            //       .infinity, // Make the button take almost the full width of the screen
            //   child: ElevatedButton(
            //     onPressed: () {
            //       context.push('/verify-id');
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //     child: const Text(
            //       'Next',
            //       style: TextStyle(fontSize: 16, color: Colors.white),
            //     ),
            //   ),
            // ),
            CustomButton(
                text: "Next",
                onPressed: () {
                  context.push('/verify-id');
                })
          ],
        ),
      ),
    );
  }

  // Widget for each selfie option with image, description, and whether it's correct or not
  Widget selfieOption(String description, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(imagePath), // Add your images to assets
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
