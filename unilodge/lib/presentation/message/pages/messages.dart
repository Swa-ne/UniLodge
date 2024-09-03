import 'package:flutter/material.dart';
import 'package:unilodge/presentation/message/widgets/custom_text.dart';
import 'package:unilodge/presentation/message/widgets/list_view.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const CustomText(
          text: 'Messages',
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      body: MessagesListView(),
    );
  }
}
