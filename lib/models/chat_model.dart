import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/extensions.dart';

class ChatModel {
  // model type
  static final CHATTEXT = 'chat_send_text';
  static final CHATIMAGE = 'chat_send_image';
  static final CHATVIDEO = 'chat_send_video';

  static final SENDERUSER = 'chat_sender_user';
  static final SENDERADMIN = 'chat_sender_admin';

  final String? id;
  final String? content;
  final String? thumbnail;
  final String? type_msg;
  final String? sender;
  final String? receiver;
  final String? type_user;
  final String? room;
  final String? reg_date;

  var isUploading = false;
  var isFailed = false;

  ChatModel({
    this.id,
    this.content,
    this.thumbnail,
    this.type_msg,
    this.sender,
    this.receiver,
    this.type_user,
    this.room,
    this.reg_date,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json["id"],
      content: json["content"],
      thumbnail: json["thumbnail"],
      type_msg: json["type_msg"],
      sender: json["sender"],
      receiver: json["receiver"],
      type_user: json["type_user"],
      room: json["room"],
      reg_date: json["reg_date"],
    );
  }

  Map<String, dynamic> toAPIJson() {
    return {
      "content": this.content,
      "thumbnail": this.thumbnail,
      "type_msg": this.type_msg,
      "sender": this.sender,
      "receiver": this.receiver,
      "type_user": SENDERUSER,
      "room": this.room,
      "reg_date": this.reg_date,
    };
  }

  Map<String, dynamic> toSocketJson(String name) {
    return {
      "room_id": 'room${this.room}',
      "sender_id": 'user${this.sender}',
      "receiver_id": 'admin${this.receiver}',
      "sender_name": name,
      "msg": {
        "content": this.content,
        "thumbnail": this.thumbnail,
        "type_msg": this.type_msg,
        "type_user": SENDERUSER,
        "reg_date": this.reg_date,
      },
    };
  }

  Widget getWidget(
    BuildContext context,
    String name, {
    Function()? onReply,
    ChatModel? previousModel,
  }) {
    var showHeader = false;
    var currentTime = reg_date!.getLocalDateTime;
    var headerText = currentTime.split(' ')[0];
    if (previousModel == null) {
      showHeader = true;
    } else {
      var nextTime = previousModel.reg_date!.getLocalDateTime;
      if (headerText != nextTime.split(' ')[0]) {
        showHeader = true;
        var nextDateTime =
            DateFormat('yyyy-MM-dd').parse(nextTime.split(' ')[0]);
        var currentDateTime = DateFormat('yyyy-MM-dd').parse(headerText);

        if (currentDateTime.add(Duration(days: 1)).isAfter(DateTime.now())) {
          headerText = 'Today';
        } else if (currentDateTime
            .add(Duration(days: 2))
            .isAfter(DateTime.now())) {
          headerText = 'Yesterday';
        } else if (currentDateTime
            .add(Duration(days: 7))
            .isAfter(DateTime.now())) {
          headerText = DateFormat('EEEE').format(nextDateTime).toUpperCase();
        }
      }
    }

    return Column(
      children: [
        if (showHeader)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: offsetSm,
              horizontal: offsetBase,
            ),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  height: 1,
                  color: KangaColor().pinkMatColor,
                )),
                SizedBox(
                  width: offsetBase,
                ),
                Text(
                  headerText,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: KangaColor().pinkMatColor,
                      ),
                ),
                SizedBox(
                  width: offsetBase,
                ),
                Expanded(
                    child: Container(
                  height: 1,
                  color: KangaColor().pinkMatColor,
                )),
              ],
            ),
          ),
        type_user == SENDERUSER
            ? getUserWidget(context, onReply!)
            : getAdminWidget(context, name)
      ],
    );
  }

  Widget getAdminWidget(BuildContext context, String name) {
    var iconSize = 36.0;
    var width = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: offsetXSm),
          padding: EdgeInsets.all(offsetXSm),
          decoration: BoxDecoration(
            color: KangaColor().pinkMatColor,
            borderRadius: BorderRadius.all(Radius.circular(iconSize / 2.0)),
          ),
          child: Image.asset('assets/images/logo.png'),
          width: iconSize,
          height: iconSize,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: width - iconSize - offsetSm - offsetXLg - offsetXSm),
          child: Container(
            margin: EdgeInsets.only(
              bottom: offsetSm,
              left: offsetSm,
            ),
            padding: EdgeInsets.all(offsetSm),
            decoration: BoxDecoration(
              color: KangaColor().bubbleConnerColor(1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(offsetSm),
                topRight: Radius.circular(offsetSm),
                bottomRight: Radius.circular(offsetSm),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name - ${S.current.admin}',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 12.0,
                          ),
                    ),
                    getContentWidget(context),
                  ],
                ),
                SizedBox(
                  height: offsetXSm,
                ),
                Text(
                  reg_date!.getChatTime,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 10.0,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getUserWidget(
    BuildContext context,
    Function() onReply,
  ) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Spacer(),
        Padding(
          padding: EdgeInsets.all(offsetSm),
          child: isUploading
              ? CupertinoActivityIndicator()
              : isFailed
                  ? InkWell(
                      onTap: () => onReply(),
                      child: Icon(Icons.replay),
                    )
                  : Container(),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width - offsetXLg - offsetXSm),
          child: Container(
            margin: EdgeInsets.only(
              bottom: offsetSm,
              right: offsetSm,
            ),
            padding: EdgeInsets.all(offsetSm),
            decoration: BoxDecoration(
              color: KangaColor().pinkMatColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(offsetSm),
                bottomLeft: Radius.circular(offsetSm),
                topRight: Radius.circular(offsetSm),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                getContentWidget(context),
                SizedBox(
                  height: offsetXSm,
                ),
                Text(
                  reg_date!.getChatTime,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 10.0,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getContentWidget(BuildContext context) {
    if (type_msg == CHATTEXT) {
      return Text(
        content!,
        style: Theme.of(context).textTheme.bodyText1,
      );
    }
    if (type_msg == CHATIMAGE) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: CachedNetworkImage(
          imageUrl: content!,
          width: 250.0,
          height: 250.0,
          placeholder: (context, url) => Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150.0,
                  height: 150.0,
                ),
              ),
              Center(child: CupertinoActivityIndicator()),
            ],
          ),
          errorWidget: (context, url, error) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 60,
                ),
                SizedBox(
                  height: offsetBase,
                ),
                Text(
                  S.current.unknownImage,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
          fit: BoxFit.cover,
        ),
      );
    }
    if (type_msg == CHATVIDEO) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(offsetXSm)),
        child: Container(
          width: 250.0,
          height: 250.0,
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: thumbnail!,
                  placeholder: (context, url) => Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                      Center(child: CupertinoActivityIndicator()),
                    ],
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.white,
                          size: 60,
                        ),
                        SizedBox(
                          height: offsetBase,
                        ),
                        Text(
                          S.current.unknownVideo,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              if (!isFailed)
                Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.black.withOpacity(0.7),
                    size: 60.0,
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return Text(
      content!,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }
}
