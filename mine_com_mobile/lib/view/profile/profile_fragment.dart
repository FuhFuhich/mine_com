import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

import '../../model/dashboard_model.dart';
import '../../model/user_model.dart';
import '../../provider/profile_provider.dart';

class ProfileFragment extends ConsumerWidget {
  const ProfileFragment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileMainMenu),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildErrorState(
          context,
          ref,
          theme,
          error.toString(),
          l10n,
        ),
        data: (profile) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(profileProvider);
            await ref.read(profileProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileHeader(theme, profile.user, l10n),
              const SizedBox(height: 24),
              _buildStatsCards(theme, profile.dashboard, l10n),
              const SizedBox(height: 24),
              _buildOverviewSection(theme, profile.dashboard, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    ThemeData theme,
    UserModel user,
    AppLocalizations l10n,
  ) {
    final joinDate = user.createdAt == null
        ? null
        : DateFormat.yMMMd().format(user.createdAt!);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00E676).withOpacity(0.3),
                      const Color(0xFF00E676).withOpacity(0.1),
                    ],
                  ),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.person, size: 50),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.cardColor,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.verified,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          if (joinDate != null) ...[
            const SizedBox(height: 8),
            Text(
              '${l10n.profileJoinedLabel}: $joinDate',
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00E676).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00E676).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 16,
                  color: Color(0xFF00E676),
                ),
                const SizedBox(width: 6),
                Text(
                  user.role.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF00E676),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(
    ThemeData theme,
    DashboardModel dashboard,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            theme,
            Icons.dns_rounded,
            dashboard.totalMcServers.toString(),
            l10n.totalServersProfile,
            const Color(0xFF2196F3),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            theme,
            Icons.power_settings_new,
            dashboard.onlineMcServers.toString(),
            l10n.onlineProfile,
            const Color(0xFF00E676),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            theme,
            Icons.people,
            dashboard.playersOnline.toString(),
            l10n.playersProfile,
            const Color(0xFFFF9800),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(
    ThemeData theme,
    DashboardModel dashboard,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Color(0xFF00E676),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.serverOverviewProfile,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildOverviewItem(
            theme,
            Icons.hub_outlined,
            l10n.profileNodesLabel,
            '${dashboard.onlineNodes}/${dashboard.totalNodes}',
            const Color(0xFF03A9F4),
          ),
          const SizedBox(height: 16),
          _buildOverviewItem(
            theme,
            Icons.memory,
            l10n.averageCpuLoadProfile,
            '${dashboard.avgCpuPercent.toStringAsFixed(1)}%',
            dashboard.avgCpuPercent > 70
                ? const Color(0xFFFF5252)
                : const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 16),
          _buildOverviewItem(
            theme,
            Icons.storage,
            l10n.averageRamLoadProfile,
            '${dashboard.avgRamPercent.toStringAsFixed(1)}%',
            dashboard.avgRamPercent > 70
                ? const Color(0xFFFF5252)
                : const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 16),
          _buildOverviewItem(
            theme,
            Icons.pie_chart_outline,
            l10n.profileDiskLabel,
            '${dashboard.avgDiskPercent.toStringAsFixed(1)}%',
            dashboard.avgDiskPercent > 80
                ? const Color(0xFFFF5252)
                : const Color(0xFFFF9800),
          ),
          const SizedBox(height: 16),
          Divider(color: theme.dividerColor),
          const SizedBox(height: 16),
          _buildOverviewItem(
            theme,
            Icons.backup_outlined,
            l10n.profileBackupsLabel,
            dashboard.totalBackups.toString(),
            const Color(0xFFFFC107),
          ),
          const SizedBox(height: 16),
          _buildOverviewItem(
            theme,
            Icons.warning_amber_rounded,
            l10n.profileCrashesLabel,
            dashboard.crashesLast24h.toString(),
            dashboard.crashesLast24h > 0
                ? const Color(0xFFFF5252)
                : const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    String message,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.profileLoadError,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(profileProvider),
              child: Text(l10n.retryCommon),
            ),
          ],
        ),
      ),
    );
  }
}
