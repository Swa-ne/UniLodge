import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class CreateInboxEvent extends ChatEvent {
  final String receiver_user_id;

  const CreateInboxEvent(this.receiver_user_id);

  @override
  List<Object> get props => [receiver_user_id];
}

class SaveMessageEvent extends ChatEvent {
  final String message;
  final String chat_id;
  final String receiver_id;

  const SaveMessageEvent(this.message, this.chat_id, this.receiver_id);

  @override
  List<Object> get props => [message, chat_id, receiver_id];
}

class GetMessageEvent extends ChatEvent {
  final String chat_id;
  final int page;

  const GetMessageEvent(this.chat_id, this.page);

  @override
  List<Object> get props => [chat_id, page];
}

class GetReceiverDetailsEvent extends ChatEvent {
  final String chat_id;

  const GetReceiverDetailsEvent(this.chat_id);

  @override
  List<Object> get props => [chat_id];
}

class GetInboxEvent extends ChatEvent {}

class OnReceiveMessageEvent extends ChatEvent {
  final String chat_id;
  final String msg;
  final String sender_id;

  const OnReceiveMessageEvent(this.chat_id, this.msg, this.sender_id);

  @override
  List<Object> get props => [chat_id, msg, sender_id];
}
