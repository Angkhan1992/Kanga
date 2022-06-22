import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/live_model.dart';
import 'package:kanga/models/notification_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/screens/class/live_detail_screen.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/common_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> _notifications = [];
  var _isSelectedMode = false;

  @override
  void initState() {
    super.initState();

    Timer.run(() => _getData());
  }

  void _getData() async {
    var res = await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_get_notification,
      {},
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      _notifications.clear();
      for (var json in res['result']) {
        var notification = NotificationModel.fromJson(json);
        _notifications.add(notification);
      }
      _notifications.sort((b, a) => a.reg_date.compareTo(b.reg_date));
      setState(() {});
    } else {
      DialogProvider.of(context).showSnackBar(
        res['msg'],
        type: SnackBarType.ERROR,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KangaAppbar(
        title: S.current.notification,
        actions: _isSelectedMode
            ? [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => _checkAll(),
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever_outlined),
                  onPressed: () => _remove(),
                ),
              ]
            : [
                IconButton(
                  icon: Icon(Icons.select_all),
                  onPressed: () => setState(() => _isSelectedMode = true),
                ),
              ],
      ),
      body: _notifications.isEmpty? EmptyWidget(context, isProgress: false, title: 'Have not any notification',) : ListView.separated(
        padding: EdgeInsets.symmetric(vertical: offsetBase),
        itemBuilder: (context, i) {
          var notification = _notifications[i];
          return notification.getWidget(
            context,
            isShow: _isSelectedMode,
            onTap: () => _isSelectedMode
                ? setState(
                    () => notification.isSelected = !notification.isSelected)
                : _goToDetail(notification),
          );
        },
        separatorBuilder: (context, i) {
          return Divider();
        },
        itemCount: _notifications.length,
      ),
    );
  }

  void _goToDetail(NotificationModel model) async {
    if (model.type.toLowerCase() == 'live') {
      var liveID = jsonDecode(model.content)['id'];
      var res = await NetworkProvider.of(context).post(
        Constants.header_demand,
        Constants.link_live_byid,
        {
          'live_id': liveID,
        },
        isProgress: true,
      );
      if (res['ret'] == 10000) {
        var liveModel = LiveModel.fromJson(res['result']);
        NavigatorProvider.of(context)
            .pushToWidget(screen: LiveDetailScreen(liveModel: liveModel));
      }
    }
  }

  void _remove() async {
    setState(() {
      _isSelectedMode = false;
    });

    List<String> removeIDs = [];
    for (var notification in _notifications) {
      if (notification.isSelected) {
        removeIDs.add(notification.id);
      }
    }
    if (removeIDs.isNotEmpty) {
      var res = await NetworkProvider.of(context).post(
        Constants.header_demand,
        Constants.link_remove_notification,
        {
          'ids' : removeIDs.join(','),
        },
        isProgress: true,
      );
      if (res['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          'Removed notification(s) successfully',
        );
        _getData();
      }
    }
  }

  void _checkAll() {
    for (var notification in _notifications) {
      notification.isSelected = true;
    }
    setState(() {});
  }
}
