import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

import '../../model/minecraft_server_model.dart';
import '../../model/node_model.dart';
import '../../provider/nodes_provider.dart';
import 'server_detail_screen.dart';

class NodeDetailScreen extends ConsumerWidget {
  const NodeDetailScreen({
    super.key,
    required this.nodeId,
  });

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nodeAsync = ref.watch(nodeDetailProvider(nodeId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nodeDetailTitle),
      ),
      body: nodeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _NodeErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(nodeDetailProvider(nodeId)),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(nodeDetailProvider(nodeId));
            await ref.read(nodeDetailProvider(nodeId).future);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _NodeHeaderCard(node: data.node),
              const SizedBox(height: 16),
              _NodeUsageCard(usage: data.usage),
              const SizedBox(height: 16),
              _NodeServersCard(servers: data.servers),
            ],
          ),
        ),
      ),
    );
  }
}

class _NodeHeaderCard extends StatelessWidget {
  const _NodeHeaderCard({required this.node});

  final NodeModel node;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.hub_outlined,
                  color: Color(0xFF00E676),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      node.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      node.ipAddress,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Chip(label: Text(node.role.name.toUpperCase())),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: l10n.nodeDetailOsLabel, value: node.os ?? '-'),
          _InfoRow(label: l10n.nodeDetailSshUserLabel, value: node.sshUser),
          _InfoRow(
            label: l10n.nodeDetailSshPortLabel,
            value: node.sshPort?.toString() ?? '-',
          ),
          _InfoRow(label: l10n.nodeDetailAuthLabel, value: node.authType),
          if (node.description != null && node.description!.isNotEmpty)
            _InfoRow(
              label: l10n.nodeDetailDescriptionLabel,
              value: node.description!,
            ),
        ],
      ),
    );
  }
}

class _NodeUsageCard extends StatelessWidget {
  const _NodeUsageCard({required this.usage});

  final NodeUsageModel? usage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (usage == null) {
      return _UnavailableCard(title: l10n.nodeDetailUsageTitle);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.nodeDetailUsageTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _UsageBar(
            label: l10n.cpuServerDetail,
            value: usage!.cpuUsagePercent,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _UsageBar(
            label: l10n.ramServerDetail,
            value: usage!.ramUsagePercent,
            color: Colors.purple,
          ),
          const SizedBox(height: 12),
          _UsageBar(
            label: l10n.nodeDetailDiskLabel,
            value: usage!.diskUsagePercent,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          _InfoRow(
            label: l10n.nodeDetailContainersLabel,
            value:
                '${usage!.dockerContainersRunning ?? 0}/${usage!.dockerContainersTotal ?? 0}',
          ),
          _InfoRow(
            label: l10n.nodeDetailNetworkRxLabel,
            value: '${usage!.networkRxMb.toStringAsFixed(2)} MB',
          ),
          _InfoRow(
            label: l10n.nodeDetailNetworkTxLabel,
            value: '${usage!.networkTxMb.toStringAsFixed(2)} MB',
          ),
          if (usage!.collectedAt != null)
            _InfoRow(
              label: l10n.nodeDetailCollectedAtLabel,
              value: DateFormat.yMd().add_Hms().format(usage!.collectedAt!),
            ),
        ],
      ),
    );
  }
}

class _NodeHardwareCard extends StatelessWidget {
  const _NodeHardwareCard({required this.hardware});

  final NodeHardwareModel? hardware;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (hardware == null) {
      return _UnavailableCard(title: l10n.nodeDetailHardwareTitle);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.nodeDetailHardwareTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(label: l10n.nodeDetailCpuLabel, value: hardware!.cpuModel ?? '-'),
          _InfoRow(
            label: l10n.nodeDetailCoresLabel,
            value: '${hardware!.cpuCores ?? 0}/${hardware!.cpuThreads ?? 0}',
          ),
          _InfoRow(
            label: l10n.nodeDetailRamTotalLabel,
            value: '${hardware!.ramTotalMb ?? 0} MB',
          ),
          _InfoRow(label: l10n.nodeDetailKernelLabel, value: hardware!.kernel ?? '-'),
          _InfoRow(label: l10n.nodeDetailGpuLabel, value: hardware!.gpuModel ?? '-'),
          if (hardware!.scannedAt != null)
            _InfoRow(
              label: l10n.nodeDetailScannedAtLabel,
              value: DateFormat.yMd().add_Hms().format(hardware!.scannedAt!),
            ),
          if (hardware!.disks.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.nodeDetailDisksTitle,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...hardware!.disks.map(
              (disk) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        disk.name,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${disk.mount} • ${disk.totalGb} GB • ${disk.freeGb} GB free',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NodeServersCard extends StatelessWidget {
  const _NodeServersCard({required this.servers});

  final List<MinecraftServerModel> servers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.nodeDetailServersTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (servers.isEmpty)
            Text(
              l10n.nodeDetailNoServers,
              style: theme.textTheme.bodySmall,
            )
          else
            ...servers.map(
              (server) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.dns_outlined),
                title: Text(server.name),
                subtitle: Text(server.versionLabel),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ServerDetailScreen(server: server),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _UsageBar extends StatelessWidget {
  const _UsageBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${value.toStringAsFixed(1)}%'),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value / 100,
          color: color,
          minHeight: 8,
        ),
      ],
    );
  }
}

class _UnavailableCard extends StatelessWidget {
  const _UnavailableCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 12),
          Text(
            l10n.nodeDetailSectionUnavailable,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NodeErrorState extends StatelessWidget {
  const _NodeErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              l10n.nodeDetailLoadError,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
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
