class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.avatarUrl,
  });

  final String id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String role;
  final bool isActive;
  final DateTime? createdAt;
  final String? avatarUrl;

  String get displayName => username.isNotEmpty ? username : email;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}
