class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const Duration requestTimeout = Duration(seconds: 15);
  static const Duration websocketConnectTimeout = Duration(seconds: 12);
  static const Duration websocketReconnectDelay = Duration(seconds: 5);
  static const int defaultConsoleLines = 200;
  static const int defaultMetricsHours = 24;
  static const int defaultMetricsPoints = 48;

  static String get normalizedApiBaseUrl {
    if (apiBaseUrl.endsWith('/')) {
      return apiBaseUrl.substring(0, apiBaseUrl.length - 1);
    }
    return apiBaseUrl;
  }

  static String get websocketEndpoint => '$normalizedApiBaseUrl/ws';
}
