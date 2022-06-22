import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';

class KangaAppbar extends AppBar {
  KangaAppbar({
    String? title,
    List<Widget>? actions,
  }) : super(
          title: Text(
            title!,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: KangaColor().secondDarkColor(1)),
          ),
          actions: actions,
        );
}

class KangaProfileValue extends Expanded {
  KangaProfileValue({
    BuildContext? context,
    String? value,
    String? title,
  }) : super(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: offsetXSm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
              border: Border.all(color: Colors.white, width: 2.0),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value!,
                    style: Theme.of(context!).textTheme.headline3,
                  ),
                  Text(
                    title!,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
        );
}

class KangaProfileClass extends Column {
  KangaProfileClass({
    BuildContext? context,
    String? title,
    int? total,
    int? value,
  }) : super(
          children: [
            total == value
                ? Container(
                    margin: EdgeInsets.only(top: offsetXMd),
                    height: offsetXMd,
                    decoration: BoxDecoration(
                      color: KangaColor().pinkButtonColor(1),
                      borderRadius:
                          BorderRadius.all(Radius.circular(offsetXMd / 2.0)),
                    ),
                  )
                : (value == 0 || total == 0)
                    ? Container(
                        margin: EdgeInsets.only(top: offsetXMd),
                        height: offsetXMd,
                        decoration: BoxDecoration(
                          color: KangaColor().textGreyColor(0.3),
                          borderRadius: BorderRadius.all(
                              Radius.circular(offsetXMd / 2.0)),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: offsetXMd),
                        height: offsetXMd,
                        decoration: BoxDecoration(
                          color: KangaColor().textGreyColor(0.3),
                          borderRadius: BorderRadius.all(
                              Radius.circular(offsetXMd / 2.0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: KangaColor().pinkButtonColor(1),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(offsetXMd / 2.0)),
                                ),
                              ),
                              flex: (value! == 0 ? 1 : value),
                            ),
                            Spacer(
                              flex: ((total! - value) < 1) ? 1 : (total - value),
                            ),
                          ],
                        ),
                      ),
            SizedBox(
              height: offsetXSm,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: offsetXMd / 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$value / $total',
                    style: Theme.of(context!).textTheme.headline4,
                  ),
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
          ],
        );
}

class KangaCircleIndicator extends Container {
  KangaCircleIndicator({
    required BuildContext context,
    double indicatorHeight = 250.0,
    double fontSize = 28.0,
    double strokeWidth = 8.0,
    required int valueT,
    required int totalSecond,
  }) : super(
          height: indicatorHeight,
          width: indicatorHeight,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Container(
                height: indicatorHeight,
                width: indicatorHeight,
                child: CircularProgressIndicator(
                  value: 0.0,
                  strokeWidth: strokeWidth / 4,
                  backgroundColor: KangaColor().bubbleColor(1),
                  valueColor: AlwaysStoppedAnimation(
                    KangaColor().pinkButtonColor(1),
                  ),
                ),
              ),
              Container(
                height: indicatorHeight,
                width: indicatorHeight,
                child: CircularProgressIndicator(
                  value: valueT / totalSecond,
                  strokeWidth: strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(
                    KangaColor().pinkButtonColor(1),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      valueT == 0
                          ? S.current.start.toUpperCase()
                          : (valueT == totalSecond && valueT != 10)
                              ? S.current.complete.toUpperCase()
                              : '$valueT',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: KangaColor().pinkButtonColor(1),
                            fontSize: fontSize,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
}

class SingleLegBottomWidget extends Container {
  SingleLegBottomWidget({
    required BuildContext context,
    required String title,
    bool isCompleted = false,
    bool isHalf = true,
    int repeat = 0,
  }) : super(
          height: 240,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: isHalf ? 24.0 : 36.0,
                    color: KangaColor().pinkButtonColor(1)),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: isHalf ? 30.0 : 90.0,
                  right: isHalf ? 30.0 : 90.0,
                  top: 36.0,
                  bottom: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 20.0, color: Colors.white),
                    ),
                    Text(
                      '2',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 20.0, color: Colors.white),
                    ),
                    Text(
                      '3',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 20.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
                child: Container(
                  width: isHalf ? 150.0 : 250.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF707070)),
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    color: Color(0x86AAB2BA),
                  ),
                  child: Stack(
                    children: [
                      repeat == 2
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14.0)),
                                gradient: gradientSingleLeg,
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  flex: repeat + 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0)),
                                      gradient: gradientSingleLeg,
                                    ),
                                  ),
                                ),
                                Spacer(
                                  flex: 2 - repeat,
                                ),
                              ],
                            ),
                      if (isCompleted)
                        Center(
                          child: Text('COMPLETED',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      fontSize: isHalf ? 16.0 : 20.0,
                                      color: Colors.white)),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
}

LinearGradient gradientSingleLeg = LinearGradient(
  colors: [
    const Color(0xFFFA8072),
    const Color(0xFFA15249),
    const Color(0xFF7D4039),
  ],
  begin: const FractionalOffset(1.0, 0.5),
  end: const FractionalOffset(0.0, 0.5),
  stops: [0.0, 0.8, 1.0],
);

class EmptyWidget extends Container {
  EmptyWidget(
    BuildContext context, {
    String? title,
    String? detail,
    bool isProgress = true,
  }) : super(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 120.0,
                ),
                if (isProgress)
                  Padding(
                    padding: const EdgeInsets.all(offsetBase),
                    child: CupertinoActivityIndicator(
                      radius: 24.0,
                    ),
                  ),
                SizedBox(
                  height: offsetBase,
                ),
                Text(
                  title == null ? 'Connecting ...' : title,
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  height: offsetSm,
                ),
                if (detail != null)
                  Text(
                    detail,
                    style: Theme.of(context).textTheme.headline4,
                  ),
              ],
            ),
          ),
        );
}

class DailyDialogWidget extends StatefulWidget {
  final TextEditingController controller;
  final int selectedIndex;
  final Function(String) onSelect;

  const DailyDialogWidget({
    Key? key,
    required this.controller,
    required this.selectedIndex,
    required this.onSelect,
  }) : super(key: key);

  @override
  _DailyDialogWidgetState createState() => _DailyDialogWidgetState();
}

class _DailyDialogWidgetState extends State<DailyDialogWidget> {
  var _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    var icons = [
      {
        'title': S.current.depressed,
        'image': 'assets/icons/ic_depressed',
      },
      {
        'title': S.current.sad,
        'image': 'assets/icons/ic_sad.png',
      },
      {
        'title': S.current.happy,
        'image': 'assets/icons/ic_happy.png',
      },
      {
        'title': S.current.veryHappy,
        'image': 'assets/icons/ic_very_happy.png',
      },
    ];
    return Column(
      children: [
        Text(
          '${S.current.hello}!',
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          S.current.tellUsHow,
          style: Theme.of(context).textTheme.caption,
        ),
        Divider(),
        Text(
          S.current.howFeelToday,
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: offsetBase,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var icon in icons)
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = icons.indexOf(icon);
                  });
                  widget.onSelect(icon['title']!);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: icons.indexOf(icon) == _selectedIndex
                        ? KangaColor.kangaButtonBackColor.withOpacity(0.5)
                        : Colors.transparent,
                    border: Border.all(
                      color: icons.indexOf(icon) == _selectedIndex
                          ? Colors.white60
                          : Colors.transparent,
                      width: icons.indexOf(icon) == _selectedIndex ? 1.0 : 0.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(offsetSm),
                        child: Image.asset(
                          icon['image']!,
                          width: 52,
                        ),
                      ),
                      Text(
                        icon['title']!,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.white,
                              fontSize: 11.0,
                            ),
                      ),
                      SizedBox(
                        height: offsetSm,
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          S.current.anyOtherComments,
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: offsetBase,
        ),
        // KangaTextField(
        //   isMemo: true,
        //   controller: widget.controller,
        //   hintText: S.current.anyOtherHint,
        // ),
        Text(
          'For other comment, you can use the feedback feature of KangaBalance. You can see that on \'Setting\'->\'Feedback\'.',
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class AchieveClass extends Column {
  AchieveClass(
    BuildContext context, {
    dynamic achieve,
    bool isActive = false,
  }) : super(
          children: [
            Container(
              width: 75.0,
              height: 75.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? KangaColor.kangaButtonBackColor
                      : Colors.transparent,
                  border: Border.all(
                    color: isActive
                        ? Colors.white
                        : KangaColor.kangaButtonBackColor,
                    width: 2.0,
                  )),
              child: Center(
                child: Text(
                  '${achieve['value']}',
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 42.0,
                        foreground: Paint()
                          ..color = isActive
                              ? Colors.white
                              : KangaColor.kangaButtonBackColor
                          ..strokeWidth = 2.0
                          ..style = PaintingStyle.stroke,
                      ),
                ),
              ),
            ),
            SizedBox(
              height: offsetSm,
            ),
            Text(
              '${achieve['title']}',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color:
                        isActive ? Colors.white : KangaColor.kangaTextGrayColor,
                  ),
            ),
          ],
        );
}
