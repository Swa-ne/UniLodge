import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/help_center/faq_tile.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Help Center",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go("/user-profile");
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FAQTile(
                question: "How do I create an account?",
                answer:
                    "You can create an account using your email address, or you may choose to sign up using your Google account.",
              ),
              FAQTile(
                question: "How do I reset my password?",
                answer:
                    "To reset your password, navigate to the Settings menu and select Change Password.",
              ),
              FAQTile(
                question: "How do I save a dorm as a favorite?",
                answer:
                    "To save a dorm as a favorite, simply click the heart icon, and it will be added to your favorites list.",
              ),
              FAQTile(
                question: "How can I contact a property owner?",
                answer:
                    "You can contact the property owner by selecting Chat with Owner, after clicking on the listed property.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
