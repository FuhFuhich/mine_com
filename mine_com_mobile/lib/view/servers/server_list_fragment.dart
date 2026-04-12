import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

import '../../model/minecraft_server_model.dart';
import '../../model/node_model.dart';
import '../../provider/app_dependencies.dart';
import '../../provider/minecraft_server_provider.dart';
import '../../services/api_exception.dart';
import 'node_detail_screen.dart';
import 'server_detail_screen.dart';

class ServerListWrapper extends ConsumerStatefulWidget {
  const ServerListWrapper({super.key});

  @override
  ConsumerState<ServerListWrapper> createState() => _ServerListWrapperState();
}

class _ServerListWrapperState extends ConsumerState<ServerListWrapper> {
  final Set<String> _pendingServerActions = <String>{};

  Future<void> _refresh() async {
    ref.invalidate(serverListPageProvider);
    await ref.read(serverListPageProvider.future);
  }

  Future<void> _runServerAction({
    required String serverId,
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    if (_pendingServerActions.contains(serverId)) {
      return;
    }

    setState(() => _pendingServerActions.add(serverId));

    try {
      await action();
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
      ref.invalidate(serverListPageProvider);
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
        setState(() => _pendingServerActions.remove(serverId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageAsync = ref.watch(serverListPageProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.serversMainMenu),

      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: pageAsync.when(
          loading: () => const _LoadingState(),
          error: (error, stackTrace) => _ErrorState(
            message: error.toString(),
            onRetry: _refresh,
          ),
          data: (page) {
            final filteredServers = page.servers;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (page.nodes.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _NodeSection(
                      nodes: page.nodes,
                      servers: page.servers,
                    ),
                  ),
                if (page.nodes.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: _EmptyNodesCard(theme: theme, l10n: l10n),
                    ),
                  ),
                if (filteredServers.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyServersState(
                      query: '',
                      l10n: l10n,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList.separated(
                      itemCount: filteredServers.length,
                      itemBuilder: (context, index) {
                        final server = filteredServers[index];
                        final role = page.roleForServer(server);
                        final isBusy =
                            _pendingServerActions.contains(server.id);

                        return _ServerCard(
                          server: server,
                          role: role,
                          isBusy: isBusy,
                          onOpen: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ServerDetailScreen(server: server),
                              ),
                            );
                          },
                          onStart: role?.canManageServerLifecycle == true
                              ? () => _runServerAction(
                                    serverId: server.id,
                                    action: () => ref
                                        .read(minecraftServerRepositoryProvider)
                                        .startServer(server.id),
                                    successMessage:
                                        l10n.serverActionStartedMessage,
                                  )
                              : null,
                          onStop: role?.canManageServerLifecycle == true
                              ? () => _runServerAction(
                                    serverId: server.id,
                                    action: () => ref
                                        .read(minecraftServerRepositoryProvider)
                                        .stopServer(server.id),
                                    successMessage:
                                        l10n.serverActionStoppedMessage,
                                  )
                              : null,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(
          height: 360,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 360,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 56),
                  const SizedBox(height: 16),
                  Text(
                    l10n.serverListLoadError,
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
          ),
        ),
      ],
    );
  }
}

class _NodeSection extends StatelessWidget {
  const _NodeSection({
    required this.nodes,
    required this.servers,
  });

  final List<NodeModel> nodes;
  final List<MinecraftServerModel> servers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.serverListNodesSectionTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 148,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: nodes.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final node = nodes[index];
                final serversCount =
                    servers.where((server) => server.nodeId == node.id).length;

                return SizedBox(
                  width: 210,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NodeDetailScreen(nodeId: node.id),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
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
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00E676).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.hub_outlined,
                                  color: Color(0xFF00E676),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  node.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _NodeInfoRow(
                            label: l10n.serverListNodeRoleLabel,
                            value: node.role.name.toUpperCase(),
                          ),
                          const SizedBox(height: 8),
                          _NodeInfoRow(
                            label: l10n.serverListNodeAddressLabel,
                            value: node.ipAddress,
                          ),
                          const SizedBox(height: 6),
                          _NodeInfoRow(
                            label: l10n.serverListNodeServersLabel,
                            value: serversCount.toString(),
                          ),
                        ],
                      ),
                    ),
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

class _NodeInfoRow extends StatelessWidget {
  const _NodeInfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyNodesCard extends StatelessWidget {
  const _EmptyNodesCard({
    required this.theme,
    required this.l10n,
  });

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Text(
        l10n.serverListNoNodes,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class _EmptyServersState extends StatelessWidget {
  const _EmptyServersState({
    required this.query,
    required this.l10n,
  });

  final String query;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dns_outlined,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.35),
            ),
            const SizedBox(height: 16),
            Text(
              query.isEmpty
                  ? l10n.noServersServerList
                  : l10n.noServersFoundServerList,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              query.isEmpty
                  ? l10n.serverListEmptyDescription
                  : l10n.tryChangingYourQueryServerList,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerCard extends StatelessWidget {
  const _ServerCard({
    required this.server,
    required this.role,
    required this.isBusy,
    required this.onOpen,
    required this.onStart,
    required this.onStop,
  });

  final MinecraftServerModel server;
  final NodeRole? role;
  final bool isBusy;
  final VoidCallback onOpen;
  final VoidCallback? onStart;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final statusColor = _statusColor(theme, server.normalizedStatus);
    final canManage = role?.canManageServerLifecycle == true;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onOpen,
      child: Container(
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
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    server.isOnline ? Icons.dns : Icons.dns_outlined,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        server.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        server.nodeName,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _StatusBadge(
                  color: statusColor,
                  label: _statusLabel(l10n, server.normalizedStatus),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(label: server.versionLabel),
                _InfoChip(label: server.deployTarget),
                if (server.gamePort != null)
                  _InfoChip(label: 'Port ${server.gamePort}'),
                if (server.cpuCores != null)
                  _InfoChip(label: '${server.cpuCores} CPU'),
                if (server.ramMb != null)
                  _InfoChip(label: '${server.ramMb} MB RAM'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    role == null
                        ? l10n.serverListReadOnlyRole
                        : '${l10n.serverListNodeRoleLabel}: ${role!.name.toUpperCase()}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ],
            ),
            if (canManage) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.play_arrow,
                      label: l10n.launchServerList,
                      color: Colors.green,
                      isBusy: isBusy,
                      onTap: onStart,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.stop,
                      label: l10n.stopServerList,
                      color: Colors.red,
                      isBusy: isBusy,
                      onTap: onStop,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
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

  Color _statusColor(ThemeData theme, String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'starting':
      case 'restarting':
      case 'deploying':
        return Colors.orange;
      case 'error':
      case 'crashed':
        return theme.colorScheme.error;
      case 'undeployed':
        return Colors.blueGrey;
      case 'stopping':
        return Colors.deepOrange;
      case 'offline':
      default:
        return theme.colorScheme.onSurface.withOpacity(0.65);
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isBusy,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isBusy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isBusy ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            isBusy
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  )
                : Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
