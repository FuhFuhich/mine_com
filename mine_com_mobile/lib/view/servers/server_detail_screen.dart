import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

import '../../model/minecraft_server_model.dart';
import '../../model/metrics_model.dart';
import '../../model/node_model.dart';
import '../../provider/app_dependencies.dart';
import '../../provider/metrics_provider.dart';
import '../../provider/minecraft_server_provider.dart';
import '../../services/api_exception.dart';
import 'backups_screen.dart';
import 'build fragments/metrics_fragment.dart';
import 'build fragments/server_logs_fragment.dart';
import 'server_console_screen.dart';
import 'config_files_screen.dart';

class ServerDetailScreen extends ConsumerStatefulWidget {
  const ServerDetailScreen({
    super.key,
    required this.server,
  });

  final MinecraftServerModel server;

  @override
  ConsumerState<ServerDetailScreen> createState() => _ServerDetailScreenState();
}

class _ServerDetailScreenState extends ConsumerState<ServerDetailScreen> {
  bool _isRunningAction = false;

  Future<void> _refresh() async {
    ref.invalidate(serverListPageProvider);
    ref.invalidate(latestMetricsProvider(widget.server.id));
    await Future.wait([
      ref.read(serverListPageProvider.future),
      ref.read(latestMetricsProvider(widget.server.id).future),
    ]);
  }

  Future<void> _runAction({
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    if (_isRunningAction) {
      return;
    }

    setState(() => _isRunningAction = true);

    try {
      await action();
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
      await _refresh();
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = error is ApiException ? error.message : error.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isRunningAction = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final latestServer =
        ref.watch(serverByIdProvider(widget.server.id)) ?? widget.server;
    final role = ref.watch(nodeRoleByServerIdProvider(widget.server.id));
    final metricsAsync = ref.watch(latestMetricsProvider(widget.server.id));
    final metrics = metricsAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          latestServer.name,
          style: theme.textTheme.titleLarge,
        ),

      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _StatusCard(
              server: latestServer,
              metrics: metrics,
            ),
            const SizedBox(height: 20),
            _ServerInfoSection(server: latestServer),
            const SizedBox(height: 20),
            _MetricsPreview(
              metrics: metrics,
              loadError: metricsAsync.hasError ? metricsAsync.error.toString() : null,
            ),
            const SizedBox(height: 20),
            if (role?.canManageServerLifecycle == true)
              _LifecycleActions(
                isBusy: _isRunningAction,
                onStart: () => _runAction(
                  action: () => ref
                      .read(minecraftServerRepositoryProvider)
                      .startServer(latestServer.id),
                  successMessage: l10n.serverActionStartedMessage,
                ),
                onStop: () => _runAction(
                  action: () => ref
                      .read(minecraftServerRepositoryProvider)
                      .stopServer(latestServer.id),
                  successMessage: l10n.serverActionStoppedMessage,
                ),
                onRestart: () => _runAction(
                  action: () => ref
                      .read(minecraftServerRepositoryProvider)
                      .restartServer(latestServer.id),
                  successMessage: l10n.serverActionRestartedMessage,
                ),
              )
            else
              _ReadOnlyHint(role: role),
            if (role?.canRedeploy == true) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isRunningAction
                    ? null
                    : () => _runAction(
                          action: () => ref
                              .read(minecraftServerRepositoryProvider)
                              .redeployServer(latestServer.id),
                          successMessage: l10n.serverActionRedeployedMessage,
                        ),
                icon: const Icon(Icons.system_update_alt),
                label: Text(l10n.serverDetailRedeployAction),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MetricsFragment(server: latestServer),
                  ),
                );
              },
              icon: const Icon(Icons.show_chart),
              label: Text(l10n.detailedMetricsServerDetail),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ServerConsoleScreen(
                      server: latestServer,
                      role: role,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.terminal),
              label: Text(l10n.serverConsoleServerDetail),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ServerLogsFragment(server: latestServer),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: Text(l10n.serverLogsServerDetail),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BackupsScreen(
                      server: latestServer,
                      role: role,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.backup_outlined),
              label: Text(l10n.serverBackupsTitle),
            ),
            if (role?.canViewConfigs == true) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConfigFilesScreen(
                        server: latestServer,
                        role: role,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_note_outlined),
                label: const Text('Изменить конфиги'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.server,
    required this.metrics,
  });

  final MinecraftServerModel server;
  final ServerMetricsModel? metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isOnline = server.normalizedStatus == 'online';
    final statusColor =
        isOnline ? theme.colorScheme.primary : theme.colorScheme.error;
    final uptime = _formatUptime(metrics?.uptimeSeconds, l10n);
    final startedAt = _formatStartedAt(metrics?.uptimeSeconds);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.cloud_done : Icons.cloud_off,
            color: statusColor,
            size: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.serverStatusServerDetail,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  _statusLabel(l10n, server.normalizedStatus),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 16),
                    const SizedBox(width: 4),
                    Text('${l10n.worksServerDetail} $uptime'),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text('${l10n.launchedServerDetail} $startedAt'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatUptime(int? uptimeSeconds, AppLocalizations l10n) {
    if (uptimeSeconds == null || uptimeSeconds <= 0) {
      return l10n.commonUnavailable;
    }

    final duration = Duration(seconds: uptimeSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours${l10n.hServerDetail} $minutes${l10n.mServerDetail}';
  }

  String _formatStartedAt(int? uptimeSeconds) {
    if (uptimeSeconds == null || uptimeSeconds <= 0) {
      return '-';
    }

    final startedAt = DateTime.now().subtract(Duration(seconds: uptimeSeconds));
    return '${startedAt.hour.toString().padLeft(2, '0')}:'
        '${startedAt.minute.toString().padLeft(2, '0')}';
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'online':
        return l10n.onlineServerList;
      case 'offline':
        return l10n.offlineServerList;
      case 'starting':
        return l10n.serverStatusStarting;
      case 'stopping':
        return l10n.serverStatusStopping;
      case 'restarting':
        return l10n.serverStatusRestarting;
      case 'deploying':
        return l10n.serverStatusDeploying;
      case 'undeployed':
        return l10n.serverStatusUndeployed;
      case 'crashed':
        return l10n.serverStatusCrashed;
      case 'error':
      default:
        return l10n.serverStatusError;
    }
  }
}

class _ServerInfoSection extends StatelessWidget {
  const _ServerInfoSection({required this.server});

  final MinecraftServerModel server;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final items = <MapEntry<String, String>>[
      MapEntry(l10n.minecraftVersionServerDetail, server.versionLabel),
      MapEntry(l10n.serverDetailDeployTargetLabel, server.deployTarget),
      if (server.gamePort != null)
        MapEntry(l10n.serverDetailPortLabel, server.gamePort.toString()),
      if (server.cpuCores != null)
        MapEntry(l10n.dedicatedCoresServerDetail, '${server.cpuCores}'),
      if (server.ramMb != null)
        MapEntry(l10n.dedicatedRamServerDetail, '${server.ramMb} MB'),
      if (server.diskMb != null)
        MapEntry(l10n.nodeDetailDiskLabel, '${server.diskMb} MB'),
      MapEntry(
        l10n.serverDetailBackupsEnabledLabel,
        server.backupEnabled ? l10n.commonEnabled : l10n.commonDisabled,
      ),
    ];

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
            l10n.serverInformationServerDetail,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.key,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
}

class _MetricsPreview extends StatelessWidget {
  const _MetricsPreview({
    required this.metrics,
    required this.loadError,
  });

  final ServerMetricsModel? metrics;
  final String? loadError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
            l10n.currentMetricsServerDetail,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (loadError != null)
            Text(
              loadError!,
              style: TextStyle(color: theme.colorScheme.error),
            )
          else if (metrics == null)
            Text(l10n.metricsUnavailableMessage)
          else ...[
            _MetricRow(
              label: l10n.cpuServerDetail,
              value: metrics!.cpuUsagePercent,
            ),
            const SizedBox(height: 12),
            _MetricRow(
              label: l10n.ramServerDetail,
              value: metrics!.ramUsagePercent,
            ),
            const SizedBox(height: 12),
            _MetricRow(
              label: l10n.nodeDetailDiskLabel,
              value: metrics!.diskUsagePercent,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.activePlayersServerDetail}: '
                    '${metrics!.playersOnline ?? 0}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                if (metrics!.tps != null)
                  Expanded(
                    child: Text(
                      'TPS: ${metrics!.tps!.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.end,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor =
        value > 80 ? theme.colorScheme.error : theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodySmall),
            Text('${value.toStringAsFixed(1)}%'),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value / 100,
          minHeight: 8,
          color: progressColor,
        ),
      ],
    );
  }
}

class _LifecycleActions extends StatelessWidget {
  const _LifecycleActions({
    required this.isBusy,
    required this.onStart,
    required this.onStop,
    required this.onRestart,
  });

  final bool isBusy;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ControlButton(
          icon: Icons.play_arrow,
          label: l10n.startServerDetailServerDetail,
          onPressed: isBusy ? null : onStart,
          color: Colors.green,
        ),
        _ControlButton(
          icon: Icons.stop,
          label: l10n.stopServerDetail,
          onPressed: isBusy ? null : onStop,
          color: Colors.red,
        ),
        _ControlButton(
          icon: Icons.restart_alt,
          label: l10n.restartServerDetail,
          onPressed: isBusy ? null : onRestart,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ReadOnlyHint extends StatelessWidget {
  const _ReadOnlyHint({required this.role});

  final NodeRole? role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              role == null
                  ? l10n.serverDetailReadOnlyHint
                  : '${l10n.serverDetailReadOnlyHint} (${role!.name.toUpperCase()})',
            ),
          ),
        ],
      ),
    );
  }
}
