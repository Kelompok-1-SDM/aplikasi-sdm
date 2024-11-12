import 'dart:convert';

import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static const String _tokenKey = 'auth_token';
  static const String _expiryKey = 'token_expiry';
  static const String _myInfo = 'my_info';

  static Future<void> saveToken(String token, DateTime expiryDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_expiryKey, expiryDate.toIso8601String());
  }

  static Future<void> saveMyInfo(UserData myInfo) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonInfo = jsonEncode(myInfo);
    await prefs.setString(_myInfo, jsonInfo);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expiryString = prefs.getString(_expiryKey);

    if (token != null && expiryString != null) {
      final expiryDate = DateTime.parse(expiryString);
      if (expiryDate.isAfter(DateTime.now())) {
        return token; // Token is valid
      } else {
        await clearToken(); // Token expired
      }
    }
    return null; // No valid token
  }

  static Future<UserData?> getMyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final myInfo = prefs.getString(_myInfo);

    if (myInfo != null) {
      Map<String, dynamic> jsonMap = jsonDecode(myInfo);
      return UserData.fromJson(jsonMap);
    }
    return null; // No valid token
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expiryKey);
    await prefs.remove(_myInfo);
  }
}
