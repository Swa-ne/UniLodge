import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/message.dart';

class InboxModel extends Equatable {
  final String id;
  final List<String> user_ids;
  final String profile;
  final String chat_name;
  final bool was_active;
  final MessageModel last_message;

  const InboxModel({
    required this.id,
    required this.user_ids,
    required this.profile,
    required this.chat_name,
    required this.was_active,
    required this.last_message,
  });

  factory InboxModel.fromJson(Map<String, dynamic> json) {
    return InboxModel(
      id: json['_id'],
      user_ids: List<String>.from(json['userIds']),
      profile: json['profile'] ?? '',
      chat_name: json['chatName'] ?? '',
      was_active: json['wasActive'] ?? false,
      last_message: MessageModel.fromJson(json['lastMessage']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userIds': user_ids,
      'profile': profile,
      'chatName': chat_name,
      'wasActive': was_active,
      'lastMessage': last_message,
    };
  }

  @override
  List<Object> get props => [id, user_ids, profile, chat_name, was_active];
}
