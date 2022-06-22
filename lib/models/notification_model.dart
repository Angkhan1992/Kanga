import 'package:flutter/material.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';

class NotificationModel {
  String id;
  String sender_id;
  String sender_first;
  String sender_last;
  String receiver_id;
  String content;
  String type;
  String reg_date;
  String other;
  bool isSelected;

  NotificationModel({
    this.id = '',
    this.sender_id = '',
    this.sender_first = '',
    this.sender_last = '',
    this.receiver_id = '',
    this.content = '',
    this.type = '',
    this.reg_date = '',
    this.other = '',
    this.isSelected = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"],
      sender_id: json["sender_id"],
      sender_first: json["sender_first"],
      sender_last: json["sender_last"],
      receiver_id: json["receiver_id"],
      content: json["content"],
      type: json["type"],
      reg_date: json["reg_date"],
      other: json["other"],
    );
  }

  Widget getWidget(BuildContext context,
      {bool isShow = false, Function()? onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: offsetBase,
        vertical: offsetXSm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetBase),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: offsetBase,
            vertical: offsetSm,
          ),
          child: type.toLowerCase() == 'live'
              ? _liveWidget(context, isShow: isShow)
              : type.toLowerCase() == 'admin'
                  ? _adminWidget()
                  : Container(),
        ),
      ),
    );
  }

  Widget _adminWidget() {
    return Container();
  }

  Widget _liveWidget(BuildContext context, {bool isShow = false}) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: offsetSm, vertical: offsetSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.live_tv_sharp,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    SizedBox(width: offsetBase,),
                    Text(
                      sender_first[0].toUpperCase() +
                          sender_first.substring(1) +
                          ' ' +
                          sender_last[0].toUpperCase(),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    if (other == '0') Container(
                      margin: EdgeInsets.only(left: offsetSm),
                      width: offsetSm, height: offsetSm,
                      decoration: BoxDecoration(
                        color: KangaColor.kangaButtonBackColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Spacer(),
                    if (!isShow) Text(
                      'View Detail >',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        color: KangaColor.kangaButtonBackColor, fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: offsetXSm,
                ),
                Text(
                  'You just received the live invitation.',
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
        if (isShow)
          Icon(
            isSelected
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            color: KangaColor.kangaButtonBackColor,
          ),
      ],
    );
  }
}
