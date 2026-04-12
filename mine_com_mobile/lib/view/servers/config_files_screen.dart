import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/minecraft_server_model.dart';
import '../../model/node_model.dart';
import '../../model/server_file_entry_model.dart';
import '../../provider/app_dependencies.dart';
import '../../services/api_exception.dart';

class ConfigFilesScreen extends ConsumerStatefulWidget {
  const ConfigFilesScreen({
    super.key,
    required this.server,
    required this.role,
  });

  final MinecraftServerModel server;
  final NodeRole? role;

  @override
  ConsumerState<ConfigFilesScreen> createState() => _ConfigFilesScreenState();
}

class _ConfigFilesScreenState extends ConsumerState<ConfigFilesScreen> {
  static const List<_CommonEntry> _commonEntries = <_CommonEntry>[
    _CommonEntry(path: '/server.properties', label: 'server.properties', warn: true),
    _CommonEntry(path: '/eula.txt', label: 'eula.txt', warn: true),
    _CommonEntry(path: '/ops.json', label: 'ops.json'),
    _CommonEntry(path: '/whitelist.json', label: 'whitelist.json'),
    _CommonEntry(path: '/banned-players.json', label: 'banned-players.json'),
    _CommonEntry(path: '/banned-ips.json', label: 'banned-ips.json'),
    _CommonEntry(path: '/paper-global.yml', label: 'paper-global.yml'),
    _CommonEntry(path: '/paper-world-defaults.yml', label: 'paper-world-defaults.yml'),
    _CommonEntry(path: '/spigot.yml', label: 'spigot.yml'),
    _CommonEntry(path: '/bukkit.yml', label: 'bukkit.yml'),
    _CommonEntry(path: '/config', label: 'config', isDirectory: true),
    _CommonEntry(path: '/plugins', label: 'plugins', isDirectory: true),
    _CommonEntry(path: '/defaultconfigs', label: 'defaultconfigs', isDirectory: true),
    _CommonEntry(path: '/mods', label: 'mods', isDirectory: true),
    _CommonEntry(path: '/world/serverconfig', label: 'serverconfig', isDirectory: true),
  ];

  String _currentDir = '/';
  bool _isLoading = false;
  String? _errorMessage;
  List<ServerFileEntryModel> _items = const <ServerFileEntryModel>[];

  bool get _canEdit => widget.role?.canEditConfigs == true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDirectory('/');
    });
  }

  Future<void> _loadDirectory(String path) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentDir = normalizeServerPath(path);
    });

    try {
      final items = await ref.read(fileSystemRepositoryProvider).listDirectory(
            widget.server.id,
            path: _currentDir,
          );

      final filtered = items
          .where((item) => !item.isHiddenNoise)
          .where((item) => item.isDirectory || item.isConfigLike)
          .toList()
        ..sort((a, b) {
          if (a.isDirectory != b.isDirectory) {
            return a.isDirectory ? -1 : 1;
          }
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

      if (!mounted) {
        return;
      }

      setState(() {
        _items = filtered;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _items = const <ServerFileEntryModel>[];
        _isLoading = false;
        _errorMessage = error is ApiException ? error.message : error.toString();
      });
    }
  }

  Future<void> _openFile(String path, {bool warn = false}) async {
    try {
      final content = await ref.read(fileSystemRepositoryProvider).readFile(
            widget.server.id,
            path: path,
          );

      if (!mounted) {
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => _ConfigEditorScreen(
            serverId: widget.server.id,
            path: path,
            initialContent: content,
            warn: warn,
            canEdit: _canEdit,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = error is ApiException ? error.message : error.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _goUp() async {
    if (_currentDir == '/') {
      return;
    }

    final segments = _currentDir.split('/').where((part) => part.isNotEmpty).toList();
    if (segments.isNotEmpty) {
      segments.removeLast();
    }
    final next = segments.isEmpty ? '/' : '/${segments.join('/')}';
    await _loadDirectory(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Конфиги сервера'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadDirectory(_currentDir),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            children: [
              Container(
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
                      _canEdit
                          ? 'Просмотр и редактирование доступны. Сохранение идёт через готовый серверный файловый API.'
                          : 'Просмотр доступен. Для сохранения нужна роль ADMIN, MANAGER или OWNER.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _commonEntries.map((entry) {
                        final isSelected = entry.isDirectory
                            ? normalizeServerPath(entry.path) == _currentDir
                            : false;
                        return ChoiceChip(
                          selected: isSelected,
                          label: Text(entry.label),
                          onSelected: (_) {
                            if (entry.isDirectory) {
                              _loadDirectory(entry.path);
                            } else {
                              _openFile(entry.path, warn: entry.warn);
                            }
                          },
                        );
                      }).toList(growable: false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
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
                        OutlinedButton.icon(
                          onPressed: _currentDir == '/' || _isLoading ? null : _goUp,
                          icon: const Icon(Icons.arrow_upward),
                          label: const Text('Вверх'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _currentDir,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_errorMessage != null)
                      _EmptyState(
                        icon: Icons.error_outline,
                        message: _errorMessage!,
                      )
                    else if (_items.isEmpty)
                      const _EmptyState(
                        icon: Icons.description_outlined,
                        message: 'В выбранной папке не найдено доступных конфигов. Попробуй common-пути выше или открой конкретный файл вроде server.properties.',
                      )
                    else
                      ..._items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                item.isDirectory
                                    ? Icons.folder_outlined
                                    : Icons.description_outlined,
                              ),
                              title: Text(item.name),
                              subtitle: item.lastModified == null ||
                                      item.lastModified!.isEmpty
                                  ? null
                                  : Text(item.lastModified!),
                              trailing: Icon(
                                item.isDirectory
                                    ? Icons.chevron_right
                                    : Icons.edit_note_outlined,
                              ),
                              onTap: () {
                                if (item.isDirectory) {
                                  _loadDirectory(item.path);
                                } else {
                                  final warn = item.name == 'server.properties' ||
                                      item.name == 'eula.txt';
                                  _openFile(item.path, warn: warn);
                                }
                              },
                            ),
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfigEditorScreen extends ConsumerStatefulWidget {
  const _ConfigEditorScreen({
    required this.serverId,
    required this.path,
    required this.initialContent,
    required this.warn,
    required this.canEdit,
  });

  final String serverId;
  final String path;
  final String initialContent;
  final bool warn;
  final bool canEdit;

  @override
  ConsumerState<_ConfigEditorScreen> createState() => _ConfigEditorScreenState();
}

class _ConfigEditorScreenState extends ConsumerState<_ConfigEditorScreen> {
  late final TextEditingController _controller;
  late String _originalContent;
  bool _isSaving = false;

  bool get _isDirty => _controller.text != _originalContent;

  @override
  void initState() {
    super.initState();
    _originalContent = widget.initialContent;
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!widget.canEdit || _isSaving) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(fileSystemRepositoryProvider).writeFile(
            widget.serverId,
            path: widget.path,
            content: _controller.text,
          );
      _originalContent = _controller.text;

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Файл сохранён')),
      );
      setState(() {});
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
        setState(() => _isSaving = false);
      }
    }
  }

  Future<bool> _confirmDiscard() async {
    if (!_isDirty) {
      return true;
    }

    final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Несохранённые изменения'),
              content: const Text('Изменения не сохранены. Выйти без сохранения?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Остаться'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Выйти'),
                ),
              ],
            );
          },
        ) ??
        false;

    return shouldLeave;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fileName = widget.path.split('/').where((e) => e.isNotEmpty).isEmpty
        ? widget.path
        : widget.path.split('/').where((e) => e.isNotEmpty).last;

    return WillPopScope(
      onWillPop: _confirmDiscard,
      child: Scaffold(
        appBar: AppBar(
          title: Text(fileName),
          actions: [
            if (_isDirty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Text(
                    'Изменено',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            if (widget.canEdit)
              IconButton(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                tooltip: 'Сохранить',
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (widget.warn)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.error.withOpacity(0.4),
                    ),
                  ),
                  child: const Text(
                    'Осторожно: это важный системный конфиг. Меняй его только если точно понимаешь последствия.',
                  ),
                ),
              if (!widget.canEdit)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: const Text(
                    'Файл открыт только для просмотра. Для изменения нужна роль ADMIN, MANAGER или OWNER.',
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: _controller,
                        readOnly: !widget.canEdit,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.45,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CommonEntry {
  const _CommonEntry({
    required this.path,
    required this.label,
    this.isDirectory = false,
    this.warn = false,
  });

  final String path;
  final String label;
  final bool isDirectory;
  final bool warn;
}
