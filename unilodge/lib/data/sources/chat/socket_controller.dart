import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:unilodge/bloc/chat/chat_bloc.dart';
import 'package:unilodge/bloc/chat/chat_event.dart';

final _apiUrl = "${dotenv.env['API_URL']}";

abstract class SocketController {
  void connect(String userId);
  void sendMessage(
      String userId, String receiverId, String message, String chatId);
  void disconnect();
}

class SocketControllerImpl extends SocketController {
  static final SocketControllerImpl _singleton =
      SocketControllerImpl._internal();
  late IO.Socket socket;
  late ChatBloc chatBloc;

  factory SocketControllerImpl() {
    return _singleton;
  }
  void passBloc(ChatBloc bloc) {
    chatBloc = bloc;
  }

  SocketControllerImpl._internal();

  @override
  void connect(String userId) {
    socket = IO.io(_apiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {
        'userId': userId,
      }
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket');
    });

    socket.on('getOnlineUsers', (activeUsers) {
      print('Online users: $activeUsers');
    });

    socket.on('msg-receive', (message) {
      chatBloc.add(OnReceiveMessageEvent(
        message['chatId'],
        message['message'],
        message['senderId'],
      ));

      chatBloc.add(GetInboxEvent());
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });
  }

  @override
  void sendMessage(
      String userId, String receiverId, String message, String chatId) {
    socket.emit('send-msg', {
      'senderId': userId,
      'receiverId': receiverId,
      'msg': message,
      'chatId': chatId,
    });
  }

  @override
  void disconnect() {
    socket.disconnect();
  }
}
