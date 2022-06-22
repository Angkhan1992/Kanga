import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/live_model.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/native_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/screens/profile/invite_friend_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';
import 'package:kanga/widgets/button_widget.dart';

class LiveDetailScreen extends StatefulWidget {
  final LiveModel liveModel;

  const LiveDetailScreen({
    Key? key,
    required this.liveModel,
  }) : super(key: key);

  @override
  _LiveDetailScreenState createState() => _LiveDetailScreenState();
}

class _LiveDetailScreenState extends State<LiveDetailScreen> {
  UserModel _currentUser = UserModel();
  LiveModel _live = LiveModel();

  var _isUpdated = false;

  @override
  void initState() {
    super.initState();
    _live = widget.liveModel;
    _getData();
  }

  void _getData() async {
    _currentUser = (await PrefProvider().getUser())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.asset(
                          'assets/images/temp_live_${int.parse(_live.id) % 9 + 1}.png'),
                      InkWell(
                        onTap: () => _isUpdated
                            ? Navigator.of(context).pop(_isUpdated)
                            : Navigator.of(context).pop(),
                        child: Container(
                          margin: EdgeInsets.only(
                            top: offsetSm + MediaQuery.of(context).padding.top,
                            left: offsetBase,
                          ),
                          width: 42.0,
                          height: 42.0,
                          decoration: BoxDecoration(
                            color: KangaColor().mainDarkColor(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: offsetSm,
                      vertical: offsetBase,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: offsetSm,
                            vertical: offsetXSm,
                          ),
                          decoration: BoxDecoration(
                            color: KangaColor().pinkButtonColor(0.7),
                            borderRadius: BorderRadius.circular(offsetSm),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.live_tv_sharp,
                                size: 16.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: offsetSm,
                              ),
                              Text(
                                S.current.liveStream.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: offsetBase,
                        ),
                        Text(
                          'KangaBalance ● ${_live.title}',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: offsetBase,
                        ),
                        Text(
                          _live.detail,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(
                          height: offsetBase,
                        ),
                        Text(
                          _live.meet_date.getLocalUSDateTime,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                        ),
                        Text(
                          _live.show_name,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                        ),
                        SizedBox(
                          height: offsetXMd,
                        ),
                        if (_live.is_accept)
                          Container(
                            padding: EdgeInsets.all(offsetBase),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(offsetSm),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.current.liveStreamDetail,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    KangaLiveButton(
                                      context,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: offsetSm,
                                        vertical: offsetSm,
                                      ),
                                      icon: Icon(
                                        Icons.connected_tv,
                                        color: KangaColor.kangaButtonBackColor,
                                        size: 16.0,
                                      ),
                                      title: S.current.join,
                                      fontSize: 14.0,
                                      action: () => _join(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: offsetBase,
                                ),
                                Row(
                                  children: [
                                    Text('${S.current.link} : '),
                                    Expanded(
                                      child: Text(
                                        _live.join_link,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                              color: KangaColor
                                                  .kangaButtonBackColor,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: offsetXSm,
                                ),
                                Row(
                                  children: [
                                    Text('${S.current.id} : '),
                                    Text(
                                      _live.join_id,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: offsetXSm,
                                ),
                                Row(
                                  children: [
                                    Text('${S.current.passcode} : '),
                                    Text(
                                      _live.join_pass,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: offsetXMd,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: KangaLiveButton(
                                        context,
                                        icon: Icon(
                                          Icons.group_add,
                                          color:
                                              KangaColor.kangaButtonBackColor,
                                        ),
                                        title: S.current.invite,
                                        action: () => _invite(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: offsetBase,
                                    ),
                                    Expanded(
                                      child: KangaLiveButton(
                                        context,
                                        icon: Icon(
                                          Icons.perm_contact_calendar_outlined,
                                          color:
                                              KangaColor.kangaButtonBackColor,
                                        ),
                                        title: S.current.add,
                                        action: () => _addCalendar(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 60.0,
            color: KangaColor().bubbleColor(1),
            child: _getBottom(),
          ),
        ],
      ),
    );
  }

  Widget _getBottom() {
    return Row(
      children: [
        Expanded(
          child: _currentUser == null
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 2.0,
                        color: KangaColor.kangaButtonBackColor,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _currentUser.isExpired()
                          ? S.current.overExpiredDate
                          : S.current.premiumMember,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                    ),
                  ),
                ),
        ),
        Expanded(
          child: _live.is_accept
              ? InkWell(
                  onTap: () => _cancel(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: KangaColor().mainDarkColor(1),
                      border: Border(
                        left: BorderSide(
                          width: 2.0,
                          color: KangaColor.kangaButtonBackColor,
                        ),
                        top: BorderSide(
                          width: 2.0,
                          color: KangaColor.kangaButtonBackColor,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      S.current.cancel.toUpperCase(),
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: KangaColor.kangaButtonBackColor,
                          ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    if (_currentUser.isExpired()) {
                      DialogProvider.of(context).showSnackBar(
                        S.current.expiredSubscription,
                        type: SnackBarType.ERROR,
                      );
                      return;
                    }
                    _accept();
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: KangaColor.kangaButtonBackColor,
                    alignment: Alignment.center,
                    child: Text(
                      S.current.reverse.toUpperCase(),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  void _accept() async {
    var res = await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_accept_live,
      {
        'live_id': _live.id,
      },
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      setState(() {
        _live.is_accept = true;
      });
    }
  }

  void _cancel() async {
    var res = await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_cancel_live,
      {
        'live_id': _live.id,
      },
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      setState(() {
        _live.is_accept = false;
      });
    }
  }

  void _join() async {
    if (!await launch(_live.join_link)) {
      DialogProvider.of(context).showSnackBar(
        S.current.notOpenLink,
        type: SnackBarType.ERROR,
      );
    }
    // NavigatorProvider.of(context).pushToWidget(
    //     screen: LiveZoomScreen(
    //   title: _live.title,
    //   url: _live.join_link,
    // ));
  }

  void _invite() async {
    NavigatorProvider.of(context).pushToWidget(
        screen: InviteFriendScreen(
      liveModel: widget.liveModel,
    ));
  }

  void _addCalendar() async {
    var result = await NativeProvider.addCalendar(
      title: 'KangaBalance - ${_live.show_name}',
      desc: _live.detail,
      dateTime: _live.meet_date.getLocalDateTime,
    );
    if (result == 'Success') {
      DialogProvider.of(context).showSnackBar(S.current.addCalendarSuccess);
    } else {
      DialogProvider.of(context).showSnackBar(
        result,
        type: SnackBarType.ERROR,
      );
    }
  }
}
