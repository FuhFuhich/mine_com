class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.email,
    required this.role,
  });

  final String accessToken;
  final String refreshToken;
  final String username;
  final String email;
  final String role;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }
}
