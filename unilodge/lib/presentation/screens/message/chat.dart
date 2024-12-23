import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/chat/chat_bloc.dart';
import 'package:unilodge/bloc/chat/chat_event.dart';
import 'package:unilodge/bloc/chat/chat_state.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/inbox.dart';
import 'package:unilodge/data/models/message.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';

class Chat extends StatefulWidget {
  final String chat_id;
  final InboxModel inbox;

  const Chat({super.key, required this.chat_id, required this.inbox});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ScrollController _scrollController = ScrollController();
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  final TextEditingController messageController = TextEditingController();
  List<MessageModel> messages = [];

  String receiver_name = "";
  late String receiver_id;
  late ChatBloc _chatBloc;
  late String user_id;
  int currentPage = 1;
  bool isLoading = false;

  void _onScroll() {
    if (_scrollController.position.pixels <= 100 && !isLoading) {
      setState(() {
        isLoading = true;
        currentPage++;
      });
      _chatBloc.add(GetMessageEvent(widget.chat_id, currentPage));
    }
  }

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _initializeUserID();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeUserID() async {
    user_id = await _tokenController.getUserID();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatBloc.add(GetMessageEvent(widget.chat_id, currentPage));
    _chatBloc.add(GetReceiverDetailsEvent(widget.chat_id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.5,
        title: CustomText(
          text: receiver_name.isEmpty ? "Loading..." : receiver_name,
          fontSize: 20,
          color: AppColors.primary,
        ),
        backgroundColor: AppColors.lightBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.primary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.chatbg),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is GetReceiverDetailsSuccess) {
              setState(() {
                receiver_name = state.user.full_name;
                receiver_id = state.user.id;
              });
            } else if (state is SaveMessageSuccess) {
              setState(() {
                messages.insert(
                  0,
                  MessageModel(
                    message: messageController.text,
                    sender: user_id,
                    chat_id: widget.chat_id,
                    is_read: false,
                    created_at: DateTime.now().toString(),
                    updated_at: DateTime.now().toString(),
                  ),
                );
                messageController.clear(); // Clear input on success
              });
            } else if (state is GetMessageSuccess) {
              setState(() {
                messages.addAll(state.messages);
                isLoading = false; // Reset loading flag
              });
            } else if (state is OnReceiveMessageSuccess) {
              if (widget.chat_id == state.message.chat_id) {
                setState(() {
                  messages.insert(0, state.message);
                });
              }
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  reverse: true,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    bool isMe = user_id == messages[index].sender;
                    return chatBubble(messages[index].message, isMe);
                  },
                ),
              ),
              messageInput(), // Message input field
            ],
          ),
        ),
      ),
    );
  }

  Widget chatBubble(String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : AppColors.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? AppColors.textColor : AppColors.lightBackground,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget messageInput() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(66, 56, 56, 56),
            offset: Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Message...",
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                ),
                minLines: 1, 
                maxLines:
                    2, 
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                scrollController:
                    ScrollController(), 
                scrollPhysics: const BouncingScrollPhysics(),
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                bool isButtonDisabled =
                    state is MessageSending || state is ChatLoading;

                return IconButton(
                  icon: const Icon(Icons.send),
                  color: AppColors.linearOrange,
                  onPressed: isButtonDisabled
                      ? null
                      : () {
                          final message = messageController.text.trim();
                          if (message.isNotEmpty) {
                            _chatBloc.add(
                              SaveMessageEvent(
                                  message, widget.chat_id, receiver_id),
                            );
                          }
                        },
                );
              },
            ),
          ],
        ),
      ),
    );
  }


}
