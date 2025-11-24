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

  Future<bool> login(String email, String password) async {
    print('$email , $password');

    try {
      final url = Uri.parse('$_baseUrl/auth/login');
      final body = {"email": email, "password": password};

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
}
