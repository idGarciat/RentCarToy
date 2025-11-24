class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final String roles;

  User({required this.username, required this.email, required this.id, required this.name, required this.roles});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      roles: json['roles']
    );
  }
}
