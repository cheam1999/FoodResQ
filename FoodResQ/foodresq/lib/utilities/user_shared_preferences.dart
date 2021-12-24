import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static late SharedPreferences _preferences;

  static const _keyLoginStatus = 'isLogin';
  static const _keyAccessToken = 'accessToken';
  static const _keyTokenType = 'tokenType';
  static const _keyIntroduction = 'introduction';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  // Login status

  static Future setLoginStatus(bool isLogin) async =>
      await _preferences.setBool(_keyLoginStatus, isLogin);

  static bool? getLoginStatus() => _preferences.getBool(_keyLoginStatus);

  static Future removeLoginStatus() => _preferences.remove(_keyLoginStatus);

  // Access token

  static Future setAccessToken(String acessToken) async =>
      await _preferences.setString(_keyAccessToken, acessToken);

  static String? getAccessToken() => _preferences.getString(_keyAccessToken);

  static Future removeAccessToken() => _preferences.remove(_keyAccessToken);

  // Token type

  static Future setTokenType(String tokenType) async =>
      await _preferences.setString(_keyTokenType, tokenType);

  static String? getTokenType() => _preferences.getString(_keyTokenType);

  static Future removeTokenType() => _preferences.remove(_keyTokenType);

  // Introduction
  static Future setIntroductionViewed(bool isLogin) async =>
      await _preferences.setBool(_keyIntroduction, isLogin);

  static bool? getIntroductionViewed() =>
      _preferences.getBool(_keyIntroduction);
}
