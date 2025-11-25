import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rentcar/auth/auth.dart';
import 'package:rentcar/classes/session_manager.dart';
import 'package:rentcar/models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  factory AuthService() => _instance;

  final _baseUrl = dotenv.env['API_URL'];

  final ValueNotifier<User?> user = ValueNotifier(null);

  bool get isLogged => user.value != null;

  Future<bool> login(String identifier, String password) async {
    print('$password, $identifier');
    try {
      final url = Uri.parse('$_baseUrl/auth/login');
      final body = {"email": identifier, "password": password};

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final auth = Auth.fromJson(responseData);

        await SessionManager().saveSession(auth);

        user.value = auth.user;

        return true;
      } else {
        print("Error ${response.statusCode}: ${response.body}");
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String username) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/register');
      final body = {"name": name, "email": email, "password": password, "username": username};

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final auth = Auth.fromJson(responseData);

        await SessionManager().saveSession(auth);

        user.value = auth.user;

        return {"ok": true, "message": "Registered"};
      } else {
        String message = response.body;
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map && decoded.containsKey('message')) {
            message = decoded['message'].toString();
          } else if (decoded is Map && decoded.containsKey('error')) {
            message = decoded['error'].toString();
          }
        } catch (_) {}
        print("Register error ${response.statusCode}: ${response.body}");
        return {"ok": false, "message": message};
      }
    } catch (e) {
      print('Register error: $e');
      return {"ok": false, "message": e.toString()};
    }
  }

  Future<void> logout() async {
    await SessionManager().clearSession();
    user.value = null;
  }

  Future<void> loadSession() async {
    final session = await SessionManager().getSession();
    if (session != null) {
      user.value = session.user;
    }
  }

  Future<Map<String, dynamic>> updateProfile(String id, {required String name, required String username, required String email, String? password}) async {
    try {
      final session = await SessionManager().getSession();
      if (session == null) return {"ok": false, "message": "No active session"};

      final url = Uri.parse('$_baseUrl/users/$id');
      final body = {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
      };
      if (password != null && password.isNotEmpty) body['password'] = password;

      final response = await http.patch(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}'
      }, body: jsonEncode(body));
      // backend expects PATCH /users/:id
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        // expect decoded to be the updated user object
        final updatedUser = User.fromJson(decoded);

        // rebuild auth and persist
        final updatedAuth = Auth(accessToken: session.accessToken, refreshToken: session.refreshToken, user: updatedUser);
        await SessionManager().saveSession(updatedAuth);
        user.value = updatedUser;
        return {"ok": true, "user": decoded};
      } else {
        String message = response.body;
        try {
          final decoded = json.decode(response.body);
          if (decoded is Map && decoded.containsKey('message')) message = decoded['message'].toString();
        } catch (_) {}
        return {"ok": false, "message": message};
      }
    } catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    try {
      final session = await SessionManager().getSession();
      if (session == null) return {"ok": false, "message": "No active session"};

      final url = Uri.parse('$_baseUrl/auth/change-password');
      final body = {"currentPassword": currentPassword, "newPassword": newPassword};

      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}'
      }, body: jsonEncode(body));

      if (response.statusCode == 200) {
        return {"ok": true, "message": "Password changed"};
      }

      String message = response.body;
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded.containsKey('message')) message = decoded['message'].toString();
      } catch (_) {}
      return {"ok": false, "message": message};
    } catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }
}
