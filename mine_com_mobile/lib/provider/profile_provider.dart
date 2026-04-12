import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/dashboard_model.dart';
import '../model/user_model.dart';
import 'app_dependencies.dart';

class ProfileViewData {
  const ProfileViewData({
    required this.user,
    required this.dashboard,
  });

  final UserModel user;
  final DashboardModel dashboard;
}

final profileProvider = FutureProvider<ProfileViewData>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final dashboardRepository = ref.watch(dashboardRepositoryProvider);

  final results = await Future.wait<Object>([
    authRepository.getCurrentUser(),
    dashboardRepository.fetchDashboard(),
  ]);

  return ProfileViewData(
    user: results[0] as UserModel,
    dashboard: results[1] as DashboardModel,
  );
});
