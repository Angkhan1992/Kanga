import 'package:flutter/material.dart';
import 'package:kanga/models/measure_model.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';

Container kangaBeltLogo = Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.white,
      width: 2.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(offsetBase)),
    child: Image.asset(
      'assets/images/belt.png',
      height: 150.0,
    ),
  ),
);

class KangaMeasureDialogButton extends Container {
  KangaMeasureDialogButton(
    BuildContext context, {
    required Function() action,
    Widget? child,
    String? text,
    double height = 52.0,
    double textSize = 18.0,
    bool isFull = false,
  }) : super(
          alignment: Alignment.center,
          child: InkWell(
            onTap: action,
            child: child == null
                ? Container(
                    height: height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isFull
                          ? KangaColor.kangaButtonBackColor
                          : Colors.transparent,
                      border: Border(
                        top: BorderSide(
                          color: KangaColor.kangaButtonBackColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      text!,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: isFull
                                ? Colors.white
                                : KangaColor.kangaButtonBackColor,
                            fontSize: textSize,
                          ),
                    ),
                  )
                : child,
          ),
        );
}

class KangaMeasureGridCell extends Container {
  KangaMeasureGridCell(
    BuildContext context, {
    required MeasureModel model,
  }) : super(
          margin: EdgeInsets.symmetric(horizontal: offsetXSm),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
              child: Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/logo_slb.png'),
                      ),
                    ),
                  ),
                  Container(
                    color: KangaColor.kangaButtonBackColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: offsetSm,
                    ),
                    child: Text(
                      model.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    height: 54.0,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ),
        );
}
