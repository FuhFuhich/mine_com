import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../model/minecraft_server_model.dart';
import '../model/server_log_model.dart';
import '../services/api_client.dart';
import '../services/api_endpoints.dart';
import '../services/api_exception.dart';
import '../services/app_config.dart';
import '../services/auth_storage.dart';

class ConsoleCommandResult {
  const ConsoleCommandResult({
    required this.usedRcon,
    this.responseMessage,
  });

  final bool usedRcon;
  final String? responseMessage;
}

class ConsoleRepository {
  const ConsoleRepository({
    required ApiClient apiClient,
    required AuthStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final ApiClient _apiClient;
  final AuthStorage _storage;

  Future<List<ServerLogEntry>> fetchRecentLogs(
    String serverId, {
    int lines = AppConfig.defaultConsoleLines,
    int offset = 0,
  }) async {
    final json = await _apiClient.getJson(
      ApiEndpoints.consoleLogs(serverId),
      queryParameters: <String, dynamic>{
        'lines': lines,
        'offset': offset,
      },
    ) as List<dynamic>;

    return json
        .map((entry) => ServerLogEntry.fromConsoleLine(
              line: entry.toString(),
            ))
        .toList(growable: false);
  }

  Future<void> startStreaming(String serverId) async {
    await _apiClient.postJson(ApiEndpoints.consoleStart(serverId));
  }

  Future<void> stopStreaming(String serverId) async {
    await _apiClient.postJson(ApiEndpoints.consoleStop(serverId));
  }

  Future<ConsoleCommandResult> sendCommand(
    MinecraftServerModel server,
    String command,
  ) async {
    if (!server.canAcceptConsoleCommands) {
      throw const ApiException(
        message: 'RCON is disabled for this Docker server.',
      );
    }

    if (server.isDockerDeploy) {
      return _sendDockerRconCommand(server.id, command);
    }

    await _apiClient.postJson(
      ApiEndpoints.consoleCommand(server.id),
      body: <String, dynamic>{'command': command},
    );

    return const ConsoleCommandResult(usedRcon: false);
  }

  Future<ConsoleCommandResult> _sendDockerRconCommand(
    String serverId,
    String command,
  ) async {
    final json = await _apiClient.postJson(
      ApiEndpoints.mcServerRcon(serverId),
      body: <String, dynamic>{'command': command},
    );

    if (json is! Map<String, dynamic>) {
      throw const ApiException(message: 'Invalid RCON response from server');
    }

    final success = json['success'] as bool? ?? false;
    final error = json['error']?.toString();
    final response = json['response']?.toString();

    if (!success) {
      throw ApiException(
        message: error?.isNotEmpty == true ? error! : 'RCON command failed',
      );
    }

    return ConsoleCommandResult(
      usedRcon: true,
      responseMessage: response,
    );
  }

  ConsoleStreamConnection createConnection(String serverId) {
    return ConsoleStreamConnection(
      serverId: serverId,
      storage: _storage,
    );
  }
}

class ConsoleStreamConnection {
  ConsoleStreamConnection({
    required String serverId,
    required AuthStorage storage,
  })  : _serverId = serverId,
        _storage = storage;

  final String _serverId;
  final AuthStorage _storage;
  final StreamController<ServerLogEntry> _controller =
      StreamController<ServerLogEntry>.broadcast();
  final Map<String, String> _stompHeaders = <String, String>{};
  final Map<String, dynamic> _webSocketHeaders = <String, dynamic>{};

  StompClient? _client;
  bool _isStarted = false;

  Stream<ServerLogEntry> get stream => _controller.stream;

  Future<void> connect() async {
    if (_isStarted) {
      return;
    }

    _isStarted = true;
    final completer = Completer<void>();

    _client = StompClient(
      config: StompConfig.sockJS(
        url: AppConfig.websocketEndpoint,
        reconnectDelay: AppConfig.websocketReconnectDelay,
        connectionTimeout: AppConfig.websocketConnectTimeout,
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
        stompConnectHeaders: _stompHeaders,
        webSocketConnectHeaders: _webSocketHeaders,
        beforeConnect: () async {
          final accessToken = await _storage.readAccessToken();
          if (accessToken == null || accessToken.isEmpty) {
            throw const ApiException(message: 'Session expired');
          }

          final authHeader = 'Bearer $accessToken';
          _stompHeaders
            ..clear()
            ..addAll(<String, String>{'Authorization': authHeader});
          _webSocketHeaders
            ..clear()
            ..addAll(<String, dynamic>{'Authorization': authHeader});
        },
        onConnect: (frame) {
          _client?.subscribe(
            destination: ApiEndpoints.consoleTopic(_serverId),
            callback: _handleFrame,
          );

          if (!completer.isCompleted) {
            completer.complete();
          }
        },
        onStompError: (frame) {
          final error = ApiException(
            message: frame.body?.isNotEmpty == true
                ? frame.body!
                : 'Console stream error',
          );
          if (!_controller.isClosed) {
            _controller.addError(error);
          }
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
        onWebSocketError: (error) {
          const exception = ApiException(
            message: 'Console connection failed',
            isNetworkError: true,
          );
          if (!_controller.isClosed) {
            _controller.addError(exception);
          }
          if (!completer.isCompleted) {
            completer.completeError(exception);
          }
        },
        onDebugMessage: (message) {
          if (kDebugMode) {
            debugPrint('[WS] $message');
          }
        },
      ),
    )..activate();

    try {
      return await completer.future.timeout(
        AppConfig.websocketConnectTimeout,
        onTimeout: () {
          const error = ApiException(
            message: 'Console connection timed out',
            isNetworkError: true,
          );
          if (!_controller.isClosed) {
            _controller.addError(error);
          }
          throw error;
        },
      );
    } catch (error) {
      _isStarted = false;
      _client?.deactivate();
      _client = null;
      rethrow;
    }
  }

  void _handleFrame(StompFrame frame) {
    final body = frame.body;
    if (body == null || body.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final line = decoded['line']?.toString() ?? '';
        if (line.isEmpty) {
          return;
        }

        _controller.add(
          ServerLogEntry.fromConsoleLine(
            line: line,
            timestamp: DateTime.tryParse(decoded['ts']?.toString() ?? ''),
          ),
        );
        return;
      }

      if (decoded is String) {
        _controller.add(ServerLogEntry.fromConsoleLine(line: decoded));
        return;
      }
    } catch (_) {
      // Fall back to the raw STOMP body below.
    }

    _controller.add(ServerLogEntry.fromConsoleLine(line: body));
  }

  Future<void> dispose() async {
    _client?.deactivate();
    if (!_controller.isClosed) {
      await _controller.close();
    }
  }
}
