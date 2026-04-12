import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

import '../../model/backup_model.dart';
import '../../model/minecraft_server_model.dart';
import '../../model/node_model.dart';
import '../../provider/app_dependencies.dart';
import '../../provider/backup_provider.dart';
import '../../services/api_exception.dart';

class BackupsScreen extends ConsumerStatefulWidget {
  const BackupsScreen({
    super.key,
    required this.server,
    required this.role,
  });

  final MinecraftServerModel server;
  final NodeRole? role;

  @override
  ConsumerState<BackupsScreen> createState() => _BackupsScreenState();
}

class _BackupsScreenState extends ConsumerState<BackupsScreen> {
  bool _isCreating = false;
  final Set<String> _busyBackups = <String>{};

  Future<void> _refresh() async {
    ref.invalidate(serverBackupsProvider(widget.server.id));
    await ref.read(serverBackupsProvider(widget.server.id).future);
  }

  Future<void> _createBackup() async {
    if (_isCreating) {
      return;
    }

    setState(() => _isCreating = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      await ref.read(backupRepositoryProvider).createBackup(widget.server.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupsCreateSuccess)),
      );
      await _refresh();
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  Future<void> _restoreBackup(BackupModel backup) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _showConfirmationDialog(
      title: l10n.backupsRestoreTitle,
      message: l10n.backupsRestoreConfirm,
    );
    if (!confirmed) {
      return;
    }

    await _runBusyAction(
      backup.id,
      () => ref.read(backupRepositoryProvider).restoreBackup(backup.id),
      l10n.backupsRestoreSuccess,
    );
  }

  Future<void> _deleteBackup(BackupModel backup) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _showConfirmationDialog(
      title: l10n.backupsDeleteTitle,
      message: l10n.backupsDeleteConfirm,
    );
    if (!confirmed) {
      return;
    }

    await _runBusyAction(
      backup.id,
      () => ref.read(backupRepositoryProvider).deleteBackup(backup.id),
      l10n.backupsDeleteSuccess,
    );
  }

  Future<void> _runBusyAction(
    String backupId,
    Future<void> Function() action,
    String successMessage,
  ) async {
    if (_busyBackups.contains(backupId)) {
      return;
    }

    setState(() => _busyBackups.add(backupId));

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
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _busyBackups.remove(backupId));
      }
    }
  }

  void _showError(Object error) {
    if (!mounted) {
      return;
    }

    final message = error is ApiException ? error.message : error.toString();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String message,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.confirmCommon),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backupsAsync = ref.watch(serverBackupsProvider(widget.server.id));
    final canCreate = widget.role?.canCreateBackup == true && widget.server.backupEnabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.serverBackupsTitle),
        actions: [
          if (canCreate)
            IconButton(
              onPressed: _isCreating ? null : _createBackup,
              icon: _isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add),
              tooltip: l10n.backupsCreateAction,
            ),
        ],
      ),
      body: backupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _BackupsErrorState(
          message: error.toString(),
          onRetry: _refresh,
        ),
        data: (backups) => RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (!widget.server.backupEnabled)
                _InfoBanner(message: l10n.backupsFeatureDisabledMessage),
              if (backups.isEmpty)
                _BackupsEmptyState(message: l10n.serverBackupsEmpty)
              else
                ...backups.map(
                  (backup) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _BackupCard(
                      backup: backup,
                      isBusy: _busyBackups.contains(backup.id),
                      canRestore: widget.role?.canRestoreBackup == true,
                      canDelete: widget.role?.canDeleteBackup == true,
                      onRestore: () => _restoreBackup(backup),
                      onDelete: () => _deleteBackup(backup),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackupCard extends StatelessWidget {
  const _BackupCard({
    required this.backup,
    required this.isBusy,
    required this.canRestore,
    required this.canDelete,
    required this.onRestore,
    required this.onDelete,
  });

  final BackupModel backup;
  final bool isBusy;
  final bool canRestore;
  final bool canDelete;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final formattedDate = backup.createdAt == null
        ? '-'
        : DateFormat.yMd().add_Hms().format(backup.createdAt!);

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
            backup.fileName,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(formattedDate, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            '${backup.backupType} • ${backup.sizeMb ?? 0} MB',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (canRestore)
                OutlinedButton.icon(
                  onPressed: isBusy ? null : onRestore,
                  icon: const Icon(Icons.restore),
                  label: Text(l10n.backupsRestoreTitle),
                ),
              if (canDelete)
                OutlinedButton.icon(
                  onPressed: isBusy ? null : onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.backupsDeleteTitle),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(message),
    );
  }
}

class _BackupsErrorState extends StatelessWidget {
  const _BackupsErrorState({
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
            const Icon(Icons.cloud_off_outlined, size: 56),
            const SizedBox(height: 16),
            Text(l10n.serverBackupsLoadError, textAlign: TextAlign.center),
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

class _BackupsEmptyState extends StatelessWidget {
  const _BackupsEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(message),
      ),
    );
  }
}
