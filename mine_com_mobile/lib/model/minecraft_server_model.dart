class MinecraftServerModel {
  const MinecraftServerModel({
    required this.id,
    required this.nodeId,
    required this.nodeName,
    required this.name,
    required this.minecraftVersion,
    required this.modLoader,
    required this.modLoaderVersion,
    required this.deployTarget,
    required this.status,
    required this.gamePort,
    required this.createdAt,
    required this.updatedAt,
    required this.ramMb,
    required this.cpuCores,
    required this.diskMb,
    required this.autoRestart,
    required this.backupEnabled,
    required this.backupIntervalHours,
    required this.backupAutoDelete,
    required this.backupDeleteAfterHours,
    required this.whitelistEnabled,
    required this.rconEnabled,
    required this.rconPort,
    required this.remoteRoot,
    required this.storageType,
    required this.dockerContainerId,
    required this.logMaxFiles,
    required this.backupMaxCount,
  });

  final String id;
  final String nodeId;
  final String nodeName;
  final String name;
  final String minecraftVersion;
  final String? modLoader;
  final String? modLoaderVersion;
  final String deployTarget;
  final String status;
  final int? gamePort;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? ramMb;
  final int? cpuCores;
  final int? diskMb;
  final bool autoRestart;
  final bool backupEnabled;
  final int? backupIntervalHours;
  final bool backupAutoDelete;
  final int? backupDeleteAfterHours;
  final bool whitelistEnabled;
  final bool rconEnabled;
  final int? rconPort;
  final String? remoteRoot;
  final String? storageType;
  final String? dockerContainerId;
  final int? logMaxFiles;
  final int? backupMaxCount;

  String get normalizedStatus {
    if (status.trim().isEmpty) {
      return 'offline';
    }
    return status.trim().toLowerCase();
  }

  String get normalizedDeployTarget => deployTarget.trim().toLowerCase();

  bool get isOnline => normalizedStatus == 'online';
  bool get isDockerDeploy => normalizedDeployTarget == 'docker';
  bool get canAcceptConsoleCommands => !isDockerDeploy || rconEnabled;

  String get versionLabel {
    if (modLoader == null || modLoader!.isEmpty) {
      return minecraftVersion;
    }
    if (modLoaderVersion == null || modLoaderVersion!.isEmpty) {
      return '$minecraftVersion • $modLoader';
    }
    return '$minecraftVersion • $modLoader $modLoaderVersion';
  }

  factory MinecraftServerModel.fromJson(Map<String, dynamic> json) {
    return MinecraftServerModel(
      id: json['id'] as String? ?? '',
      nodeId: json['nodeId'] as String? ?? '',
      nodeName: json['nodeName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      minecraftVersion: json['minecraftVersion'] as String? ?? '',
      modLoader: json['modLoader'] as String?,
      modLoaderVersion: json['modLoaderVersion'] as String?,
      deployTarget: json['deployTarget'] as String? ?? '',
      status: json['status'] as String? ?? 'offline',
      gamePort: _asInt(json['gamePort']),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
      ramMb: _asInt(json['ramMb']),
      cpuCores: _asInt(json['cpuCores']),
      diskMb: _asInt(json['diskMb']),
      autoRestart: json['autoRestart'] as bool? ?? false,
      backupEnabled: json['backupEnabled'] as bool? ?? false,
      backupIntervalHours: _asInt(json['backupIntervalHours']),
      backupAutoDelete: json['backupAutoDelete'] as bool? ?? false,
      backupDeleteAfterHours: _asInt(json['backupDeleteAfterHours']),
      whitelistEnabled: json['whitelistEnabled'] as bool? ?? false,
      rconEnabled: json['rconEnabled'] as bool? ?? false,
      rconPort: _asInt(json['rconPort']),
      remoteRoot: json['remoteRoot'] as String?,
      storageType: json['storageType'] as String?,
      dockerContainerId: json['dockerContainerId'] as String?,
      logMaxFiles: _asInt(json['logMaxFiles']),
      backupMaxCount: _asInt(json['backupMaxCount']),
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
