enum LogLevel {
  info,
  warn,
  error,
  debug,
  fatal,
}

class ServerLogEntry {
  final String id;
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? source;

  ServerLogEntry({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.message,
    this.source,
  });

  factory ServerLogEntry.fromConsoleLine({
    required String line,
    DateTime? timestamp,
  }) {
    final effectiveTimestamp = timestamp ?? DateTime.now();
    return ServerLogEntry(
      id: '${effectiveTimestamp.microsecondsSinceEpoch}-${line.hashCode}',
      timestamp: effectiveTimestamp,
      level: _detectLevel(line),
      message: line,
      source: _extractSource(line),
    );
  }

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  static LogLevel _detectLevel(String message) {
    final normalized = message.toLowerCase();
    if (normalized.contains('fatal') || normalized.contains('critical')) {
      return LogLevel.fatal;
    }
    if (normalized.contains('error') || normalized.contains('exception')) {
      return LogLevel.error;
    }
    if (normalized.contains('warn')) {
      return LogLevel.warn;
    }
    if (normalized.contains('debug')) {
      return LogLevel.debug;
    }
    return LogLevel.info;
  }

  static String? _extractSource(String message) {
    final matches = RegExp(r'\[([^\]]+)\]').allMatches(message).toList();
    if (matches.isEmpty) {
      return null;
    }

    final candidate = matches.last.group(1)?.trim();
    if (candidate == null || candidate.isEmpty) {
      return null;
    }

    return candidate;
  }
}
