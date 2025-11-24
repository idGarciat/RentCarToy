import 'dart:convert';
import 'package:rentcar/auth/auth.dart';
import 'package:rentcar/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static SessionManager? _instace;

  static const _accessToken = "access_token";
  static const _refreshToken = "refresh_token";
  static const _keyUser = "user";

  static SessionManager? getInstance() {
    _instace ??= SessionManager();
    return _instace;
  }

  Future<void> saveSession(Auth auth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessToken, auth.accessToken);
    await prefs.setString(_refreshToken, auth.refreshToken);
    await prefs.setString(
      _keyUser,
      json.encode({
        'id': auth.user?.id,
        'name': auth.user?.name,
        'username': auth.user?.username,
        'email': auth.user?.email,
        'roles': auth.user?.roles,
      }),
    );
  }

  Future<Auth?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_accessToken);
    final refreshToken = prefs.getString(_refreshToken);
    final userStr = prefs.getString(_keyUser);

    if (accessToken != null && refreshToken != null && userStr != null) {
      final dynamic userJson = json.decode(userStr);
      return Auth(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: User.fromJson(userJson),
      );
    }
    return null;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessToken);
    await prefs.remove(_refreshToken);
    await prefs.remove(_keyUser);
  }
}
