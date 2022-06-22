import 'package:flutter/cupertino.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/utils/constants.dart';

class CompareProvider {
  final BuildContext context;

  CompareProvider(this.context);

  static CompareProvider of(BuildContext context) {
    return CompareProvider(context);
  }

  String slb(UserModel user, double measure) {
    var compareValue = Map();
    for (var i = 0; i < SINGLELEGCOMPARE.length; i++) {
      var compare = SINGLELEGCOMPARE[i];
      if (user.getAge() < compare['max']! && user.getAge() > compare['min']!) {
        compareValue = compare;
      }
    }

    var result = S.current.notAtRisk;
    if (measure < compareValue['med']) {
      result = S.current.highRisk;
    } else if (measure < compareValue['low']) {
      result = S.current.mediumRisk;
    } else if (measure < compareValue['no']) {
      result = S.current.lowRisk;
    }
    return result;
  }

  String sts(UserModel user, int measure) {
    var compareValue = Map();
    for (var i = 0; i < SIT2STANDCOMPARE.length; i++) {
      var compare = SIT2STANDCOMPARE[i];
      if (user.getAge() < compare['max']! && user.getAge() > compare['min']!) {
        compareValue = compare;
      }
    }

    var result = S.current.notAtRisk;
    if (user.gender.toUpperCase() == 'MALE') {
      if (measure < compareValue['men']) {
        result = S.current.riskForFalls;
      }
    } else {
      if (measure < compareValue['women']) {
        result = S.current.riskForFalls;
      }
    }
    return result;
  }

  String tmw(UserModel user, double measure) {
    var compareValue = Map();
    for (var i = 0; i < TENMETERMENCOMPARE.length; i++) {
      if (user.gender.toUpperCase() == 'MALE') {
        var compare = TENMETERMENCOMPARE[i];
        if (user.getAge() < compare['max']! && user.getAge() > compare['min']!) {
          compareValue = compare;
          break;
        }
      } else {
        var compare = TENMETERWOMENCOMPARE[i];
        if (user.getAge() < compare['max']! && user.getAge() > compare['min']!) {
          compareValue = compare;
          break;
        }
      }
    }

    print('[TMW] measure : $measure}');
    print('[TMW] compare value : $compareValue}');

    var result = S.current.notAtRisk;
    if (measure < compareValue['low']) {
      result = S.current.riskForFalls;
    } else if (measure < compareValue['med']) {
      result = S.current.riskForFalls;
    }
    return result;
  }
}