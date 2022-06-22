import 'package:flutter/material.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';

class KangaButton extends StatelessWidget {
  final Color btnColor;
  final Color textColor;
  final double borderWidth;
  final String btnText;
  final Function()? onPressed;
  final Widget? child;
  final Color? focusColor;
  final Color? splashColor;
  final Color? hoverColor;
  final double height;
  final EdgeInsets padding;

  const KangaButton({
    Key? key,
    this.height = dimenButtonHeight,
    this.padding = EdgeInsets.zero,
    this.btnColor = const Color(0xFFFA8072),
    this.borderWidth = 0.0,
    this.btnText = '',
    this.textColor = Colors.white,
    required this.onPressed,
    this.child,
    this.focusColor,
    this.splashColor,
    this.hoverColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(offsetSm),
        border: Border.all(width: borderWidth, color: Colors.white),
      ),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(offsetSm),
        child: RaisedButton(
          focusColor: focusColor,
          splashColor: splashColor,
          hoverColor: hoverColor,
          elevation: 0.0,
          color: borderWidth > 0 ? Colors.transparent : btnColor,
          onPressed: onPressed,
          child: child == null
              ? Text(
                  btnText,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: borderWidth > 0 ? Colors.white : textColor,
                        fontSize: 18.0,
                      ),
                )
              : child,
        ),
      ),
    );
  }
}

class SocialButton extends Container {
  SocialButton({
    Key? key,
    Widget? icon,
    Function()? action,
  }) : super(
          width: dimenButtonHeight,
          height: dimenButtonHeight,
          padding: EdgeInsets.all(offsetSm),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(dimenButtonHeight / 2.0)),
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          child: InkWell(
            child: icon,
            onTap: action,
          ),
        );
}

class ClassDetailButton extends Container {
  ClassDetailButton(
    BuildContext context, {
    bool isFav = true,
    bool isAlreadyFav = false,
  }) : super(
          width: double.infinity,
          height: 52.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: isAlreadyFav ? KangaColor().pinkMatColor : Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFav
                      ? isAlreadyFav
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined
                      : Icons.share,
                  color:
                      isAlreadyFav ? KangaColor().pinkMatColor : Colors.white,
                  size: 20.0,
                ),
                SizedBox(
                  width: offsetSm,
                ),
                Text(
                  isFav
                      ? isAlreadyFav
                          ? S.current.favorite
                          : S.current.addToFavorite
                      : S.current.share,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: isAlreadyFav
                          ? KangaColor().pinkMatColor
                          : Colors.white,
                      fontSize: 12.0),
                ),
              ],
            ),
          ),
        );
}

class ClassFavButton extends Column {
  ClassFavButton(
    BuildContext context, {
    bool isRating = true,
    String value1 = '0.0',
    String value2 = '0',
  }) : super(
          crossAxisAlignment:
              isRating ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isRating ? '$value1%' : '$value1',
                  style: Theme.of(context).textTheme.headline3,
                ),
                SizedBox(
                  width: offsetXSm,
                ),
                isRating
                    ? Icon(
                        Icons.star_rate,
                        size: 16.0,
                      )
                    : Text(
                        '/ 10',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 10.0,
                              color: Colors.white,
                            ),
                      ),
              ],
            ),
            SizedBox(
              height: offsetSm,
            ),
            isRating
                ? Text(
                    '$value2 ${S.current.ratings}',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 12.0),
                  )
                : Text(
                    S.current.difficulty,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 12.0),
                  ),
          ],
        );
}

class KangaLiveButton extends Container {
  KangaLiveButton(
    BuildContext context, {
    required Widget icon,
    required String title,
    required Function() action,
    EdgeInsets padding = const EdgeInsets.symmetric(
      vertical: offsetSm,
    ),
    double fontSize = 18.0,
  }) : super(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(offsetSm),
            border: Border.all(
              color: KangaColor.kangaButtonBackColor,
              width: 2.0,
            ),
          ),
          alignment: Alignment.center,
          child: InkWell(
            onTap: action,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                SizedBox(
                  width: offsetSm,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: KangaColor.kangaButtonBackColor,
                        fontSize: fontSize,
                      ),
                ),
              ],
            ),
          ),
        );
}
