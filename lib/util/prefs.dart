import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences._();

  static Future<bool> getBool(String key, [bool defaultValue = false]) async {
    var prefs = await _getSharedPreferences();
    return prefs.getBool(key) ?? defaultValue;
  }

  static void setBool(String key, bool value) async {
    var prefs = await _getSharedPreferences();
    prefs.setBool(key, value);
  }

  static Future<int> getInt(String key, [int defaultValue = 0]) async {
    var prefs = await _getSharedPreferences();
    return prefs.getInt(key) ?? defaultValue;
  }

  static void setInt(String key, int value) async {
    var prefs = await _getSharedPreferences();
    prefs.setInt(key, value);
  }

  static Future<String> getString(String key,
      [String defaultValue]) async {
    var prefs = await _getSharedPreferences();
    return prefs.getString(key) ?? defaultValue;
  }

  static void setString(String key, String value) async {
    var prefs = await _getSharedPreferences();
    prefs.setString(key, value);
  }

  static void remove(String key) async {
    var prefs = await _getSharedPreferences();
    prefs.remove(key);
  }

  static Future<SharedPreferences> _getSharedPreferences() async =>
      await SharedPreferences.getInstance();
}
