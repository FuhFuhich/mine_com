import '../model/metrics_model.dart';
import '../services/api_client.dart';
import '../services/api_endpoints.dart';
import '../services/api_exception.dart';

class MetricsRepository {
  const MetricsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ServerMetricsModel?> fetchLatest(String serverId) async {
    try {
      final json = await _apiClient.getJson(ApiEndpoints.latestMetrics(serverId))
          as Map<String, dynamic>;
      return ServerMetricsModel.fromJson(json);
    } on ApiException catch (error) {
      if (error.isNotFound) {
        return null;
      }
      rethrow;
    }
  }

  Future<ServerMetricsModel?> fetchRuntime(String serverId) async {
    try {
      final json =
          await _apiClient.getJson(ApiEndpoints.runtimeMetrics(serverId))
              as Map<String, dynamic>;
      return ServerMetricsModel.fromJson(json);
    } on ApiException catch (error) {
      if (error.isNotFound) {
        return null;
      }
      rethrow;
    }
  }

  Future<ServerMetricsModel?> fetchLatestOrRuntime(String serverId) async {
    final latest = await fetchLatest(serverId);
    if (latest != null && latest.hasData) {
      return latest;
    }
    return fetchRuntime(serverId);
  }

  Future<List<ServerMetricsModel>> fetchSeries(
    String serverId, {
    int hours = 24,
    int points = 48,
  }) async {
    final json = await _apiClient.getJson(
      ApiEndpoints.metricsSeries(serverId),
      queryParameters: <String, dynamic>{
        'hours': hours,
        'points': points,
      },
    ) as List<dynamic>;

    final result = json
        .whereType<Map<String, dynamic>>()
        .map(ServerMetricsModel.fromJson)
        .toList(growable: true);

    result.sort((left, right) {
      final leftDate = left.recordedAt;
      final rightDate = right.recordedAt;
      if (leftDate == null && rightDate == null) {
        return 0;
      }
      if (leftDate == null) {
        return -1;
      }
      if (rightDate == null) {
        return 1;
      }
      return leftDate.compareTo(rightDate);
    });

    return result;
  }
}
