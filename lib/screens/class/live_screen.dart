import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/live_model.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/screens/class/live_detail_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({Key? key}) : super(key: key);

  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  List<LiveModel> _lives = [];

  var _scrollController = ScrollController();
  var _isExpanded = true;

  ValueNotifier<List<LiveModel>>? _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));

    Timer.run(() => _getData());
  }

  List<LiveModel> _getEventsForDay(DateTime day) {
    List<LiveModel> result = [];
    for (var live in _lives) {
      if (live.meet_date.getLocalDateTime.split(' ')[0] ==
          DateFormat('yyyy-MM-dd').format(day)) {
        result.add(live);
      }
    }
    return result;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents!.value = _getEventsForDay(selectedDay);
    }
  }

  void _getData() async {
    var res = await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_get_live,
      {},
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      _lives.clear();
      for (var json in res['result']) {
        var live = LiveModel.fromJson(json);
        _lives.add(live);
      }
      _lives.sort((a, b) => a.meet_date.compareTo(b.meet_date));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var normalTextStyle = Theme.of(context).textTheme.headline4!.copyWith(
          color: KangaColor.kangaTextGrayColor,
        );
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            TableCalendar<LiveModel>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              calendarFormat:
                  _isExpanded ? CalendarFormat.month : CalendarFormat.week,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                defaultTextStyle: normalTextStyle,
                outsideTextStyle: normalTextStyle,
                weekendTextStyle: normalTextStyle,
                disabledTextStyle:
                    Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.white.withOpacity(0.3),
                        ),
                selectedDecoration: BoxDecoration(
                  color: KangaColor.kangaButtonBackColor,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(
                  color: KangaColor.kangaButtonBackColor,
                ),
                weekdayStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              onFormatChanged: (value) {},
              availableCalendarFormats: {
                CalendarFormat.month: '',
                CalendarFormat.twoWeeks: '',
                CalendarFormat.week: '',
              },
            ),
            const SizedBox(height: offsetSm),
            Container(
              height: 52,
              margin: EdgeInsets.symmetric(vertical: offsetSm),
              padding: EdgeInsets.symmetric(horizontal: offsetXMd),
              decoration: BoxDecoration(
                  color: KangaColor().bubbleConnerColor(1),
                  border: Border.symmetric(
                      horizontal: BorderSide(
                    color: KangaColor.kangaTextGrayColor,
                    width: 0.5,
                  ))),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    _selectedDay.getDateMDY,
                    style: Theme.of(context).textTheme.headline4,
                  )),
                  InkWell(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<List<LiveModel>>(
              valueListenable: _selectedEvents!,
              builder: (context, value, _) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: value.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var live = value[index];
                    var time = live.meet_date.getChatTime;
                    return InkWell(
                      onTap: () => NavigatorProvider.of(context).pushToWidget(
                        screen: LiveDetailScreen(
                          liveModel: live,
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(bottom: offsetXSm),
                        padding: EdgeInsets.symmetric(
                          vertical: offsetSm,
                          horizontal: offsetBase,
                        ),
                        color: live.is_accept
                            ? KangaColor().textGreyColor(0.15)
                            : Colors.transparent,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    live.title,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Text(
                                    live.show_name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          fontSize: 12.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: offsetBase,
                            ),
                            Column(
                              children: [
                                Text(
                                  time,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  padding: live.is_accept
                                      ? EdgeInsets.zero
                                      : EdgeInsets.symmetric(
                                          horizontal: offsetBase,
                                          vertical: offsetXSm,
                                        ),
                                  decoration: BoxDecoration(
                                    color: live.is_accept
                                        ? Colors.transparent
                                        : KangaColor.kangaButtonBackColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(offsetBase)),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if (!live.is_accept) _accept(live);
                                    },
                                    child: Text(
                                      live.is_accept
                                          ? S.current.joined
                                          : S.current.join,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            color: live.is_accept
                                                ? KangaColor
                                                    .kangaButtonBackColor
                                                : Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _accept(LiveModel live) async {
    var res = await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_accept_live,
      {
        'live_id': live.id,
      },
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      setState(() {
        live.is_accept = true;
      });
    }
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime.now();
final kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);
