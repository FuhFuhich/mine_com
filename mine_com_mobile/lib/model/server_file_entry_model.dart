class ServerFileEntryModel {
  const ServerFileEntryModel({
    required this.name,
    required this.path,
    required this.isDirectory,
    required this.sizeBytes,
    required this.permissions,
    required this.lastModified,
  });

  final String name;
  final String path;
  final bool isDirectory;
  final int sizeBytes;
  final String? permissions;
  final String? lastModified;

  factory ServerFileEntryModel.fromJson(Map<String, dynamic> json) {
    return ServerFileEntryModel(
      name: json['name'] as String? ?? '',
      path: normalizeServerPath(json['path'] as String?),
      isDirectory: json['directory'] as bool? ?? false,
      sizeBytes: _asInt(json['sizeBytes']),
      permissions: json['permissions'] as String?,
      lastModified: json['lastModified'] as String?,
    );
  }

  bool get isConfigLike {
    if (isDirectory) {
      return true;
    }

    final lower = name.toLowerCase();
    const exact = <String>{
      'server.properties',
      'eula.txt',
      'ops.json',
      'whitelist.json',
      'banned-players.json',
      'banned-ips.json',
      'paper.yml',
      'paper-global.yml',
      'paper-world-defaults.yml',
      'spigot.yml',
      'bukkit.yml',
      'permissions.yml',
    };

    if (exact.contains(lower)) {
      return true;
    }

    const suffixes = <String>[
      '.yml',
      '.yaml',
      '.json',
      '.properties',
      '.toml',
      '.cfg',
      '.conf',
      '.ini',
      '.txt',
      '.xml',
    ];

    for (final suffix in suffixes) {
      if (lower.endsWith(suffix)) {
        return true;
      }
    }

    return false;
  }

  bool get isHiddenNoise {
    final lower = name.toLowerCase();
    const hidden = <String>{
      'runtime',
      'logs',
      'world',
      'libraries',
      '.fabric',
      '.cache',
    };
    return hidden.contains(lower);
  }

  static int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}

String normalizeServerPath(String? path) {
  final raw = (path ?? '/').trim().replaceAll('\\', '/');
  if (raw.isEmpty || raw == '/') {
    return '/';
  }

  var value = raw;
  while (value.contains('//')) {
    value = value.replaceAll('//', '/');
  }
  while (value.endsWith('/') && value.length > 1) {
    value = value.substring(0, value.length - 1);
  }
  if (!value.startsWith('/')) {
    value = '/$value';
  }
  return value;
}
