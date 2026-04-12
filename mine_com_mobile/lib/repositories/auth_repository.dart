import '../model/auth_session.dart';
import '../model/user_model.dart';
import '../services/api_client.dart';
import '../services/api_endpoints.dart';
import '../services/auth_storage.dart';

class AuthRepository {
  const AuthRepository({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final ApiClient _apiClient;
  final AuthStorage _storage;

  Future<AuthSession?> readStoredSession() => _storage.readSession();

  Future<String?> readRememberedIdentity() => _storage.readRememberedIdentity();

  Future<AuthSession> login({
    required String identity,
    required String password,
    required bool rememberIdentity,
  }) async {
    final json = await _apiClient.postJson(
      ApiEndpoints.authLogin,
      authenticated: false,
      body: <String, dynamic>{
        'identity': identity,
        'password': password,
      },
    ) as Map<String, dynamic>;

    final session = AuthSession.fromJson(json);
    await _storage.saveSession(session);
    await _storage.saveRememberedIdentity(
      identity: identity,
      remember: rememberIdentity,
    );
    return session;
  }

  Future<AuthSession> register({
    required String username,
    required String password,
    String? email,
    bool rememberIdentity = true,
  }) async {
    final json = await _apiClient.postJson(
      ApiEndpoints.authRegister,
      authenticated: false,
      body: <String, dynamic>{
        'username': username,
        'password': password,
        if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
      },
    ) as Map<String, dynamic>;

    final session = AuthSession.fromJson(json);
    await _storage.saveSession(session);
    await _storage.saveRememberedIdentity(
      identity: email?.trim().isNotEmpty == true ? email!.trim() : username,
      remember: rememberIdentity,
    );
    return session;
  }

  Future<UserModel> getCurrentUser() async {
    final json =
        await _apiClient.getJson(ApiEndpoints.userMe) as Map<String, dynamic>;
    return UserModel.fromJson(json);
  }

  Future<UserModel> updateProfile({
    required String username,
    required String email,
    String? phoneNumber,
  }) async {
    final json = await _apiClient.putJson(
      ApiEndpoints.userMe,
      body: <String, dynamic>{
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
      },
    ) as Map<String, dynamic>;

    return UserModel.fromJson(json);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.putJson(
      ApiEndpoints.userPassword,
      body: <String, dynamic>{
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<void> logout() async {
    try {
      await _apiClient.postJson(ApiEndpoints.authLogout);
    } catch (_) {
      // Local cleanup is more important than surfacing logout failures.
    } finally {
      await _storage.clearSession();
    }
  }

  Future<void> clearSession({
    bool preserveRememberedIdentity = true,
  }) {
    return _storage.clearSession(
      preserveRememberedIdentity: preserveRememberedIdentity,
    );
  }
}
