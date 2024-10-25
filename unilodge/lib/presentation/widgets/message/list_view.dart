import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/bloc/chat/chat_bloc.dart';
import 'package:unilodge/bloc/chat/chat_event.dart';
import 'package:unilodge/bloc/chat/chat_state.dart';
import 'package:unilodge/common/mixins/time_convertion.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/inbox.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';
import 'package:unilodge/presentation/screens/message/chat.dart';
import 'package:unilodge/presentation/widgets/message/custom_text.dart';

class MessagesListView extends StatefulWidget {
  const MessagesListView({super.key});

  @override
  State<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<MessagesListView>
    with TimeConvertion {
  final List<InboxModel> inbox = [];
  late ChatBloc _chatBloc;
  late TokenControllerImpl _tokenController;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.add(GetInboxEvent());
    _tokenController = TokenControllerImpl();
    _initializeUserID();
  }

  Future<void> _initializeUserID() async {
    final userId = await _tokenController.getUserID();
    if (mounted) {
      setState(() {
        currentUserId = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return Center(
        child: Lottie.asset(
          'assets/animation/home_loading.json',
          width: 200,
          height: 200,
        ),
      );
    }

    return Scaffold(
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return Center(
              child: Lottie.asset(
                'assets/animation/home_loading.json',
                width: 200,
                height: 200,
              ),
            );
          } else if (state is GetInboxSuccess) {
            inbox.clear();
            inbox.addAll(state.inbox);
            return Container(
              margin: const EdgeInsets.all(4),
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
                            const SizedBox(width: 10), // Add spacing
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: ibx.user_ids
                                        .firstWhere(
                                          (user) =>
                                              user.userId.id != currentUserId,
                                        )
                                        .fullName,
                                    color: AppColors.textColor,
                                    fontSize: 18,
                                  ),
                                  const SizedBox(height: 5),
                                  CustomText(
                                    text: ibx.last_message?.message ?? "",
                                    color: AppColors.formTextColor,
                                    fontSize: 15,
                                    // fontWeight:
                                    //     ibx.last_message?.is_read == false
                                    //         ? FontWeight.bold
                                    //         : FontWeight.normal,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  formatChatTimestamp(
                                      ibx.last_message?.created_at ?? ""),
                                  style:
                                      const TextStyle(color: Color(0xFFC3C1C9)),
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
