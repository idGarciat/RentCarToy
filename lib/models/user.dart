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
      roles: json['roles'],
    );
  }

  User copyWith({String? id, String? name, String? username, String? email, String? roles}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      roles: roles ?? this.roles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'roles': roles,
    };
  }
}
