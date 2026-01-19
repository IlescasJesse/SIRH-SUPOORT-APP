class UserModel {
  final String id;
  final String username;
  final String email;
  final String role;
  final String? fullName;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      fullName: json['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'fullName': fullName,
    };
  }
}
