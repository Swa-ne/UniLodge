import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/chat/chat_event.dart';
import 'package:unilodge/bloc/chat/chat_state.dart';
import 'package:unilodge/data/models/message.dart';
import 'package:unilodge/data/sources/chat/chat_repo.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepo _chatRepo;

  ChatBloc(this._chatRepo) : super(ChatLoading()) {
    on<CreateInboxEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final inbox =
              await _chatRepo.createPrivateInbox(event.receiver_user_id);
          emit(CreateInboxSuccess(inbox));
        } catch (e) {
          emit(CreateInboxError(e.toString()));
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
          emit(GetInboxError(e.toString()));
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
          emit(GetReceiverDetailsError(e.toString()));
        }
      },
    );
    on<SaveMessageEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final isSent = await _chatRepo.saveMessage(
              event.message, event.chat_id, event.receiver_id);
          if (isSent) {
            emit(SaveMessageSuccess());
          } else {
            emit(const SaveMessageError("Internet Connection Error"));
          }
        } catch (e) {
          emit(SaveMessageError(e.toString()));
        }
      },
    );
    on<GetMessageEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final messages =
              await _chatRepo.getMessage(event.chat_id, event.page);
          emit(GetMessageSuccess(messages));
        } catch (e) {
          emit(GetMessageError(e.toString()));
        }
      },
    );
    on<OnReceiveMessageEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final message = MessageModel(
              message: event.msg,
              sender: event.sender_id,
              chat_id: event.chat_id,
              is_read: false,
              created_at: DateTime.now().toString());
          emit(OnReceiveMessageSuccess(message));
        } catch (e) {
          emit(OnReceiveMessageError(e.toString()));
        }
      },
    );
  }
}
