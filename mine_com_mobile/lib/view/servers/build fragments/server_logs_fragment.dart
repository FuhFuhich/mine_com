import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

import '../../../model/minecraft_server_model.dart';
import '../../../model/server_log_model.dart';
import '../../../provider/server_logs_provider.dart';

class ServerLogsFragment extends ConsumerStatefulWidget {
  const ServerLogsFragment({
    super.key,
    required this.server,
  });

  final MinecraftServerModel server;

  @override
  ConsumerState<ServerLogsFragment> createState() => _ServerLogsFragmentState();
}

class _ServerLogsFragmentState extends ConsumerState<ServerLogsFragment> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final Set<LogLevel> _selectedLevels = LogLevel.values.toSet();
  String _searchQuery = '';
  bool _autoScroll = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref.read(serverLogsProvider(widget.server.id).notifier).refresh();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  List<ServerLogEntry> _filterLogs(List<ServerLogEntry> logs) {
    return logs.where((log) {
      final levelMatch = _selectedLevels.contains(log.level);
      final searchMatch = _searchQuery.isEmpty ||
          log.message.toLowerCase().contains(_searchQuery) ||
          (log.source?.toLowerCase().contains(_searchQuery) ?? false);
      return levelMatch && searchMatch;
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final consoleState = ref.watch(serverLogsProvider(widget.server.id));
    final filteredLogs = _filterLogs(consoleState.logs);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.server.name} - ${l10n.logsServerLogs}'),
        actions: [
          IconButton(
            icon: Icon(
              _autoScroll ? Icons.arrow_downward : Icons.arrow_downward_outlined,
            ),
            onPressed: () {
              setState(() => _autoScroll = !_autoScroll);
              if (_autoScroll) {
                _scrollToBottom();
              }
            },
            tooltip: _autoScroll
                ? l10n.autoscrollIsEnabledServerLogs
                : l10n.autoscrollIsDisabledServerLogs,
          ),

        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(theme, l10n),
          _buildFilterChips(theme),
          if (consoleState.errorMessage != null)
            _ErrorBanner(message: consoleState.errorMessage!),
          _buildLogsInfo(
            theme,
            filteredLogs.length,
            consoleState.logs.length,
            consoleState.isStreaming,
            l10n,
          ),
          Expanded(
            child: _buildLogsList(
              theme,
              filteredLogs,
              consoleState.isLoading,
              l10n,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: l10n.searchInLogsServerLogs,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _searchController.clear,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: LogLevel.values.map((level) {
            final isSelected = _selectedLevels.contains(level);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(_getLevelName(level)),
                avatar: Icon(
                  _getLevelIcon(level),
                  size: 16,
                  color: isSelected ? Colors.white : _getLevelColor(level),
                ),
                selectedColor: _getLevelColor(level),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedLevels.add(level);
                    } else {
                      _selectedLevels.remove(level);
                    }
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLogsInfo(
    ThemeData theme,
    int filtered,
    int total,
    bool isStreaming,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          Icon(
            isStreaming ? Icons.wifi_tethering : Icons.info_outline,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isStreaming
                  ? '${l10n.logsLiveStatus}: $filtered/$total'
                  : '${l10n.shownServerLogs} $filtered ${l10n.fromServerLogs} $total ${l10n.recordsServerLogs}',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList(
    ThemeData theme,
    List<ServerLogEntry> logs,
    bool isLoading,
    AppLocalizations l10n,
  ) {
    if (logs.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (logs.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isNotEmpty
              ? l10n.noResultsFoundServerLogs
              : l10n.noLogsToDisplayServerLogs,
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_autoScroll && _scrollController.hasClients) {
        _scrollToBottom();
      }
    });

    return Container(
      color: const Color(0xFF1E1E1E),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return _buildLogEntry(
            log.formattedTime,
            log.level,
            log.source,
            log.message,
            log.timestamp,
          );
        },
      ),
    );
  }

  Widget _buildLogEntry(
    String formattedTime,
    LogLevel level,
    String? source,
    String message,
    DateTime timestamp,
  ) {
    final levelColor = _getLevelColor(level);

    return InkWell(
      onLongPress: () => _showLogDetails(
        formattedTime,
        level,
        source,
        message,
        timestamp,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border(left: BorderSide(color: levelColor, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: levelColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(_getLevelIcon(level), size: 14, color: levelColor),
                const SizedBox(width: 4),
                Text(
                  _getLevelName(level).toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: levelColor,
                  ),
                ),
                if (source != null) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '[$source]',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'monospace',
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogDetails(
    String formattedTime,
    LogLevel level,
    String? source,
    String message,
    DateTime timestamp,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getLevelIcon(level), color: _getLevelColor(level)),
            const SizedBox(width: 8),
            Text(_getLevelName(level).toUpperCase()),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(l10n.timeServerLogs, timestamp.toString()),
              if (source != null) _buildDetailRow(l10n.sourceServerLogs, source),
              const SizedBox(height: 12),
              Text(
                l10n.messageServerLogs,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SelectableText(
                message,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.copiedToClipboardServerLogs)),
              );
            },
            icon: const Icon(Icons.copy),
            label: Text(l10n.copyToClipboardServerLogs),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.closeServerLogs),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getLevelName(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return 'Info';
      case LogLevel.warn:
        return 'Warn';
      case LogLevel.error:
        return 'Error';
      case LogLevel.debug:
        return 'Debug';
      case LogLevel.fatal:
        return 'Fatal';
    }
  }

  IconData _getLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return Icons.info_outline;
      case LogLevel.warn:
        return Icons.warning_amber;
      case LogLevel.error:
        return Icons.error_outline;
      case LogLevel.debug:
        return Icons.bug_report;
      case LogLevel.fatal:
        return Icons.dangerous;
    }
  }

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return Colors.blue;
      case LogLevel.warn:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.debug:
        return Colors.purple;
      case LogLevel.fatal:
        return Colors.red.shade900;
    }
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
