import '../model/node_model.dart';
import '../services/api_client.dart';
import '../services/api_endpoints.dart';

class NodesRepository {
  const NodesRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<NodeModel>> fetchNodes() async {
    final json = await _apiClient.getJson(ApiEndpoints.nodes) as List<dynamic>;
    return json
        .whereType<Map<String, dynamic>>()
        .map(NodeModel.fromJson)
        .toList(growable: false);
  }

  Future<NodeModel> fetchNode(String nodeId) async {
    final json =
        await _apiClient.getJson(ApiEndpoints.nodeById(nodeId)) as Map<String, dynamic>;
    return NodeModel.fromJson(json);
  }

  Future<NodeUsageModel> fetchNodeUsage(String nodeId) async {
    final json =
        await _apiClient.getJson(ApiEndpoints.nodeUsage(nodeId)) as Map<String, dynamic>;
    return NodeUsageModel.fromJson(json);
  }

  Future<NodeHardwareModel> fetchNodeHardware(String nodeId) async {
    final json = await _apiClient.getJson(ApiEndpoints.nodeHardware(nodeId))
        as Map<String, dynamic>;
    return NodeHardwareModel.fromJson(json);
  }
}
