import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setValue({
    required String key,
    required dynamic value,
  }) async {
    if (value is int) {
      return await _prefs.setInt(key, value);
    } else if (value is double) {
      return await _prefs.setDouble(key, value);
    } else if (value is bool) {
      return await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      return await _prefs.setStringList(key, value);
    } else {
      return await _prefs.setString(key, value.toString());
    }
  }

  static Object? getValue({required String key}) {
    return _prefs.get(key);
  }

  static Future<bool> removeValue({required String key}) {
    return _prefs.remove(key);
  }
}
