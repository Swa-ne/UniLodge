import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/inbox.dart';
import 'package:unilodge/data/models/message.dart';
import 'package:unilodge/data/models/user.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {}

class ChatFailure extends ChatState {}

class CreateInboxSuccess extends ChatState {
  final InboxModel inbox;

  const CreateInboxSuccess(this.inbox);

  @override
  List<Object> get props => [inbox];
}

class CreateInboxError extends ChatState {
  final String error;

  const CreateInboxError(this.error);

  @override
  List<Object> get props => [error];
}

class GetInboxSuccess extends ChatState {
  final List<InboxModel> inbox;

  const GetInboxSuccess(this.inbox);

  @override
  List<Object> get props => [inbox];
}

class GetInboxError extends ChatState {
  final String error;

  const GetInboxError(this.error);

  @override
  List<Object> get props => [error];
}

class GetReceiverDetailsSuccess extends ChatState {
  final UserModel user;

  const GetReceiverDetailsSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class GetReceiverDetailsError extends ChatState {
  final String error;

  const GetReceiverDetailsError(this.error);

  @override
  List<Object> get props => [error];
}

class SaveMessageSuccess extends ChatState {}

class SaveMessageError extends ChatState {
  final String error;

  const SaveMessageError(this.error);

  @override
  List<Object> get props => [error];
}

class GetMessageSuccess extends ChatState {
  final List<MessageModel> messages;

  const GetMessageSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

class GetMessageError extends ChatState {
  final String error;

  const GetMessageError(this.error);

  @override
  List<Object> get props => [error];
}

class OnReceiveMessageSuccess extends ChatState {
  final MessageModel message;

  const OnReceiveMessageSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class OnReceiveMessageError extends ChatState {
  final String error;

  const OnReceiveMessageError(this.error);

  @override
  List<Object> get props => [error];
}
