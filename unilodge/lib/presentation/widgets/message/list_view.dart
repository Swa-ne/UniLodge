import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/chat/chat_bloc.dart';
import 'package:unilodge/bloc/chat/chat_event.dart';
import 'package:unilodge/bloc/chat/chat_state.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/inbox.dart';
import 'package:unilodge/presentation/screens/message/chat.dart';
import 'package:unilodge/presentation/widgets/message/custom_text.dart';

class MessagesListView extends StatefulWidget {
  const MessagesListView({super.key});

  @override
  State<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<MessagesListView> {
  final List<InboxModel> inbox = [];
  late ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();

    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.add(GetInboxEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetInboxSuccess) {
            inbox.clear();
            inbox.addAll(state.inbox);
            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ListView.builder(
                  itemCount: inbox.length,
                  itemBuilder: (context, index) {
                    final ibx = inbox[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chat(
                              chat_id: ibx.id,
                              inbox: ibx,
                            ),
                          ),
                        ).then((_) {
                          _chatBloc.add(GetInboxEvent());
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 5),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF636464).withOpacity(0.15),
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
                                    text: ibx.chat_name,
                                    color: AppColors.textColor,
                                    fontSize: 16,
                                  ),
                                  const SizedBox(height: 5),
                                  CustomText(
                                    text: ibx.last_message.message,
                                    color: AppColors.formTextColor,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '15/08/24',
                                  style: TextStyle(color: Color(0xFFC3C1C9)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (state is GetInboxError) {
            return Center(child: Text("Error: ${state.error}"));
          }

          return const Center(child: Text("No messages available"));
        },
      ),
    );
  }
}
