import 'dart:convert';

import 'package:manage_devices_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMethod {
  static const String skipOnbroadingKey = "skipOnbroadingKey";
  static const String userCredentialKey = "userCredentialKey";

  /// Save skip onbroad and  make sure user can see it only one time
  static void saveSkipOnbroading() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(skipOnbroadingKey, true);
  }

  /// check is skip obroad
  static Future<bool> getSkipOnbroading() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(skipOnbroadingKey) ?? false;
  }

  /// save user data to use for method need it
  static void saveUserCredential(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userCredentialKey, jsonEncode(user.toMap()));
  }

  /// get current user from local
  static Future<User> getCurrentUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(userCredentialKey);
    return User.fromMap(jsonDecode(userData!));
  }
}
