import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';

class DialogProvider {
  final BuildContext? context;

  DialogProvider(this.context);

  static DialogProvider of(BuildContext? context) {
    return DialogProvider(context);
  }

  Future<dynamic> kangaBubbleDialog({
    required Widget child,
    required List<Widget> actions,
    String iconUrl = 'assets/images/logo.png',
    double iconBorderWidth = 4.0,
    EdgeInsets childPadding = const EdgeInsets.all(offsetXMd),
    Color background = KangaColor.kangaDialogBackColor,
    double borderRadius = offsetBase,
    Color borderColor = KangaColor.kangaButtonBackColor,
    double borderWidth = 2.0,
    double bubbleSize = 80.0,
    double sigmaSize = 5.0,
    bool isCancelable = false,
  }) async {
    return await showDialog<dynamic>(
      context: context!,
      builder: (context) => GestureDetector(
        onTap: () {
          if (isCancelable) Navigator.of(context).pop();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigmaSize, sigmaY: sigmaSize),
            child: Padding(
              padding: const EdgeInsets.all(offsetBase),
              child: Center(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: bubbleSize / 2),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius:
                                BorderRadius.all(Radius.circular(borderRadius)),
                            border: Border.all(
                              color: borderColor,
                              width: borderWidth,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: offsetLg,
                              ),
                              Padding(
                                padding: childPadding,
                                child: child,
                              ),
                              Row(
                                children: [
                                  for (var action in actions)
                                    Expanded(child: action),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          width: bubbleSize,
                          height: bubbleSize,
                          decoration: BoxDecoration(
                            color: background,
                            border: Border.all(
                                color: borderColor, width: iconBorderWidth),
                            borderRadius:
                                BorderRadius.all(Radius.circular(bubbleSize)),
                          ),
                          child: Center(
                            child: Image.asset(
                              iconUrl,
                              width: bubbleSize * 0.6,
                              height: bubbleSize * 0.6,
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(
    String content, {
    SnackBarType type = SnackBarType.SUCCESS,
  }) async {
    var backgroundColor = Colors.white;
    var icons = Icons.check_circle_outline;
    switch (type) {
      case SnackBarType.SUCCESS:
        backgroundColor = Colors.green;
        icons = Icons.check_circle_outline;
        break;
      case SnackBarType.WARING:
        backgroundColor = Colors.orange;
        icons = Icons.warning_amber_outlined;
        break;
      case SnackBarType.INFO:
        backgroundColor = Colors.blueGrey;
        icons = Icons.info_outline;
        break;
      case SnackBarType.ERROR:
        backgroundColor = Colors.red;
        icons = Icons.cancel_outlined;
        break;
    }

    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Card(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(offsetSm)),
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.all(offsetBase),
            child: Row(
              children: [
                Icon(
                  icons,
                  color: Colors.white,
                  size: 18.0,
                ),
                SizedBox(
                  width: offsetSm,
                ),
                Expanded(
                  child: Text(
                    content,
                    style: Theme.of(context!).textTheme.caption!.copyWith(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: Duration(milliseconds: 2000),
      ),
    );
  }
}

enum SnackBarType { SUCCESS, WARING, INFO, ERROR }
