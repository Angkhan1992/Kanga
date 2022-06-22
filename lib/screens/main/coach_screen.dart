import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/main.dart';
import 'package:kanga/models/chat_model.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/textfield_widget.dart';
import 'package:kanga/utils/extensions.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({Key? key}) : super(key: key);

  @override
  _CoachScreenState createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _msgController = TextEditingController();

  StreamController<List<ChatModel>> _chatController =
      new StreamController.broadcast();
  var _scrollController = ScrollController();

  var _roomInfo = Map();
  UserModel _currentUser = UserModel();

  List<ChatModel> _chats = [];

  @override
  void initState() {
    super.initState();

    Timer.run(() => _getData());

    _chatController.add(_chats);
  }

  @override
  void dispose() {
    super.dispose();

    _msgController.dispose();
    _scrollController.dispose();

    _leaveRoom();
  }

  void _leaveRoom() {
    socketService!.leaveRoom(_currentUser);
  }

  void _getData() async {
    _currentUser = (await PrefProvider().getUser())!;

    var res = await NetworkProvider.of(context).post(
      Constants.header_chat,
      Constants.link_join_room,
      {},
    );
    if (res['ret'] == 10000) {
      _roomInfo = res['result']['room'];

      _chats.clear();
      var chatJson = res['result']['chat'];
      for (var json in chatJson) {
        var chat = ChatModel.fromJson(json);
        _chats.add(chat);
      }
      _chats.sort((a, b) => a.reg_date!.compareTo(b.reg_date!));
      _chatController.add(_chats);

      socketService!.joinRoom(
        user: _currentUser,
        roomId: _roomInfo['id'],
        message: _message,
        joinChat: (data) {},
        leaveRoom: (data) {},
      );

      Future.delayed(Duration(seconds: 1), () {
        _scrollToBottom();
      });
    } else {
      DialogProvider.of(context).showSnackBar(
        res['msg'],
        type: SnackBarType.ERROR,
      );
    }

    setState(() {});
  }

  void _message(data) async {
    var chat = ChatModel.fromJson(data);
    _chats.add(chat);
    _chats.sort((a, b) => a.reg_date!.compareTo(b.reg_date!));

    _chatController.add(_chats);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Container(),
          title: Text(
            S.current.coach,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: offsetXSm,
            ),
            Expanded(
              child: StreamBuilder(
                stream: _chatController.stream,
                builder: (context, snapshot) {
                  return snapshot.data == null
                      ? Container()
                      : ListView.builder(
                          controller: _scrollController,
                          itemBuilder: (context, i) {
                            var chat = _chats[i];
                            return chat.getWidget(
                              context,
                              _roomInfo['admin_name'],
                              onReply: () => _reply(chat),
                              previousModel: i == 0 ? null : _chats[i - 1],
                            );
                          },
                          itemCount: _chats.length,
                        );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: offsetSm),
              padding: EdgeInsets.symmetric(
                horizontal: offsetSm,
                vertical: offsetSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: KangaTextField(
                      controller: _msgController,
                      circleConner: true,
                      hintText: 'Input message',
                      prefixIcon: Icon(
                        Icons.add_circle,
                        color: KangaColor().pinkMatColor,
                        size: 32,
                      ),
                      suffixIcon: Container(
                        width: offsetSm,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: offsetXSm,
                  ),
                  IconButton(
                      icon: Icon(Icons.send), onPressed: () => _sendText()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendText() async {
    var text = _msgController.text;
    if (text.isEmpty) {
      DialogProvider.of(context).showSnackBar(
        S.current.emptyChat,
        type: SnackBarType.ERROR,
      );
      return;
    }
    var chat = ChatModel(
      content: text,
      thumbnail: '',
      type_msg: ChatModel.CHATTEXT,
      sender: _currentUser.id,
      receiver: _roomInfo['admin_id'],
      type_user: ChatModel.SENDERUSER,
      room: _roomInfo['id'],
      reg_date: DateTime.now().getUTCTime,
    );

    _send(chat);
  }

  void _send(ChatModel chat) async {
    print('[CHAT] model ===> ${chat.toAPIJson()}');

    chat.isUploading = true;
    _chats.add(chat);
    _chatController.add(_chats);
    setState(() => _msgController.text = '');

    try {
      var res = await NetworkProvider.of(context).post(
        Constants.header_chat,
        Constants.link_add_chat,
        chat.toAPIJson(),
      );
      if (res['ret'] != 10000) {
        chat.isFailed = true;
      } else {
        chat.isFailed = false;
        socketService!.sendChat(chat, _currentUser);
      }
    } catch (e) {
      chat.isFailed = true;
    }
    chat.isUploading = false;
    _chats.sort((a, b) => a.reg_date!.compareTo(b.reg_date!));
    _chatController.add(_chats);

    _scrollToBottom();
  }

  void _reply(ChatModel chat) async {
    print('[CHAT] model ===> ${chat.toAPIJson()}');

    chat.isUploading = true;
    _chatController.add(_chats);

    try {
      var res = await NetworkProvider.of(context).post(
        Constants.header_chat,
        Constants.link_add_chat,
        chat.toAPIJson(),
      );
      if (res['ret'] != 10000) {
        chat.isFailed = true;
      } else {
        chat.isFailed = false;
        socketService!.sendChat(chat, _currentUser);
      }
    } catch (e) {
      chat.isFailed = true;
    }
    chat.isUploading = false;
    _chats.sort((a, b) => a.reg_date!.compareTo(b.reg_date!));
    _chatController.add(_chats);
  }

  void _scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }
}
