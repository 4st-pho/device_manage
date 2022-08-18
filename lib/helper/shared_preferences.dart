import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMethod {
  static const String skipOnbroadingKey = "skipOnbroadingKey";

  static void setBool({required String key, required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> getBool({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static void saveSkipOnbroading() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(skipOnbroadingKey, true);
  }

  static Future<bool> getSkipOnbroading() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(skipOnbroadingKey) ?? false;
  }
}
