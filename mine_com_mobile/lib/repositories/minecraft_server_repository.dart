import '../model/minecraft_server_model.dart';
import '../services/api_client.dart';
import '../services/api_endpoints.dart';
import '../services/api_exception.dart';

class MinecraftServerRepository {
  const MinecraftServerRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<MinecraftServerModel>> fetchServers() async {
    final json =
        await _apiClient.getJson(ApiEndpoints.minecraftServers) as List<dynamic>;
    return json
        .whereType<Map<String, dynamic>>()
        .map(MinecraftServerModel.fromJson)
        .toList(growable: false);
  }

  Future<List<MinecraftServerModel>> fetchServersByNode(String nodeId) async {
    final json =
        await _apiClient.getJson(ApiEndpoints.nodeServers(nodeId)) as List<dynamic>;
    return json
        .whereType<Map<String, dynamic>>()
        .map(MinecraftServerModel.fromJson)
        .toList(growable: false);
  }

  Future<MinecraftServerModel> fetchServerById(String serverId) async {
    final json = await _apiClient.getJson(ApiEndpoints.mcServerById(serverId))
        as Map<String, dynamic>;
    return MinecraftServerModel.fromJson(json);
  }

  Future<void> startServer(String serverId) async {
    await _apiClient.postJson(ApiEndpoints.mcServerStart(serverId));
  }

  Future<void> stopServer(String serverId) async {
    await _apiClient.postJson(ApiEndpoints.mcServerStop(serverId));
  }

  Future<void> restartServer(String serverId) async {
    await _apiClient.postJson(ApiEndpoints.mcServerRestart(serverId));
  }

  Future<void> redeployServer(String serverId) async {
    await _apiClient.postJson(ApiEndpoints.mcServerRedeploy(serverId));
  }

  Future<String> createModsShareLink(String serverId) async {
    final json = await _apiClient.postJson(
      ApiEndpoints.mcServerModsShareLink(serverId),
    );

    if (json is! Map<String, dynamic>) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }

    final url = json['url']?.toString().trim() ?? '';
    if (url.isEmpty) {
      throw const ApiException(message: 'Сервер не вернул ссылку на моды');
    }

    return url;
  }
}
