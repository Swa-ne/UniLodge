import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FaceDetails extends StatelessWidget {
  const FaceDetails({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Verified'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Be Selfie-Ready',
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
                    'Clear and not blurred',
                    'assets/images/verify_user/clear.webp',
                    true,
                  ),
                  selfieOption(
                    'Wear proper attire',
                    'assets/images/verify_user/proper_attire.webp',
                    true,
                  ),
                  selfieOption(
                    'No cap, mask, or glasses',
                    'assets/images/verify_user/no_cap.webp',
                    false,
                  ),
                  selfieOption(
                    'Solo, no one else in the frame',
                    'assets/images/verify_user/solo.webp',
                    false,
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 16), // Add some space between GridView and the button
            SizedBox(
              width: double
                  .infinity, // Make the button take almost the full width of the screen
              child: ElevatedButton(
                onPressed: () {
                  context.push('/verify-face');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for each selfie option with image, description, and whether it's correct or not
  Widget selfieOption(String description, String imagePath, bool isCorrect) {
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
          const SizedBox(height: 8),
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
