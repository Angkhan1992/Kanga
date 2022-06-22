import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:kanga/models/user_model.dart';
import 'package:kanga/utils/constants.dart';

class PrefProvider {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(Constants.keyToken) ?? '';
  }

  Future setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(Constants.keyToken, token);
  }

  Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await _prefs;
    var userData = prefs.getString(Constants.keyUserData) ?? '';
    if (userData.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(userData));
  }

  Future setUser(UserModel user) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(Constants.keyUserData, jsonEncode(user.toJson()));
  }

  Future<dynamic> getAppInfo() async {
    final SharedPreferences prefs = await _prefs;
    var infoData = prefs.getString(Constants.keyAppInfo) ?? '';
    if (infoData.isEmpty) return null;
    return jsonDecode(infoData);
  }

  Future setAppInfo(dynamic appInfo) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(Constants.keyAppInfo, jsonEncode(appInfo));
  }

  Future<bool> getMeasureAgree() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(Constants.keyMeasureAgree) ?? false;
  }

  Future setMeasureAgree(bool isAgree) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(Constants.keyMeasureAgree, isAgree);
  }

  Future<bool> getGainLevel() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(Constants.keyGainLevel) ?? false;
  }

  Future setGainLevel(bool isGain) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(Constants.keyGainLevel, isGain);
  }

  Future<String> getAskMeasure() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(Constants.keyAskMeasure) ?? '';
  }

  Future setAskMeasure(String datetime) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(Constants.keyAskMeasure, datetime);
  }

  Future<int> getBadge() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(Constants.keyBadgeNumber) ?? 0;
  }

  Future setBadge(int badge) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(Constants.keyBadgeNumber, badge);
  }
}
