import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthService {
  // Global ValueNotifier for simplicity. UI listens to this to react to auth changes.
  static final ValueNotifier<User?> user = ValueNotifier<User?>(null);

  /// Fake login: any non-empty username succeeds.
  static Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final u = username.trim();
      if (u.isNotEmpty) {
        user.value = User(username: u, email: '$u@example.com');
      return true;
    }
    return false;
  }

  static void logout() {
    user.value = null;
  }
}
