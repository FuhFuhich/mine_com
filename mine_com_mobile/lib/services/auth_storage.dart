import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth_session.dart';

class AuthStorage {
  const AuthStorage();

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _usernameKey = 'auth_username';
  static const String _emailKey = 'auth_email';
  static const String _roleKey = 'auth_role';
  static const String _rememberIdentityKey = 'remember_identity';
  static const String _rememberedIdentityValueKey = 'remembered_identity_value';

  Future<void> saveSession(AuthSession session) async {
    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: session.accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: session.refreshToken),
      _secureStorage.write(key: _usernameKey, value: session.username),
      _secureStorage.write(key: _emailKey, value: session.email),
      _secureStorage.write(key: _roleKey, value: session.role),
    ]);
  }

  Future<AuthSession?> readSession() async {
    final values = await Future.wait([
      _secureStorage.read(key: _accessTokenKey),
      _secureStorage.read(key: _refreshTokenKey),
      _secureStorage.read(key: _usernameKey),
      _secureStorage.read(key: _emailKey),
      _secureStorage.read(key: _roleKey),
    ]);

    final accessToken = values[0];
    final refreshToken = values[1];

    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      return null;
    }

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      username: values[2] ?? '',
      email: values[3] ?? '',
      role: values[4] ?? '',
    );
  }

  Future<String?> readAccessToken() => _secureStorage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() =>
      _secureStorage.read(key: _refreshTokenKey);

  Future<void> clearSession({
    bool preserveRememberedIdentity = true,
  }) async {
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
      _secureStorage.delete(key: _usernameKey),
      _secureStorage.delete(key: _emailKey),
      _secureStorage.delete(key: _roleKey),
    ]);

    if (!preserveRememberedIdentity) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_rememberIdentityKey);
      await prefs.remove(_rememberedIdentityValueKey);
    }
  }

  Future<void> saveRememberedIdentity({
    required String identity,
    required bool remember,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberIdentityKey, remember);

    if (remember) {
      await prefs.setString(_rememberedIdentityValueKey, identity);
      return;
    }

    await prefs.remove(_rememberedIdentityValueKey);
  }

  Future<String?> readRememberedIdentity() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_rememberIdentityKey) ?? false;
    if (!remember) {
      return null;
    }
    return prefs.getString(_rememberedIdentityValueKey);
  }
}
