import 'package:flutter/foundation.dart';

import '../model/server_file_entry_model.dart';
import '../services/api_client.dart';
import '../services/api_endpoints.dart';

class FileSystemRepository {
  const FileSystemRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<ServerFileEntryModel>> listDirectory(
    String serverId, {
    String path = '/',
  }) async {
    final normalized = normalizeServerPath(path);
    debugPrint('[FS] GET list server=$serverId path=$normalized');

    final json = await _apiClient.getJson(
      ApiEndpoints.mcServerFsList(serverId),
      queryParameters: <String, dynamic>{'path': normalized},
    );

    if (json is! List) {
      return const <ServerFileEntryModel>[];
    }

    return json
        .whereType<Map<String, dynamic>>()
        .map(ServerFileEntryModel.fromJson)
        .toList(growable: false);
  }

  Future<String> readFile(
    String serverId, {
    required String path,
  }) async {
    final normalized = normalizeServerPath(path);
    debugPrint('[FS] GET read server=$serverId path=$normalized');

    final json = await _apiClient.getJson(
      ApiEndpoints.mcServerFsRead(serverId),
      queryParameters: <String, dynamic>{'path': normalized},
    );

    if (json is Map<String, dynamic>) {
      return json['content'] as String? ?? '';
    }

    return '';
  }

  Future<void> writeFile(
    String serverId, {
    required String path,
    required String content,
  }) async {
    final normalized = normalizeServerPath(path);
    debugPrint('[FS] PUT write server=$serverId path=$normalized');

    await _apiClient.putJson(
      ApiEndpoints.mcServerFsWrite(serverId),
      queryParameters: <String, dynamic>{'path': normalized},
      body: <String, dynamic>{'content': content},
    );
  }
}
