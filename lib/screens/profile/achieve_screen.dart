import 'package:flutter/material.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/common_widget.dart';

class AchieveScreen extends StatefulWidget {
  final int classIndex;
  final int monthIndex;

  const AchieveScreen({
    Key? key,
    this.classIndex = 0,
    this.monthIndex = 0,
  }) : super(key: key);

  @override
  _AchieveScreenState createState() => _AchieveScreenState();
}

class _AchieveScreenState extends State<AchieveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KangaAppbar(
        title: S.current.achievements,
      ),
      body: Column(
        children: [
          SizedBox(
            height: offsetBase,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: offsetBase,
              // horizontal: offsetSm,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    for (var i = 0; i < 3; i++)
                      Expanded(
                        child: AchieveClass(
                          context,
                          achieve: kAchievements[i],
                          isActive: widget.classIndex == i,
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: offsetBase,
                ),
                Row(
                  children: [
                    for (var i = 3; i < 6; i++)
                      Expanded(
                        child: AchieveClass(
                          context,
                          achieve: kAchievements[i],
                          isActive: widget.classIndex == i,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: offsetBase,
              // horizontal: offsetSm,
            ),
            child: Row(
              children: [
                for (var i = 0; i < 3; i++)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.monthIndex == i
                                ? KangaColor.kangaButtonBackColor
                                : Colors.transparent,
                            border: Border.all(
                              color: widget.monthIndex == i
                                  ? Colors.white
                                  : KangaColor.kangaButtonBackColor,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: widget.monthIndex == i
                                      ? Colors.white
                                      : KangaColor.kangaButtonBackColor,
                                  size: 28.0,
                                ),
                                Text(
                                  '${i + 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                        color: widget.monthIndex == i
                                            ? Colors.white
                                            : KangaColor.kangaButtonBackColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: offsetBase,
                        ),
                        Text(
                          '${i + 1} - week\nstreak',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: widget.monthIndex == i
                                    ? Colors.white
                                    : KangaColor.kangaTextGrayColor,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
