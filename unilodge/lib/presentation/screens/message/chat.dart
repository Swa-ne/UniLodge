import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/chat/chat_bloc.dart';
import 'package:unilodge/bloc/chat/chat_event.dart';
import 'package:unilodge/bloc/chat/chat_state.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
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
  TextEditingController messageController = TextEditingController();
  List<MessageModel> messages = [];

  String receiver_name = "";
  late String receiver_id;
  late ChatBloc _chatBloc;
  int currentPage = 1;
  bool isLoading = false;
  late String user_id;

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
  }

  Future<void> _initializeUserID() async {
    user_id = await _tokenController.getUserID();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatBloc.add(GetMessageEvent(widget.chat_id, currentPage));
    _chatBloc.add(GetReceiverDetailsEvent(widget.chat_id));

    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: receiver_name.isEmpty ? "Loading..." : receiver_name,
          fontSize: 20,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 53, 124, 218),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is GetReceiverDetailsSuccess) {
            setState(() {
              receiver_name = state.user.full_name!;
              receiver_id = state.user.id!;
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
              messageController.clear();
            });
          } else if (state is GetMessageSuccess) {
            setState(() {
              messages.addAll(state.messages);
            });
          } else if (state is OnReceiveMessageSuccess) {
            // if (widget.chat_id == state.message.chat_id) {
            setState(() {
              messages.insert(0, state.message);
            });
            // }
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
            messageInput(),
          ],
        ),
      ),
    );
  }

  Widget chatBubble(String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isMe ? Colors.grey[300] : const Color.fromARGB(255, 53, 124, 218),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.black : Colors.white, fontSize: 16
          ),
        ),
      ),
    );
  }

  Widget messageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: const Color.fromARGB(255, 53, 124, 218),
            onPressed: () {
              _chatBloc.add(SaveMessageEvent(
                  messageController.text, widget.chat_id, receiver_id));
            },
          ),
        ],
      ),
    );
  }
}
