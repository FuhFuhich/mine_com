enum NodeRole {
  owner,
  manager,
  admin,
  viewer,
  user;

  static NodeRole fromBackend(String? value) {
    switch ((value ?? '').toUpperCase()) {
      case 'OWNER':
        return NodeRole.owner;
      case 'MANAGER':
        return NodeRole.manager;
      case 'ADMIN':
        return NodeRole.admin;
      case 'VIEWER':
        return NodeRole.viewer;
      case 'USER':
      default:
        return NodeRole.user;
    }
  }

  int get level {
    switch (this) {
      case NodeRole.owner:
        return 4;
      case NodeRole.manager:
        return 3;
      case NodeRole.admin:
        return 2;
      case NodeRole.viewer:
        return 1;
      case NodeRole.user:
        return 0;
    }
  }

  bool hasAtLeast(NodeRole role) => level >= role.level;

  bool get canManageServerLifecycle => hasAtLeast(NodeRole.admin);
  bool get canRedeploy => hasAtLeast(NodeRole.manager);
  bool get canSendConsoleCommand => hasAtLeast(NodeRole.admin);
  bool get canCreateBackup => hasAtLeast(NodeRole.admin);
  bool get canDeleteBackup => hasAtLeast(NodeRole.admin);
  bool get canRestoreBackup => this == NodeRole.owner;
  bool get canViewConfigs => hasAtLeast(NodeRole.viewer);
  bool get canEditConfigs => hasAtLeast(NodeRole.admin);
}

class NodeModel {
  const NodeModel({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.sshPort,
    required this.sshUser,
    required this.authType,
    required this.description,
    required this.os,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  final String id;
  final String name;
  final String ipAddress;
  final int? sshPort;
  final String sshUser;
  final String authType;
  final String? description;
  final String? os;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final NodeRole role;

  factory NodeModel.fromJson(Map<String, dynamic> json) {
    return NodeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      ipAddress: json['ipAddress'] as String? ?? '',
      sshPort: _asInt(json['sshPort']),
      sshUser: json['sshUser'] as String? ?? '',
      authType: json['authType'] as String? ?? '',
      description: json['description'] as String?,
      os: json['os'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
      role: NodeRole.fromBackend(json['myRole'] as String?),
    );
  }
}

class NodeUsageModel {
  const NodeUsageModel({
    required this.nodeId,
    required this.nodeName,
    required this.cpuUsagePercent,
    required this.cpuLoadAverage1m,
    required this.cpuLoadAverage5m,
    required this.cpuLoadAverage15m,
    required this.ramUsedMb,
    required this.ramTotalMb,
    required this.ramUsagePercent,
    required this.diskUsedMb,
    required this.diskTotalMb,
    required this.diskUsagePercent,
    required this.networkRxMb,
    required this.networkTxMb,
    required this.dockerContainersRunning,
    required this.dockerContainersTotal,
    required this.collectedAt,
  });

  final String nodeId;
  final String nodeName;
  final double cpuUsagePercent;
  final double cpuLoadAverage1m;
  final double cpuLoadAverage5m;
  final double cpuLoadAverage15m;
  final int? ramUsedMb;
  final int? ramTotalMb;
  final double ramUsagePercent;
  final int? diskUsedMb;
  final int? diskTotalMb;
  final double diskUsagePercent;
  final double networkRxMb;
  final double networkTxMb;
  final int? dockerContainersRunning;
  final int? dockerContainersTotal;
  final DateTime? collectedAt;

  factory NodeUsageModel.fromJson(Map<String, dynamic> json) {
    return NodeUsageModel(
      nodeId: json['nodeId'] as String? ?? '',
      nodeName: json['nodeName'] as String? ?? '',
      cpuUsagePercent: _asDouble(json['cpuUsagePercent']),
      cpuLoadAverage1m: _asDouble(json['cpuLoadAverage1m']),
      cpuLoadAverage5m: _asDouble(json['cpuLoadAverage5m']),
      cpuLoadAverage15m: _asDouble(json['cpuLoadAverage15m']),
      ramUsedMb: _asInt(json['ramUsedMb']),
      ramTotalMb: _asInt(json['ramTotalMb']),
      ramUsagePercent: _asDouble(json['ramUsagePercent']),
      diskUsedMb: _asInt(json['diskUsedMb']),
      diskTotalMb: _asInt(json['diskTotalMb']),
      diskUsagePercent: _asDouble(json['diskUsagePercent']),
      networkRxMb: _asDouble(json['networkRxMb']),
      networkTxMb: _asDouble(json['networkTxMb']),
      dockerContainersRunning: _asInt(json['dockerContainersRunning']),
      dockerContainersTotal: _asInt(json['dockerContainersTotal']),
      collectedAt: DateTime.tryParse(json['collectedAt'] as String? ?? ''),
    );
  }
}

class NodeDiskInfo {
  const NodeDiskInfo({
    required this.name,
    required this.mount,
    required this.totalGb,
    required this.freeGb,
    required this.type,
  });

  final String name;
  final String mount;
  final String totalGb;
  final String freeGb;
  final String type;

  factory NodeDiskInfo.fromJson(Map<String, dynamic> json) {
    return NodeDiskInfo(
      name: json['name'] as String? ?? '',
      mount: json['mount'] as String? ?? '',
      totalGb: json['totalGb'] as String? ?? '',
      freeGb: json['freeGb'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }
}

class NodeHardwareModel {
  const NodeHardwareModel({
    required this.id,
    required this.nodeId,
    required this.nodeName,
    required this.cpuModel,
    required this.cpuCores,
    required this.cpuThreads,
    required this.cpuMhz,
    required this.ramTotalMb,
    required this.ramAvailableMb,
    required this.disks,
    required this.osName,
    required this.osVersion,
    required this.kernel,
    required this.gpuModel,
    required this.scannedAt,
  });

  final String id;
  final String nodeId;
  final String nodeName;
  final String? cpuModel;
  final int? cpuCores;
  final int? cpuThreads;
  final double cpuMhz;
  final int? ramTotalMb;
  final int? ramAvailableMb;
  final List<NodeDiskInfo> disks;
  final String? osName;
  final String? osVersion;
  final String? kernel;
  final String? gpuModel;
  final DateTime? scannedAt;

  factory NodeHardwareModel.fromJson(Map<String, dynamic> json) {
    final rawDisks = json['disks'];
    final disks = rawDisks is List
        ? rawDisks
            .whereType<Map<String, dynamic>>()
            .map(NodeDiskInfo.fromJson)
            .toList(growable: false)
        : const <NodeDiskInfo>[];

    return NodeHardwareModel(
      id: json['id'] as String? ?? '',
      nodeId: json['nodeId'] as String? ?? '',
      nodeName: json['nodeName'] as String? ?? '',
      cpuModel: json['cpuModel'] as String?,
      cpuCores: _asInt(json['cpuCores']),
      cpuThreads: _asInt(json['cpuThreads']),
      cpuMhz: _asDouble(json['cpuMhz']),
      ramTotalMb: _asInt(json['ramTotalMb']),
      ramAvailableMb: _asInt(json['ramAvailableMb']),
      disks: disks,
      osName: json['osName'] as String?,
      osVersion: json['osVersion'] as String?,
      kernel: json['kernel'] as String?,
      gpuModel: json['gpuModel'] as String?,
      scannedAt: DateTime.tryParse(json['scannedAt'] as String? ?? ''),
    );
  }
}

int? _asInt(dynamic value) {
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

double _asDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return 0;
}
