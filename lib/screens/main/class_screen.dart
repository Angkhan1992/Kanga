import 'dart:async';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/screens/class/live_screen.dart';
import 'package:kanga/screens/class/notification_screen.dart';
import 'package:kanga/screens/class/ondemand_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({Key? key}) : super(key: key);

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _unRead = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    Timer.run(() => _getData());
  }

  void _getData() async {
    var res = await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_unread_notification,
      {},
    );
    if (res['ret'] == 10000) {
      setState(() {
        _unRead = res['result'];
      });
    } else {
      DialogProvider.of(context).showSnackBar(
        res['msg'],
        type: SnackBarType.ERROR,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          S.current.classes,
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_none,
                ),
                if (_unRead > 0)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 2.0,
                        ),
                        width: offsetXSm,
                        height: offsetXSm,
                        decoration: BoxDecoration(
                          color: KangaColor.kangaButtonBackColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => NavigatorProvider.of(context).pushToWidget(
                screen: NotificationScreen(),
                pop: (value) {
                  setState(() {
                    _unRead = 0;
                  });
                }),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 80),
              child: TabBarView(
                controller: _tabController,
                children: [
                  OnDemandScreen(),
                  LiveScreen(),
                ],
                dragStartBehavior: DragStartBehavior.down,
              )),
          Container(
            height: 54,
            margin: EdgeInsets.symmetric(
                vertical: offsetBase, horizontal: offsetSm),
            decoration: BoxDecoration(
              color: KangaColor().textGreyColor(0.3),
              borderRadius: BorderRadius.circular(60),
            ),
            child: TabBar(
              indicatorPadding: EdgeInsets.all(0),
              controller: _tabController,
              unselectedLabelColor: KangaColor().textGreyColor(1),
              labelStyle: Theme.of(context).textTheme.bodyText1,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BubbleTabIndicator(
                indicatorHeight: 44.0,
                indicatorColor: KangaColor().pinkButtonColor(1),
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              tabs: [
                Tab(
                  text: S.current.onDemand,
                ),
                Tab(
                  text: S.current.live,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
