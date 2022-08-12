import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMethod {
  void setBool({required String key, required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool> getBool({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}
