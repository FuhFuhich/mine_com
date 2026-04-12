import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/settings_provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/language_provider.dart';
import 'language_picker_fragment.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

class SettingsFragment extends ConsumerWidget {
  const SettingsFragment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final notificationsEnabled = ref.watch(notificationsProvider);
    final darkThemeEnabled = ref.watch(darkThemeProvider);
    const appVersion = '1.0.0';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(theme, l10n.appearance),
          _buildAppearanceSection(theme, context, ref, darkThemeEnabled, l10n),
          const SizedBox(height: 16),

          _buildSectionTitle(theme, l10n.notifications),
          _buildNotificationsSection(theme, context, ref, notificationsEnabled, l10n),
          const SizedBox(height: 16),

          _buildSectionTitle(theme, l10n.aboutApp),
          _buildAboutSection(theme, context, appVersion, l10n),
          const SizedBox(height: 16),

          _buildSectionTitle(theme, l10n.account),
          _buildAccountSection(theme, context, ref, l10n),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(
    ThemeData theme,
    BuildContext context,
    WidgetRef ref,
    bool darkThemeEnabled,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            theme,
            icon: Icons.dark_mode_outlined,
            title: l10n.darkTheme,
            subtitle: l10n.darkThemeSubtitle,
            value: darkThemeEnabled,
            onChanged: (val) => ref.read(darkThemeProvider.notifier).toggle(val),
          ),
          Divider(height: 1, color: theme.dividerColor),
          Consumer(
            builder: (context, ref, _) {
              final locale = ref.watch(localeProvider);
              final langName = localeNames[locale.languageCode] ?? locale.languageCode;
              return _buildListTile(
                theme,
                icon: Icons.language,
                title: l10n.language,
                subtitle: langName,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguagePickerFragment()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(
    ThemeData theme,
    BuildContext context,
    WidgetRef ref,
    bool notificationsEnabled,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: _buildSwitchTile(
        theme,
        icon: Icons.notifications_outlined,
        title: l10n.notifications,
        subtitle: l10n.notificationsSubtitle,
        value: notificationsEnabled,
        onChanged: (val) => ref.read(notificationsProvider.notifier).toggle(val),
      ),
    );
  }

  Widget _buildAboutSection(
    ThemeData theme,
    BuildContext context,
    String version,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          _buildListTile(
            theme,
            icon: Icons.info_outline,
            title: l10n.aboutApp,
            subtitle: '${l10n.version} $version',
            onTap: () => _showAboutDialog(context, theme, version, l10n),
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildListTile(
            theme,
            icon: Icons.help_outline,
            title: l10n.helpSupport,
            subtitle: l10n.helpSupportSubtitle,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.helpSupport)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(
    ThemeData theme,
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          _buildListTile(
            theme,
            icon: Icons.security_outlined,
            title: l10n.security,
            subtitle: l10n.securitySubtitle,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.security)),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildListTile(
            theme,
            icon: Icons.logout,
            iconColor: Colors.red,
            title: l10n.logout,
            titleColor: Colors.red,
            onTap: () => _showLogoutDialog(context, ref, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF00E676).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF00E676), size: 24),
      ),
      title: Text(title, style: theme.textTheme.titleSmall),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  Widget _buildListTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool showArrow = true,
    Color? iconColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? const Color(0xFF00E676)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? const Color(0xFF00E676), size: 24),
      ),
      title: Text(title, style: theme.textTheme.titleSmall?.copyWith(color: titleColor)),
      subtitle: subtitle != null
          ? Text(subtitle, style: theme.textTheme.bodySmall)
          : null,
      trailing: trailing ?? (showArrow ? const Icon(Icons.arrow_forward_ios, size: 16) : null),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(
    BuildContext context,
    ThemeData theme,
    String version,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF00E676).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.dns_rounded, color: Color(0xFF00E676), size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.aboutApp)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.appDescription,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(l10n.version, version),
              _buildInfoRow(l10n.platform, l10n.platformValue),
              _buildInfoRow(l10n.developer, l10n.developerValue),
              const SizedBox(height: 16),
              Text(l10n.featuresTitle, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              _buildFeatureItem(l10n.featureSsh),
              _buildFeatureItem(l10n.featureMonitoring),
              _buildFeatureItem(l10n.featureLogs),
              _buildFeatureItem(l10n.featureAutomation),
              _buildFeatureItem(l10n.featureBackups),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
