import 'dart:convert';

import 'package:kasirsuper/features/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  ProfileService._();

  static const String _userKey = 'userList';
  static const String _loggedInUserKey = 'loggedInUser';
  static const String _isLoggedInKey = 'isLoggedIn';

  static Future<UserModel> insert(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<UserModel> users = await _getAllUsers();
      users.add(user);

      await prefs.setString(
        _userKey,
        jsonEncode(users.map((u) => u.toJson()).toList()),
      );

      return user;
    } catch (e) {
      throw Exception("Error saving user: ${e.toString()}");
    }
  }

  static Future<UserModel?> login(String email, String password) async {
    final users = await _getAllUsers();
    try {
      final user = users.firstWhere(
        (user) => user.email == email && user.password == password,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_loggedInUserKey, jsonEncode(user.toJson()));
      await prefs.setBool(_isLoggedInKey, true);

      return user;
    } catch (e) {
      return null;
    }
  }

  static Future<UserModel?> get() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_loggedInUserKey);

      if (data != null && data.isNotEmpty) {
        return UserModel.fromJson(jsonDecode(data));
      }

      return null; // Kembalikan null jika tidak ada data
    } catch (e) {
      throw Exception("Error retrieving logged-in user: ${e.toString()}");
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInUserKey);
    await prefs.setBool(_isLoggedInKey, false); 
  }

  static Future<List<UserModel>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      List<dynamic> jsonData = jsonDecode(userData);
      return jsonData.map((data) => UserModel.fromJson(data)).toList();
    }
    return [];
  }

  static Future<List<UserModel>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);

    if (userData != null) {
      List<dynamic> jsonData = jsonDecode(userData);
      return jsonData.map((data) => UserModel.fromJson(data)).toList();
    }

    return []; 
  }
}
