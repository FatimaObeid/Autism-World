import 'dart:convert';
import 'package:autism_world/screens/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  bool _darkMode = false;

  // Live backend states
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  final String _baseUrl = "http://127.0.0.1:8000/api";

  Locale get locale => _locale;
  bool get darkMode => _darkMode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;

  Future<void> loadSavedSettings() async {
    _darkMode = await SettingsStorage.loadDarkMode();
    String langCode = await SettingsStorage.loadLanguage();
    _locale = Locale(langCode);
    notifyListeners();
  }

  void setLocale(Locale newLocale) async {
    _locale = newLocale;
    notifyListeners();
    await SettingsStorage.saveLanguage(newLocale.languageCode);
  }

  void toggleDarkMode(bool value) async {
    _darkMode = value;
    notifyListeners();
    await SettingsStorage.saveDarkMode(value);
  }

  // --- API INTEGRATION CORE LOGIC ---

  Future<Map<String, String>> _getHeaders() async {
    String? token = await SettingsStorage.loadAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? ""}',
    };
  }

  /// Fetch user profile details from Laravel
  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          _userData = data['user'];
        } else {
          _errorMessage = "Failed to load profile details";
        }
      } else {
        _errorMessage = "Server returned code: ${response.statusCode}";
      }
    } catch (e) {
      _errorMessage =
          "Connection error. Please check your network or server status.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Push updated profile entries to Laravel
  Future<bool> updateUserProfile(Map<String, String> updatedFields) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/profile/update'),
        headers: headers,
        body: jsonEncode(updatedFields),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await fetchUserProfile(); // sync state
          return true;
        }
      } else {
        final errorData = jsonDecode(response.body);
        _errorMessage = errorData['message'] ?? "Validation error occurred.";
      }
    } catch (e) {
      _errorMessage = "Failed to save profile details.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  /// Change password via Laravel API
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/profile/change-password'),
        headers: headers,
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);
      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? "Operation failed.",
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': "Connection error. Check your server connection.",
      };
    }
  }
}
