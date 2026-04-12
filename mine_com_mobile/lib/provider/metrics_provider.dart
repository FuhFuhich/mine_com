import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/metrics_model.dart';
import '../services/app_config.dart';
import 'app_dependencies.dart';

class ServerMetricsScreenData {
  const ServerMetricsScreenData({
    required this.current,
    required this.series,
  });

  final ServerMetricsModel? current;
  final List<ServerMetricsModel> series;
}

final latestMetricsProvider =
    FutureProvider.family<ServerMetricsModel?, String>((ref, serverId) {
  return ref.watch(metricsRepositoryProvider).fetchLatestOrRuntime(serverId);
});

final serverMetricsScreenProvider =
    FutureProvider.family<ServerMetricsScreenData, String>((ref, serverId) async {
  final repository = ref.watch(metricsRepositoryProvider);

  final results = await Future.wait<Object?>([
    repository.fetchLatestOrRuntime(serverId),
    _safeSeries(
      () => repository.fetchSeries(
        serverId,
        hours: AppConfig.defaultMetricsHours,
        points: AppConfig.defaultMetricsPoints,
      ),
    ),
  ]);

  final current = results[0] as ServerMetricsModel?;
  final rawSeries = results[1] as List<ServerMetricsModel>;
  final series = rawSeries.isNotEmpty
      ? rawSeries
      : current == null
          ? const <ServerMetricsModel>[]
          : <ServerMetricsModel>[current];

  return ServerMetricsScreenData(
    current: current,
    series: series,
  );
});

Future<List<ServerMetricsModel>> _safeSeries(
  Future<List<ServerMetricsModel>> Function() action,
) async {
  try {
    return await action();
  } catch (_) {
    return const <ServerMetricsModel>[];
  }
}
