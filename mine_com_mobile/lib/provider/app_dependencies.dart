import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../repositories/auth_repository.dart';
import '../repositories/backup_repository.dart';
import '../repositories/console_repository.dart';
import '../repositories/dashboard_repository.dart';
import '../repositories/file_system_repository.dart';
import '../repositories/minecraft_server_repository.dart';
import '../repositories/metrics_repository.dart';
import '../repositories/nodes_repository.dart';
import '../services/api_client.dart';
import '../services/auth_storage.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final authStorageProvider = Provider<AuthStorage>((ref) {
  return const AuthStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    httpClient: ref.watch(httpClientProvider),
    storage: ref.watch(authStorageProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(authStorageProvider),
  );
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(apiClient: ref.watch(apiClientProvider));
});

final nodesRepositoryProvider = Provider<NodesRepository>((ref) {
  return NodesRepository(apiClient: ref.watch(apiClientProvider));
});

final minecraftServerRepositoryProvider =
    Provider<MinecraftServerRepository>((ref) {
  return MinecraftServerRepository(apiClient: ref.watch(apiClientProvider));
});

final metricsRepositoryProvider = Provider<MetricsRepository>((ref) {
  return MetricsRepository(apiClient: ref.watch(apiClientProvider));
});

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepository(apiClient: ref.watch(apiClientProvider));
});

final consoleRepositoryProvider = Provider<ConsoleRepository>((ref) {
  return ConsoleRepository(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(authStorageProvider),
  );
});

final fileSystemRepositoryProvider = Provider<FileSystemRepository>((ref) {
  return FileSystemRepository(apiClient: ref.watch(apiClientProvider));
});
