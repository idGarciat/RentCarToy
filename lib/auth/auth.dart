import 'package:rentcar/models/user.dart';

class Auth {
  final String accessToken;
  final String refreshToken;
  final User? user;

  Auth({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    if (json['error'] == null) {
      return Auth(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        user: User.fromJson(json['user']),
      );
    } else {
      return Auth(
        accessToken: "no access_token",
        refreshToken: "no refres_token",
        user: null,
      );
    }
  }
}
