import 'package:flutter/material.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';

class NavigatorProvider {
  final BuildContext? context;

  NavigatorProvider(this.context);

  factory NavigatorProvider.of(BuildContext? context) {
    return NavigatorProvider(context);
  }

  void pushToWidget({
    required Widget screen,
    bool replace = false,
    Function(dynamic)? pop,
  }) {
    if (replace) {
      Navigator.of(context!)
          .pushReplacement(
              MaterialPageRoute<Object>(builder: (context) => screen))
          .then((value) => {if (pop != null) pop(value)});
    } else {
      Navigator.of(context!)
          .push(MaterialPageRoute<Object>(builder: (context) => screen))
          .then((value) => {if (pop != null) pop(value)});
    }
  }

  void showCustomBottomModal(Widget child) {
    showModalBottomSheet(
      context: context!,
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(offsetBase),
          topLeft: Radius.circular(offsetBase),
        ),
      ),
      backgroundColor: KangaColor().bubbleColor(1),
      builder: (_) => Container(
        padding: EdgeInsets.all(offsetBase),
        child: child,
      ),
    );
  }
}
