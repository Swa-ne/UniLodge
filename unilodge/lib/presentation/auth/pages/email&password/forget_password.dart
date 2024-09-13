import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Aligns items to the center horizontally
          children: [
            // Title "Forget Password"
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Forget Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20), // Spacing between title and container

            // Container with form
            Center(
              child: Container(
                width: 400,
                height: 275,
                decoration: BoxDecoration(
                  color: AppColors.linearGreen, // Container background color
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                      spreadRadius: 2, // How much the shadow spreads
                      blurRadius: 8, // The amount of blur
                      offset: const Offset(0, 4), // Offset of the shadow (horizontal, vertical)
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Enter Email Address
                    const Text(
                      'Enter Email Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Text Field
                    SizedBox(
                      width: 368,
                      height: 55,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // TextField background color
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Elevated Button
                    SizedBox(
                      width: 300,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E3E4A), // Button color
                        ),
                        child: const Text(
                          'Send',
                          style: TextStyle(
                            color: Colors.white, // Button text color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
