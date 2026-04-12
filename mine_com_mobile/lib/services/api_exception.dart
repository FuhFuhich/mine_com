class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.error,
    this.isNetworkError = false,
  });

  final String message;
  final int? statusCode;
  final String? error;
  final bool isNetworkError;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;

  @override
  String toString() => 'ApiException($statusCode, $message)';
}
