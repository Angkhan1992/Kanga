import 'package:flutter/material.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';

class KangaBottomBar extends StatelessWidget {
  final Color backgroundColor;
  final Color itemColor;
  final List<KangaBottomNavigationItem>? children;
  final Function(int)? onChange;
  final int currentIndex;

  const KangaBottomBar({
    Key? key,
    this.backgroundColor = const Color(0xFFFA8072),
    this.itemColor = Colors.black,
    this.children,
    this.onChange,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: offsetXSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children!.map((item) {
              Widget icon = item.icon;
              Widget label = item.label;
              int index = children!.indexOf(item);
              return GestureDetector(
                onTap: () => onChange!(index),
                child: Container(
                  width: 64,
                  height: 60,
                  padding: EdgeInsets.only(
                      left: offsetXSm, right: offsetXSm, top: offsetXSm),
                  margin: EdgeInsets.only(top: offsetXSm, bottom: offsetXSm),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: currentIndex == index
                          ? KangaColor().pinkButtonColor(1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(offsetSm)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      icon,
                      SizedBox(
                        height: offsetXSm,
                      ),
                      label
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class KangaBottomNavigationItem {
  final Widget icon;
  final Widget label;
  final Color? color;

  KangaBottomNavigationItem(
      {required this.icon, required this.label, this.color});
}
