import 'package:flutter/material.dart';
import 'package:unilodge/presentation/message/widgets/custom_text.dart';
import 'package:unilodge/presentation/message/widgets/example_message.dart';

class MessagesListView extends StatelessWidget {
  final List<Message> messages = List.generate(
    10,
    (index) => Message(name: 'Juan Dela Cruz', content: 'Hello, hm?'),
  );

  MessagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
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

              Widget listItem = ListTile(
                leading: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFF6F6),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFFC3C1C9),
                  ),
                ),
                title: CustomText(
                  text: message.name,
                  color: Colors.black,
                  fontSize: 16,
                ),
                subtitle: CustomText(
                  text: message.content,
                  color: Colors.black,
                  fontSize: 12,
                ),
                trailing: const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '15/08/24',
                      style: TextStyle(color: Color(0xFFC3C1C9)),
                    ),
                  ],
                ),
              );

              return Column(
                children: [
                  listItem,
                  const SizedBox(
                    width: 350,
                    child: Divider(
                      color: Color(0xFFC3C1C9),
                      thickness: .5,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
