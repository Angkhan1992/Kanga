import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:kanga/models/chat_model.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/notification_provider.dart';
import 'package:kanga/utils/constants.dart';

class SocketProvider {
  IO.Socket? socket;

  createSocketConnection(UserModel user) {
    socket = IO.io(
        (kReleaseMode || PRODUCTTEST) ? RELEASESOCKET : DEBUGSOCKET,
        IO.OptionBuilder()
            .setTransports(["websocket"])
            .disableAutoConnect()
            .build());
    socket!.connect();
    print(
        '[SOCKET] connecting to ${(kReleaseMode || PRODUCTTEST) ? RELEASESOCKET : DEBUGSOCKET}');

    socket!.onConnect((_) {
      print('[SOCKET] connected');
      var param = {
        'user_id': 'user${user.id}',
        'name': user.getName(),
        'type': 'user',
      };
      socket!.emit(
        'self',
        param,
      );
    });

    socket!.onDisconnect((_) => print('[SOCKET] disconnect'));
    socket!.onConnectError((data) => print('[SOCKET] onConnectError : $data'));
    socket!.onError((data) => print('[SOCKET] onError : $data'));

    this.socket!.on("unread", (value) async {
      print("[SOCKET] receive unread ===> ${value.toString()}");

      var content = value['content']['content'];
      if (value['content']['type_msg'] == ChatModel.CHATIMAGE) {
        content = 'Sent an Image File';
      }
      if (value['content']['type_msg'] == ChatModel.CHATVIDEO) {
        content = 'Sent a Video File';
      }
      NotificationProvider.showNotification('${value['name']}', '$content',
          NotificationProvider.keyMessageChannel);
    });

    this.socket!.on("notification", (value) async {
      print("[SOCKET] receive notification ===> ${value.toString()}");

      // NotificationProvider.showNotification('Notice', '${value['content']}',
      //     NotificationProvider.keyNotificationChannel);
    });
  }

  void joinRoom({
    required UserModel user,
    required String roomId,
    required Function(dynamic) message,
    required Function(dynamic) leaveRoom,
    required Function(dynamic) joinChat,
  }) {
    var param = {
      'user_id': 'user${user.id}',
      'room_id': 'room$roomId',
      'name': user.getName(),
    };
    socket!.emit('joinRoom', param);
    print('[SOCKET] join room ===> $param');

    this.socket!.on("message", (value) async {
      print("[SOCKET] receive chat ===> ${value['content']}");
      if (value["type_user"] == ChatModel.SENDERUSER) return;
      message(value);
    });
  }

  void sendChat(ChatModel chat, UserModel user) {
    socket!.emit('chatMessage', chat.toSocketJson(user.getName()));
    print('[SOCKET] send chat ===> ${chat.toSocketJson(user.getName())}');
  }

  void leaveRoom(UserModel user) {
    socket!.emit('leaveRoom', {
      'user_id': 'user${user.id}',
    });
    print('[SOCKET] leave room');
  }
}
