import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/minecraft_server_model.dart';
import '../model/server_log_model.dart';
import '../repositories/console_repository.dart';
import '../services/api_exception.dart';
import 'app_dependencies.dart';

class ServerConsoleState {
  const ServerConsoleState({
    this.logs = const <ServerLogEntry>[],
    this.isLoading = false,
    this.isStreaming = false,
    this.isSendingCommand = false,
    this.errorMessage,
  });

  final List<ServerLogEntry> logs;
  final bool isLoading;
  final bool isStreaming;
  final bool isSendingCommand;
  final String? errorMessage;

  ServerConsoleState copyWith({
    List<ServerLogEntry>? logs,
    bool? isLoading,
    bool? isStreaming,
    bool? isSendingCommand,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ServerConsoleState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      isStreaming: isStreaming ?? this.isStreaming,
      isSendingCommand: isSendingCommand ?? this.isSendingCommand,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ServerLogsNotifier extends StateNotifier<ServerConsoleState> {
  ServerLogsNotifier(
    this._repository,
    this.serverId,
  ) : super(const ServerConsoleState()) {
    unawaited(initialize());
  }

  final ConsoleRepository _repository;
  final String serverId;

  ConsoleStreamConnection? _connection;
  StreamSubscription<ServerLogEntry>? _subscription;

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final logs = await _repository.fetchRecentLogs(serverId);
      state = state.copyWith(
        logs: logs,
        isLoading: false,
        clearErrorMessage: true,
      );
      await _startRealtime();
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _errorMessage(error),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final logs = await _repository.fetchRecentLogs(serverId);
      state = state.copyWith(
        logs: logs,
        isLoading: false,
        clearErrorMessage: true,
      );

      if (!state.isStreaming) {
        await _startRealtime();
      }
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _errorMessage(error),
      );
    }
  }

  Future<void> sendCommand(
    MinecraftServerModel server,
    String command,
  ) async {
    final trimmedCommand = command.trim();
    if (trimmedCommand.isEmpty) {
      return;
    }

    state = state.copyWith(
      isSendingCommand: true,
      clearErrorMessage: true,
    );

    try {
      final result = await _repository.sendCommand(server, trimmedCommand);
      final appendedLogs = <ServerLogEntry>[
        ...state.logs,
        ServerLogEntry.fromConsoleLine(line: '> $trimmedCommand'),
        ..._buildResponseLogs(result),
      ];

      state = state.copyWith(
        logs: _trimLogs(appendedLogs),
        isSendingCommand: false,
        clearErrorMessage: true,
      );
    } catch (error) {
      state = state.copyWith(
        isSendingCommand: false,
        errorMessage: _errorMessage(error),
      );
      rethrow;
    }
  }

  void clearLocalLogs() {
    state = state.copyWith(logs: const <ServerLogEntry>[]);
  }

  Future<void> disposeAsync() async {
    await _subscription?.cancel();
    await _connection?.dispose();

    try {
      await _repository.stopStreaming(serverId);
    } catch (_) {
      // Ignore cleanup failures during screen disposal.
    }
  }

  Future<void> _startRealtime() async {
    try {
      await _repository.startStreaming(serverId);

      _connection ??= _repository.createConnection(serverId);
      await _subscription?.cancel();
      _subscription = _connection!.stream.listen(
        (entry) {
          final nextLogs = _trimLogs(<ServerLogEntry>[
            ...state.logs,
            entry,
          ]);

          state = state.copyWith(
            logs: nextLogs,
            isStreaming: true,
            clearErrorMessage: true,
          );
        },
        onError: (Object error, StackTrace stackTrace) {
          state = state.copyWith(
            isStreaming: false,
            errorMessage: _errorMessage(error),
          );
        },
      );

      await _connection!.connect();
      state = state.copyWith(
        isStreaming: true,
        clearErrorMessage: true,
      );
    } catch (error) {
      state = state.copyWith(
        isStreaming: false,
        errorMessage: _errorMessage(error),
      );
    }
  }

  List<ServerLogEntry> _buildResponseLogs(ConsoleCommandResult result) {
    final response = result.responseMessage?.trim();
    if (response == null || response.isEmpty) {
      return const <ServerLogEntry>[];
    }

    final normalized = response.replaceAll('\r\n', '\n');
    final lines = normalized
        .split('\n')
        .map((line) => line.trimRight())
        .where((line) => line.isNotEmpty)
        .map(
          (line) => ServerLogEntry.fromConsoleLine(
            line: result.usedRcon ? '[RCON] $line' : line,
          ),
        )
        .toList(growable: false);

    return lines;
  }

  List<ServerLogEntry> _trimLogs(List<ServerLogEntry> logs) {
    if (logs.length <= 1000) {
      return logs;
    }

    return logs.sublist(logs.length - 1000);
  }

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return error.toString();
  }
}

final serverLogsProvider = StateNotifierProvider.autoDispose
    .family<ServerLogsNotifier, ServerConsoleState, String>((ref, serverId) {
  final notifier = ServerLogsNotifier(
    ref.watch(consoleRepositoryProvider),
    serverId,
  );

  ref.onDispose(() {
    unawaited(notifier.disposeAsync());
  });

  return notifier;
});
