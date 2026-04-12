import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

import '../../../model/minecraft_server_model.dart';
import '../../../model/metrics_model.dart';
import '../../../provider/metrics_provider.dart';

class MetricsFragment extends ConsumerStatefulWidget {
  const MetricsFragment({
    super.key,
    required this.server,
  });

  final MinecraftServerModel server;

  @override
  ConsumerState<MetricsFragment> createState() => _MetricsFragmentState();
}

class _MetricsFragmentState extends ConsumerState<MetricsFragment> {
  int _selectedTab = 0;

  Future<void> _refresh() async {
    ref.invalidate(serverMetricsScreenProvider(widget.server.id));
    await ref.read(serverMetricsScreenProvider(widget.server.id).future);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final metricsAsync = ref.watch(serverMetricsScreenProvider(widget.server.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.server.name} - ${l10n.metricsMetricsFragment}'),
      ),
      body: metricsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _MetricsErrorState(
          message: error.toString(),
          onRetry: _refresh,
        ),
        data: (data) {
          if (data.current == null && data.series.isEmpty) {
            return _MetricsEmptyState(
              message: l10n.metricsUnavailableMessage,
            );
          }

          final current = data.current ?? data.series.last;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                24 + MediaQuery.of(context).padding.bottom,
              ),
              children: [
                Row(
                  children: [
                    _buildTab(context, l10n.cpuMetricsFragment, 0),
                    _buildTab(context, l10n.memoryMetricsFragment, 1),
                    _buildTab(context, l10n.overviewMetricsFragment, 2),
                  ],
                ),
                const SizedBox(height: 20),
                if (_selectedTab == 0)
                  _buildChart(
                    context,
                    data.series,
                    l10n.cpuMetricsFragment,
                    (item) => item.cpuUsagePercent,
                  ),
                if (_selectedTab == 1)
                  _buildChart(
                    context,
                    data.series,
                    l10n.ramMetricsFragment,
                    (item) => item.ramUsagePercent,
                  ),
                if (_selectedTab == 2) _buildOverview(context, current, l10n),
                const SizedBox(height: 20),
                _buildStatsCard(context, data.series, l10n),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, int index) {
    final theme = Theme.of(context);
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.16)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<ServerMetricsModel> series,
    String title,
    double Function(ServerMetricsModel item) selector,
  ) {
    final theme = Theme.of(context);
    final points = series.isEmpty
        ? const <ServerMetricsModel>[]
        : series;
    final spots = points.isEmpty
        ? const <FlSpot>[FlSpot(0, 0)]
        : points
            .asMap()
            .entries
            .map((entry) => FlSpot(entry.key.toDouble(), selector(entry.value)))
            .toList(growable: false);
    final values = points.map(selector).toList(growable: false);
    final maxValue = values.isEmpty
        ? 100.0
        : values.reduce((current, next) => current > next ? current : next);
    final dynamicMaxY = maxValue <= 100 ? 100.0 : (maxValue * 1.15).clamp(100.0, 10000.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: dynamicMaxY,
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => theme.cardColor,
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt().clamp(0, points.length - 1);
                        final point = points[index];
                        return LineTooltipItem(
                          '${_formatTooltipDate(point.recordedAt)}\n'
                          '${selector(point).toStringAsFixed(2)}%',
                          theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ) ??
                              const TextStyle(fontSize: 12),
                        );
                      }).toList(growable: false);
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.dividerColor,
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: theme.dividerColor),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: spots.length > 8 ? 2 : 1,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            value.toInt().toString(),
                            style: theme.textTheme.bodySmall,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 46,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: theme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: spots.length <= 12),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.primary.withOpacity(0.12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(
    BuildContext context,
    ServerMetricsModel current,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _CircularMetric(
            label: l10n.cpuMetricsFragment,
            value: current.cpuUsagePercent,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _CircularMetric(
            label: l10n.ramMetricsFragment,
            value: current.ramUsagePercent,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    List<ServerMetricsModel> series,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final cpuValues = series.map((item) => item.cpuUsagePercent).toList();
    final ramValues = series.map((item) => item.ramUsagePercent).toList();

    final avgCpu = _average(cpuValues);
    final avgRam = _average(ramValues);
    final maxCpu = _maxValue(cpuValues);
    final maxRam = _maxValue(ramValues);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statisticsMetricsFragment,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _StatRow(label: l10n.averageCpuMetricsFragment, value: '${avgCpu.toStringAsFixed(1)}%'),
          _StatRow(label: l10n.averageRamMetricsFragment, value: '${avgRam.toStringAsFixed(1)}%'),
          _StatRow(label: l10n.maxCpuMetricsFragment, value: '${maxCpu.toStringAsFixed(1)}%'),
          _StatRow(label: l10n.maxRamMetricsFragment, value: '${maxRam.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  double _average(List<double> values) {
    if (values.isEmpty) {
      return 0;
    }
    final sum = values.fold<double>(0, (total, value) => total + value);
    return sum / values.length;
  }

  double _maxValue(List<double> values) {
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((current, next) => current > next ? current : next);
  }

  String _formatTooltipDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '-';
    }
    return DateFormat('yyyy.MM.dd HH:mm:ss').format(dateTime.toLocal());
  }
}

class _CircularMetric extends StatelessWidget {
  const _CircularMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: (value.clamp(0, 100)) / 100,
                    strokeWidth: 8,
                    backgroundColor: theme.dividerColor,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${value.toStringAsFixed(1)}%',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(label, style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsErrorState extends StatelessWidget {
  const _MetricsErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.show_chart_outlined, size: 56),
            const SizedBox(height: 16),
            Text(l10n.metricsUnavailableMessage, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(l10n.retryCommon),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricsEmptyState extends StatelessWidget {
  const _MetricsEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
