import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/main.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/notification_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/providers/socket_provider.dart';
import 'package:kanga/screens/main/class_screen.dart';
import 'package:kanga/screens/main/coach_screen.dart';
import 'package:kanga/screens/main/measure_screen.dart';
import 'package:kanga/screens/main/more_screen.dart';
import 'package:kanga/screens/main/profile_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/bottom_bar.dart';
import 'package:kanga/widgets/common_widget.dart';
import 'package:kanga/widgets/measure_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  var _selectedIndex = 1;

  var bottomItemImages = [
    'assets/icons/ic_star.png',
    'assets/icons/ic_play.png',
    'assets/icons/ic_chat.png',
    'assets/icons/ic_profile.png',
    'assets/icons/ic_more_h.png',
  ];

  var _screens = [];
  var _currentUser = UserModel();

  @override
  void initState() {
    super.initState();

    NotificationProvider.of(context).init();
    WidgetsBinding.instance!.addObserver(this);

    Timer.run(() async {
      _currentUser = (await PrefProvider().getUser())!;

      socketService = injector!.get<SocketProvider>();
      socketService!.createSocketConnection(_currentUser);

      _screens = [
        MeasureScreen(
          onCancelEvent: () {
            Navigator.of(context).pop();
            print('_measureCancel');
            setState(() {
              _selectedIndex = 1;
            });
          },
        ),
        ClassScreen(),
        CoachScreen(),
        ProfileScreen(),
        MoreScreen(),
      ];
      setState(() {});
    });

    _getAskMeasure();
  }

  void _getAskMeasure() async {
    var askDate = await PrefProvider().getAskMeasure();
    var todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (askDate != todayDate) {
      _showAskDialog();
      await PrefProvider().setAskMeasure(todayDate);
    }
  }

  void _showAskDialog() {
    var _dialogController = TextEditingController();
    var _selectedValue = '';
    DialogProvider.of(context).kangaBubbleDialog(
      child: DailyDialogWidget(
        controller: _dialogController,
        selectedIndex: -1,
        onSelect: (value) => _selectedValue = value,
      ),
      actions: [
        KangaMeasureDialogButton(
          context,
          action: () async {
            Navigator.of(context).pop();
            if (_selectedValue.isNotEmpty) {
              var res = await NetworkProvider.of(context).post(
                Constants.header_profile,
                Constants.link_add_feel,
                {
                  'feel': _selectedValue,
                },
                isProgress: true,
              );
              if (res['ret'] == 10000) {
                DialogProvider.of(context)
                    .showSnackBar(S.current.successSubmit);
              } else {
                DialogProvider.of(context)
                    .showSnackBar(res['msg'], type: SnackBarType.ERROR);
              }
            }
          },
          text: S.current.submit,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: _screens.isEmpty ? Container() : _screens[_selectedIndex],
      ),
    );
  }

  // bottom navigation bar
  Widget _buildBottomNavigationBar() {
    var bottomBarTitles = [
      S.current.measure,
      S.current.classes,
      S.current.coach,
      S.current.profile,
      S.current.more,
    ];
    return KangaBottomBar(
      currentIndex: _selectedIndex,
      backgroundColor: KangaColor().textGreyColor(0.2),
      onChange: (index) async {
        setState(() {
          _selectedIndex = index;
        });
      },
      children: [
        for (var i = 0; i < bottomItemImages.length; i++)
          KangaBottomNavigationItem(
            icon: Image.asset(
              bottomItemImages[i],
              color: _selectedIndex == i
                  ? Colors.white
                  : KangaColor().textGreyColor(1),
              height: 22,
              width: 22,
            ),
            label: Text(
              bottomBarTitles[i],
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: _selectedIndex == i
                        ? Colors.white
                        : KangaColor().textGreyColor(1),
                    fontSize: 12.0,
                  ),
              maxLines: 1,
            ),
          ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("-----\napp in resumed-------");
        _enterApp();
        break;
      case AppLifecycleState.inactive:
        print("-----\napp in inactive-----");
        _leaveApp();
        break;
      case AppLifecycleState.paused:
        print("-----\napp in paused-----");
        _pauseApp();
        break;
      case AppLifecycleState.detached:
        print("-----\napp in detached-----");
        break;
    }
  }

  void _enterApp() async {
    initBadge();
  }

  void _leaveApp() async {
    socketService!.leaveRoom(_currentUser);
  }

  void _pauseApp() async {
    socketService!.leaveRoom(_currentUser);
  }
}
