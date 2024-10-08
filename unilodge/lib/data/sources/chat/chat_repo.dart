import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/models/inbox.dart';
import 'package:unilodge/data/models/message.dart';
import 'package:unilodge/data/models/user.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';
import 'package:unilodge/data/sources/chat/socket_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/chat";
final _apiUrlRoot =
    "${dotenv.env['API_URL']}".replaceFirst(RegExp(r'^https?:\/\/'), '');

abstract class ChatRepo {
  Future<bool> saveMessage(String message, String chat_id, String receiver_id);
  Future<InboxModel> createPrivateInbox(String receiver_user_id);
  Future<String> getInboxDetails(String chat_id);
  Future<List<MessageModel>> getMessage(String chat_id, int page);
  Future<List<InboxModel>> getInbox();
  Future<UserModel> getReceiverDetails(String chat_id);
}

class ChatRepoImpl extends ChatRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  final SocketControllerImpl _socketController = SocketControllerImpl();

  @override
  Future<bool> saveMessage(
      String message, String chat_id, String receiver_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.post(
      Uri.parse("$_apiUrl/save_message"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: json.encode(
        {
          'message': message,
          'chat_id': chat_id,
        },
      ),
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      final user_id = await _tokenController.getUserID();
      _socketController.sendMessage(user_id, receiver_id, message, chat_id);
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<InboxModel> createPrivateInbox(String receiver_user_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.post(
      Uri.parse("$_apiUrl/create_private_inbox"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: json.encode(
        {
          'user_id2': receiver_user_id,
        },
      ),
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return InboxModel.fromJson(response_body['message']);
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<String> getInboxDetails(String chat_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
        Uri.http(_apiUrl, "/get_inbox_details", {"chat_id": chat_id}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        });
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return response_body["message"];
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<List<MessageModel>> getMessage(String chat_id, int page) async {
    try {
      final access_token = await _tokenController.getAccessToken();
      final refresh_token = await _tokenController.getRefreshToken();
      var response = await http.get(
          Uri.http(_apiUrlRoot, "/chat/get_messages",
              {"chat_id": chat_id, "page": page.toString()}),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': access_token,
            'Cookie': 'refresh_token=$refresh_token',
          });
      final response_body = json.decode(response.body);
      if (response.statusCode == 200) {
        List<MessageModel> messageList = (response_body['message'] as List)
            .map((json) => MessageModel.fromJson(json))
            .toList();
        return messageList;
      } else {
        throw Exception(response_body['message']);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<List<InboxModel>> getInbox() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
      Uri.parse("$_apiUrl/get_inbox"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      List<InboxModel> inboxList = (response_body['message'] as List)
          .map((json) => InboxModel.fromJson(json))
          .toList();

      return inboxList;
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<UserModel> getReceiverDetails(String chat_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
      Uri.http(_apiUrlRoot, "/chat/get_user_details", {"chat_id": chat_id}),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return UserModel.fromJson(response_body['message']);
    } else {
      throw Exception(response_body['message']);
    }
  }
}
