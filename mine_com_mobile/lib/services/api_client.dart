import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/auth_session.dart';
import 'api_endpoints.dart';
import 'api_exception.dart';
import 'app_config.dart';
import 'auth_storage.dart';

class ApiClient {
  ApiClient({
    required http.Client httpClient,
    required AuthStorage storage,
  })  : _httpClient = httpClient,
        _storage = storage;

  final http.Client _httpClient;
  final AuthStorage _storage;

  Completer<bool>? _refreshCompleter;

  Future<dynamic> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool authenticated = true,
  }) {
    return _requestJson(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      authenticated: authenticated,
    );
  }

  Future<dynamic> postJson(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? body,
    bool authenticated = true,
  }) {
    return _requestJson(
      method: 'POST',
      path: path,
      queryParameters: queryParameters,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<dynamic> putJson(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? body,
    bool authenticated = true,
  }) {
    return _requestJson(
      method: 'PUT',
      path: path,
      queryParameters: queryParameters,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<dynamic> deleteJson(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? body,
    bool authenticated = true,
  }) {
    return _requestJson(
      method: 'DELETE',
      path: path,
      queryParameters: queryParameters,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<dynamic> _requestJson({
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    required bool authenticated,
  }) async {
    final response = await _performRequest(
      method: method,
      path: path,
      queryParameters: queryParameters,
      body: body,
      authenticated: authenticated,
    );

    if (response.statusCode == 204 || response.body.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(response.body);
    } on FormatException {
      return response.body;
    }
  }

  Future<http.Response> _performRequest({
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    required bool authenticated,
    bool retryOnUnauthorized = true,
  }) async {
    final token =
        authenticated ? await _storage.readAccessToken() : null;
    final response = await _send(
      method: method,
      path: path,
      queryParameters: queryParameters,
      body: body,
      accessToken: token,
    );

    if (response.statusCode == 401 && authenticated && retryOnUnauthorized) {
      final refreshed = await _refreshSession();
      if (refreshed) {
        return _performRequest(
          method: method,
          path: path,
          queryParameters: queryParameters,
          body: body,
          authenticated: authenticated,
          retryOnUnauthorized: false,
        );
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }

    throw _buildException(response);
  }

  Future<http.Response> _send({
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Object? body,
    String? accessToken,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final request = http.Request(method, uri);
    request.headers['Accept'] = 'application/json';

    if (accessToken != null && accessToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    _logRequest(method, uri, body);

    try {
      final streamedResponse = await _httpClient
          .send(request)
          .timeout(AppConfig.requestTimeout);
      final response = await http.Response.fromStream(streamedResponse);
      _logResponse(method, uri, response);
      return response;
    } on TimeoutException {
      throw const ApiException(
        message: 'Request timed out. Please try again.',
        isNetworkError: true,
      );
    } on SocketException {
      throw const ApiException(
        message: 'Could not reach the server. Check your connection.',
        isNetworkError: true,
      );
    } on http.ClientException catch (error) {
      throw ApiException(
        message: error.message,
        isNetworkError: true,
      );
    }
  }

  Uri _buildUri(String path, Map<String, dynamic>? queryParameters) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final baseUri =
        Uri.parse('${AppConfig.normalizedApiBaseUrl}$normalizedPath');

    if (queryParameters == null || queryParameters.isEmpty) {
      return baseUri;
    }

    final preparedQuery = <String, String>{};
    for (final entry in queryParameters.entries) {
      if (entry.value == null) {
        continue;
      }
      preparedQuery[entry.key] = entry.value.toString();
    }

    return baseUri.replace(queryParameters: preparedQuery);
  }

  Future<bool> _refreshSession() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    try {
      final currentSession = await _storage.readSession();
      final refreshToken = currentSession?.refreshToken;

      if (refreshToken == null || refreshToken.isEmpty) {
        await _storage.clearSession();
        completer.complete(false);
        return completer.future;
      }

      final response = await _send(
        method: 'POST',
        path: ApiEndpoints.authRefresh,
        body: <String, dynamic>{'refreshToken': refreshToken},
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        await _storage.clearSession();
        completer.complete(false);
        return completer.future;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final nextSession = AuthSession.fromJson(json);
      await _storage.saveSession(nextSession);
      completer.complete(true);
      return completer.future;
    } catch (_) {
      await _storage.clearSession();
      completer.complete(false);
      return completer.future;
    } finally {
      _refreshCompleter = null;
    }
  }

  ApiException _buildException(http.Response response) {
    String? message;
    String? error;

    if (response.body.isNotEmpty) {
      try {
        final json = jsonDecode(response.body);
        if (json is Map<String, dynamic>) {
          message = json['message'] as String?;
          error = json['error'] as String?;
        }
      } on FormatException {
        message = response.body;
      }
    }

    return ApiException(
      statusCode: response.statusCode,
      error: error,
      message: message ?? response.reasonPhrase ?? 'Unknown server error',
    );
  }

  void _logRequest(String method, Uri uri, Object? body) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[API] $method $uri');
    if (body != null) {
      debugPrint('[API] body: ${jsonEncode(body)}');
    }
  }

  void _logResponse(String method, Uri uri, http.Response response) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[API] $method $uri -> ${response.statusCode}');
  }
}
