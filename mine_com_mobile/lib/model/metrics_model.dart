class ServerMetricsModel {
  const ServerMetricsModel({
    required this.id,
    required this.minecraftServerId,
    required this.recordedAt,
    required this.cpuUsagePercent,
    required this.diskUsagePercent,
    required this.ramUsagePercent,
    required this.ramUsedMb,
    required this.ramTotalMb,
    required this.diskTotalMb,
    required this.uptimeSeconds,
    required this.playersOnline,
    required this.totalBackups,
    required this.crashesLast24h,
    required this.backupsSizeMbTotal,
    required this.diskUsedWorldMb,
    required this.networkRxMb,
    required this.networkTxMb,
    required this.containerRestarts,
    required this.status,
    required this.storageType,
    required this.tps,
    required this.mspt,
    required this.chunksLoaded,
  });

  final String id;
  final String minecraftServerId;
  final DateTime? recordedAt;
  final double cpuUsagePercent;
  final double diskUsagePercent;
  final double ramUsagePercent;
  final int? ramUsedMb;
  final int? ramTotalMb;
  final int? diskTotalMb;
  final int? uptimeSeconds;
  final int? playersOnline;
  final int? totalBackups;
  final int? crashesLast24h;
  final int? backupsSizeMbTotal;
  final int? diskUsedWorldMb;
  final double networkRxMb;
  final double networkTxMb;
  final int? containerRestarts;
  final String status;
  final String? storageType;
  final double? tps;
  final double? mspt;
  final int? chunksLoaded;

  bool get hasData =>
      recordedAt != null ||
      ramUsedMb != null ||
      ramTotalMb != null ||
      cpuUsagePercent > 0 ||
      ramUsagePercent > 0;

  factory ServerMetricsModel.fromJson(Map<String, dynamic> json) {
    return ServerMetricsModel(
      id: json['id'] as String? ?? '',
      minecraftServerId: json['minecraftServerId'] as String? ?? '',
      recordedAt: DateTime.tryParse(json['recordedAt'] as String? ?? ''),
      cpuUsagePercent: _asDouble(json['cpuUsagePercent']),
      diskUsagePercent: _asDouble(json['diskUsagePercent']),
      ramUsagePercent: _asDouble(json['ramUsagePercent']),
      ramUsedMb: _asInt(json['ramUsedMb']),
      ramTotalMb: _asInt(json['ramTotalMb']),
      diskTotalMb: _asInt(json['diskTotalMb']),
      uptimeSeconds: _asInt(json['uptimeSeconds']),
      playersOnline: _asInt(json['playersOnline']),
      totalBackups: _asInt(json['totalBackups']),
      crashesLast24h: _asInt(json['crashesLast24h']),
      backupsSizeMbTotal: _asInt(json['backupsSizeMbTotal']),
      diskUsedWorldMb: _asInt(json['diskUsedWorldMb']),
      networkRxMb: _asDouble(json['networkRxMb']),
      networkTxMb: _asDouble(json['networkTxMb']),
      containerRestarts: _asInt(json['containerRestarts']),
      status: json['status'] as String? ?? 'offline',
      storageType: json['storageType'] as String?,
      tps: _asNullableDouble(json['tps']),
      mspt: _asNullableDouble(json['mspt']),
      chunksLoaded: _asInt(json['chunksLoaded']),
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

double? _asNullableDouble(dynamic value) {
  if (value == null) {
    return null;
  }
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
    return double.tryParse(value);
  }
  return null;
}
