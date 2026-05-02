import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  const LocalStorageService(this._preferences);

  final SharedPreferences _preferences;

  bool getBool(String key, {bool defaultValue = false}) {
    return _preferences.getBool(key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }
}
