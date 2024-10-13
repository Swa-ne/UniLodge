import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/chat/chat_event.dart';
import 'package:unilodge/bloc/chat/chat_state.dart';
import 'package:unilodge/data/models/message.dart';
import 'package:unilodge/data/sources/chat/chat_repo.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepo _chatRepo;
  bool _isSending = false; 

  ChatBloc(this._chatRepo) : super(ChatLoading()) {
    on<CreateInboxEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final inboxId = await _chatRepo.createPrivateInbox(event.receiver_user_id);
          final inbox = await _chatRepo.getInboxDetails(inboxId);
          emit(CreateInboxSuccess(inbox));
        } catch (e) {
          emit(const CreateInboxError("Internet Connection Error"));
        }
      },
    );

    on<GetInboxEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final inbox = await _chatRepo.getInbox();
          emit(GetInboxSuccess(inbox));
        } catch (e) {
          emit(const GetInboxError("Internet Connection Error"));
        }
      },
    );

    on<GetReceiverDetailsEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final user = await _chatRepo.getReceiverDetails(event.chat_id);
          emit(GetReceiverDetailsSuccess(user));
        } catch (e) {
          emit(const GetReceiverDetailsError("Internet Connection Error"));
        }
      },
    );

    on<SaveMessageEvent>(
      (event, emit) async {
        if (_isSending) return; // Prevent duplicate sends
        _isSending = true; // Set sending flag

        emit(MessageSending()); // Notify UI about message sending

        try {
          final isSent = await _chatRepo.saveMessage(
            event.message, event.chat_id, event.receiver_id,
          );
          if (isSent) {
            emit(SaveMessageSuccess());
          } else {
            emit(const SaveMessageError("Failed to send message."));
          }
        } catch (e) {
          emit(const SaveMessageError("Internet Connection Error"));
        } finally {
          _isSending = false; // Reset sending flag
          emit(ChatReady()); // Allow new messages to be sent
        }
      },
    );

    on<GetMessageEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final messages = await _chatRepo.getMessage(event.chat_id, event.page);
          emit(GetMessageSuccess(messages));
        } catch (e) {
          emit(const GetMessageError("Internet Connection Error"));
        }
      },
    );

    on<OnReceiveMessageEvent>(
      (event, emit) async {
        try {
          final message = MessageModel(
            message: event.msg,
            sender: event.sender_id,
            chat_id: event.chat_id,
            is_read: false,
            created_at: DateTime.now().toString(),
            updated_at: DateTime.now().toString(),
          );
          emit(OnReceiveMessageSuccess(message));
        } catch (e) {
          emit(const OnReceiveMessageError("Internet Connection Error"));
        }
      },
    );
  }
}
