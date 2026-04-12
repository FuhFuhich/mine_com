import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

import '../../model/minecraft_server_model.dart';
import '../../model/node_model.dart';
import '../../provider/server_logs_provider.dart';

class ServerConsoleScreen extends ConsumerStatefulWidget {
  const ServerConsoleScreen({
    super.key,
    required this.server,
    required this.role,
  });

  final MinecraftServerModel server;
  final NodeRole? role;

  @override
  ConsumerState<ServerConsoleScreen> createState() => _ServerConsoleScreenState();
}

class _ServerConsoleScreenState extends ConsumerState<ServerConsoleScreen> {
  final TextEditingController _commandController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commandController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendCommand() async {
    final command = _commandController.text.trim();
    if (command.isEmpty) {
      return;
    }

    await ref
        .read(serverLogsProvider(widget.server.id).notifier)
        .sendCommand(widget.server, command);
    _commandController.clear();
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final consoleState = ref.watch(serverLogsProvider(widget.server.id));
    final canSendCommands =
        widget.role?.canSendConsoleCommand == true &&
        widget.server.canAcceptConsoleCommands;
    final commandHint = widget.server.isDockerDeploy && widget.server.rconEnabled
        ? '${l10n.serverConsoleCommandHint} (RCON)'
        : l10n.serverConsoleCommandHint;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.server.name} - ${l10n.serverConsoleServerDetail}'),
      ),
      body: Column(
        children: [
          if (widget.server.isDockerDeploy && widget.server.rconEnabled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Text(
                'Обнаружен Docker-сервер: команды отправляются через RCON.',
              ),
            ),
          if (widget.server.isDockerDeploy && !widget.server.rconEnabled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Theme.of(context).colorScheme.errorContainer,
              child: const Text(
                'Обнаружен Docker-сервер, но RCON выключен. Отправка команд недоступна.',
              ),
            ),
          if (consoleState.errorMessage != null)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.errorContainer,
              padding: const EdgeInsets.all(12),
              child: Text(consoleState.errorMessage!),
            ),
          Expanded(
            child: Container(
              color: const Color(0xFF1E1E1E),
              child: consoleState.isLoading && consoleState.logs.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: consoleState.logs.length,
                      itemBuilder: (context, index) {
                        final log = consoleState.logs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '[${log.formattedTime}] ${log.message}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          if (canSendCommands)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commandController,
                        onSubmitted: (_) => _sendCommand(),
                        decoration: InputDecoration(
                          hintText: commandHint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed:
                          consoleState.isSendingCommand ? null : _sendCommand,
                      child: consoleState.isSendingCommand
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            )
          else
            SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Theme.of(context).cardColor,
                child: Text(
                  l10n.serverConsoleReadOnlyMessage,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
