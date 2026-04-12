import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import 'auth_provider.dart';

final userProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});
