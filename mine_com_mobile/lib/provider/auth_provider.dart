import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/auth_session.dart';
import '../model/user_model.dart';
import '../services/api_exception.dart';
import 'app_dependencies.dart';

class AuthState {
  const AuthState({
    required this.isInitializing,
    required this.isSubmitting,
    this.session,
    this.user,
    this.rememberedIdentity,
    this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(
      isInitializing: true,
      isSubmitting: false,
    );
  }

  final bool isInitializing;
  final bool isSubmitting;
  final AuthSession? session;
  final UserModel? user;
  final String? rememberedIdentity;
  final String? errorMessage;

  bool get isAuthenticated => session != null && user != null;

  AuthState copyWith({
    bool? isInitializing,
    bool? isSubmitting,
    AuthSession? session,
    bool clearSession = false,
    UserModel? user,
    bool clearUser = false,
    String? rememberedIdentity,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      isInitializing: isInitializing ?? this.isInitializing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      session: clearSession ? null : (session ?? this.session),
      user: clearUser ? null : (user ?? this.user),
      rememberedIdentity: rememberedIdentity ?? this.rememberedIdentity,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref) : super(AuthState.initial()) {
    _restoreSession();
  }

  final Ref _ref;

  Future<void> _restoreSession() async {
    final repository = _ref.read(authRepositoryProvider);
    final rememberedIdentity = await repository.readRememberedIdentity();
    final storedSession = await repository.readStoredSession();

    if (storedSession == null) {
      state = AuthState(
        isInitializing: false,
        isSubmitting: false,
        rememberedIdentity: rememberedIdentity,
      );
      return;
    }

    try {
      final user = await repository.getCurrentUser();
      final refreshedSession =
          await repository.readStoredSession() ?? storedSession;
      state = AuthState(
        isInitializing: false,
        isSubmitting: false,
        session: refreshedSession,
        user: user,
        rememberedIdentity: rememberedIdentity,
      );
    } catch (error) {
      await repository.clearSession();
      state = AuthState(
        isInitializing: false,
        isSubmitting: false,
        rememberedIdentity: rememberedIdentity,
        errorMessage: _errorMessage(error),
      );
    }
  }

  Future<String?> getRememberedIdentity() async {
    final identity =
        await _ref.read(authRepositoryProvider).readRememberedIdentity();
    state = state.copyWith(rememberedIdentity: identity);
    return identity;
  }

  Future<void> login({
    required String identity,
    required String password,
    required bool rememberIdentity,
  }) async {
    state = state.copyWith(
      isSubmitting: true,
      clearErrorMessage: true,
    );

    try {
      final repository = _ref.read(authRepositoryProvider);
      final session = await repository.login(
        identity: identity.trim(),
        password: password,
        rememberIdentity: rememberIdentity,
      );
      final user = await repository.getCurrentUser();

      state = AuthState(
        isInitializing: false,
        isSubmitting: false,
        session: session,
        user: user,
        rememberedIdentity: await repository.readRememberedIdentity(),
      );
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: _errorMessage(error),
      );
      rethrow;
    }
  }

  Future<void> register({
    required String username,
    required String password,
    String? email,
  }) async {
    state = state.copyWith(
      isSubmitting: true,
      clearErrorMessage: true,
    );

    try {
      final repository = _ref.read(authRepositoryProvider);
      final session = await repository.register(
        username: username.trim(),
        password: password,
        email: email?.trim(),
      );
      final user = await repository.getCurrentUser();

      state = AuthState(
        isInitializing: false,
        isSubmitting: false,
        session: session,
        user: user,
        rememberedIdentity: await repository.readRememberedIdentity(),
      );
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: _errorMessage(error),
      );
      rethrow;
    }
  }

  Future<void> refreshProfile() async {
    if (!state.isAuthenticated) {
      return;
    }

    try {
      final repository = _ref.read(authRepositoryProvider);
      final user = await repository.getCurrentUser();
      final session = await repository.readStoredSession();
      state = state.copyWith(
        session: session,
        user: user,
        clearErrorMessage: true,
      );
    } catch (error) {
      state = state.copyWith(errorMessage: _errorMessage(error));
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isSubmitting: true, clearErrorMessage: true);

    final repository = _ref.read(authRepositoryProvider);
    await repository.logout();

    state = AuthState(
      isInitializing: false,
      isSubmitting: false,
      rememberedIdentity: await repository.readRememberedIdentity(),
    );
  }

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return error.toString();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
