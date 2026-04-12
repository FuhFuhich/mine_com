import '../model/backup_model.dart';
import '../services/api_client.dart';
import '../services/api_endpoints.dart';

class BackupRepository {
  const BackupRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<BackupModel>> fetchBackups(String serverId) async {
    final json =
        await _apiClient.getJson(ApiEndpoints.backupsByServer(serverId))
            as List<dynamic>;
    return json
        .whereType<Map<String, dynamic>>()
        .map(BackupModel.fromJson)
        .toList(growable: false);
  }

  Future<void> createBackup(String serverId) async {
    await _apiClient.postJson(ApiEndpoints.backupsByServer(serverId));
  }

  Future<void> restoreBackup(String backupId) async {
    await _apiClient.postJson(ApiEndpoints.restoreBackup(backupId));
  }

  Future<void> deleteBackup(String backupId) async {
    await _apiClient.deleteJson(ApiEndpoints.deleteBackup(backupId));
  }
}
