import 'package:flutter/material.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/compare_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/extensions.dart';

Widget singleLegDialogWidget(
  BuildContext context, {
  required UserModel user,
  required List<double> data,
}) {
  print('[DATA] ===== $data');
  var left = 0.0;
  var right = 0.0;
  for (var i = 0; i < data.length; i++) {
    var value = data[i];
    if (i < 3) {
      right = right + value;
    } else {
      left = left + value;
    }
  }
  right = right / 3.0;
  left = left / 3.0;
  var avgValue = (right + left) / 2.0;

  var result = CompareProvider.of(context).slb(user, avgValue);
  TextStyle alertText = Theme.of(context).textTheme.headline5!;

  return Container(
    child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 0.5,
          color: KangaColor().textGreyColor(1),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(offsetBase),
                decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(
                    width: 0.25,
                    color: KangaColor().textGreyColor(1),
                  )),
                ),
                child: Column(
                  children: [
                    Text(
                      S.current.right,
                      style: alertText.copyWith(fontSize: 22.0),
                    ),
                    SizedBox(
                      height: offsetBase,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$right'.get2FormattedValue,
                          style: alertText.copyWith(fontSize: 36.0),
                        ),
                        SizedBox(
                          width: offsetXSm,
                        ),
                        Text(
                          S.current.sec,
                          style: alertText.copyWith(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                    width: 0.25,
                    color: KangaColor().textGreyColor(1),
                  )),
                ),
                padding: EdgeInsets.all(offsetBase),
                child: Column(
                  children: [
                    Text(
                      S.current.left,
                      style: alertText.copyWith(fontSize: 22.0),
                    ),
                    SizedBox(
                      height: offsetBase,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$left'.get2FormattedValue,
                          style: alertText.copyWith(fontSize: 36.0),
                        ),
                        SizedBox(
                          width: offsetXSm,
                        ),
                        Text(
                          S.current.sec,
                          style: alertText.copyWith(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 0.5,
          color: KangaColor().textGreyColor(1),
        ),
        SizedBox(
          height: offsetSm,
        ),
        Text(
          S.current.avgOfThreeTrials,
          style: alertText.copyWith(fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          S.current.compareToData,
          style: alertText,
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          S.current.youAreAverage,
          style: alertText.copyWith(fontSize: 20.0),
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          result,
          style: alertText.copyWith(
            fontSize: 22.0,
            color: KangaColor().pinkButtonColor(1),
          ),
        ),
        SizedBox(
          height: offsetXMd,
        ),
      ],
    ),
  );
}

Widget sitStandDialogWidget(
  BuildContext context, {
  required UserModel user,
  required int data,
}) {
  var result = CompareProvider.of(context).sts(user, data);
  TextStyle alertText = Theme.of(context).textTheme.headline5!;
  return Container(
    child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 0.5,
          color: KangaColor().textGreyColor(1),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: offsetBase),
          alignment: Alignment.center,
          child: Text(
            '$data',
            style: alertText.copyWith(fontSize: 36.0),
          ),
        ),
        Container(
          width: double.infinity,
          height: 0.5,
          color: KangaColor().textGreyColor(1),
        ),
        SizedBox(
          height: offsetSm,
        ),
        Text(
          S.current.ofSitToStand30,
          style: alertText.copyWith(fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          S.current.compareToData,
          style: alertText,
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          S.current.youAreAverage,
          style: alertText.copyWith(fontSize: 20.0),
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          result,
          style: alertText.copyWith(
            fontSize: 22.0,
            color: KangaColor().pinkButtonColor(1),
          ),
        ),
        SizedBox(
          height: offsetXMd,
        ),
      ],
    ),
  );
}

Widget tenMeterDialogWidget(
  BuildContext context, {
  required UserModel user,
  required double velocity,
  required double time,
  required double distance,
}) {
  var result = CompareProvider.of(context).tmw(user, velocity);
  TextStyle alertText = Theme.of(context).textTheme.caption!.copyWith(
        color: Colors.white,
      );
  return Container(
    child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 0.5,
          color: KangaColor().textGreyColor(1),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: offsetBase),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$velocity'.get2FormattedValue,
                style: alertText.copyWith(fontSize: 36.0),
              ),
              SizedBox(
                width: offsetXSm,
              ),
              Text(
                'm/s',
                style: alertText.copyWith(fontSize: 14.0),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 0.5,
          color: KangaColor().textGreyColor(1),
        ),
        SizedBox(
          height: offsetSm,
        ),
        Text(
          'Took ${"$time".get2FormattedValue} seconds to complete ${"$distance".get2FormattedValue} meters',
          style: alertText.copyWith(fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          S.current.compareToData,
          style: alertText,
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          S.current.youAreAverage,
          style: alertText.copyWith(fontSize: 20.0),
        ),
        SizedBox(
          height: offsetBase,
        ),
        Text(
          result,
          style: alertText.copyWith(
            fontSize: 22.0,
            color: KangaColor().pinkButtonColor(1),
          ),
        ),
        SizedBox(
          height: offsetXMd,
        ),
      ],
    ),
  );
}

class ViewScoreWidget extends Container {
  ViewScoreWidget({
    required BuildContext context,
    required Widget body,
    required String title,
    required Function() onClickInfo,
    required Function() onClickViewScore,
  }) : super(
          margin: EdgeInsets.only(bottom: offsetXMd),
          decoration: BoxDecoration(
            color: KangaColor().bubbleConnerColor(1),
            border: Border.all(
              color: KangaColor().textGreyColor(1),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      title.toUpperCase(),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  SizedBox(
                    width: offsetBase,
                  ),
                  InkWell(
                    child: Icon(Icons.info_outline),
                    onTap: onClickInfo,
                  ),
                ],
              ),
              Divider(),
              Container(
                height: 120,
                child: body,
              ),
              Divider(),
              InkWell(
                onTap: onClickViewScore,
                child: Padding(
                  padding: const EdgeInsets.all(offsetBase),
                  child: Text(
                    S.current.viewScore.toUpperCase(),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ],
          ),
        );
}

class ViewValueWidget extends Column {
  ViewValueWidget({
    required BuildContext context,
    required String title,
    required String value,
  }) : super(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.caption!.copyWith(
                    fontSize: 18.0,
                  ),
            ),
            SizedBox(
              height: offsetBase,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    color: KangaColor().pinkButtonColor(1),
                  ),
            ),
          ],
        );
}
