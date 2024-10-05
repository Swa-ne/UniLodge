import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/message/custom_text.dart';
import 'package:unilodge/presentation/widgets/message/example_message.dart';

class MessagesListView extends StatelessWidget {
  final List<Message> messages = List.generate(
    6,
    (index) => Message(name: 'Juan Dela Cruz', content: 'Hello, hm?'),
  );

  MessagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];

              Widget listItem = Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF636464)
                          .withOpacity(0.15), 
                      offset: const Offset(0, 2), 
                      blurRadius: 8, 
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.lightBackground,
                      ),
                    ),
                    const SizedBox(
                        width:
                            10), // Add some spacing between the icon and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: message.name,
                            color: AppColors.textColor,
                            fontSize: 16,
                          ),
                          const SizedBox(height: 5),
                          CustomText(
                            text: message.content,
                            color: AppColors.formTextColor,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          '15/08/24',
                          style: TextStyle(color: Color(0xFFC3C1C9)),
                        ),
                      ],
                    ),
                  ],
                ),
              );

              return Column(
                children: [
                  listItem,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
