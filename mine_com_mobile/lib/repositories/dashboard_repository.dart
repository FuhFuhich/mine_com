import '../model/dashboard_model.dart';
import '../services/api_client.dart';
import '../services/api_endpoints.dart';

class DashboardRepository {
  const DashboardRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<DashboardModel> fetchDashboard() async {
    final json = await _apiClient.getJson(ApiEndpoints.dashboard)
        as Map<String, dynamic>;
    return DashboardModel.fromJson(json);
  }
}
