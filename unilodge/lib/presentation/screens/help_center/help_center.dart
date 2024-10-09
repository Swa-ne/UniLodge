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
                question: "Meow meow meow meow?",
                answer:
                    "Meow meow meow meow, meow meow meow meow.",
              ),
              FAQTile(
                question: "Meow meow meow meow?",
                answer:
                    "Meow meow meow meow, meow meow meow meow.",
              ),
              FAQTile(
                question: "Meow meow meow meow?",
                answer:
                    "Meow meow meow meow, meow meow meow meow meow meow meow meow meow meow meow meow.",
              ),
              FAQTile(
                question: "Meow meow meow meow?",
                answer:
                    "Meow meow meow meow, meow meow meow meow.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
