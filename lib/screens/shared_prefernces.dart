import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  static const _darkKey = "darkMode";
  static const _langKey = "language";
  static const _notifKey = "notifications";

  static Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, value);
  }

  static Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkKey) ?? false;
  }

  static Future<void> saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, code);
  }

  static Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_langKey) ?? "en";
  }

  static Future<void> saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifKey, value);
  }

  static Future<bool> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notifKey) ?? true;
  }
}
