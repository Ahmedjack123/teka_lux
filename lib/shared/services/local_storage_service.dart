import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  const LocalStorageService(this._preferences);

  final SharedPreferences _preferences;

  bool getBool(String key, {bool defaultValue = false}) {
    return _preferences.getBool(key) ?? defaultValue;
  }

  String getString(String key, {String defaultValue = ''}) {
    return _preferences.getString(key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }
}
