class DashboardModel {
  const DashboardModel({
    required this.totalNodes,
    required this.onlineNodes,
    required this.totalMcServers,
    required this.onlineMcServers,
    required this.playersOnline,
    required this.avgCpuPercent,
    required this.avgRamPercent,
    required this.avgDiskPercent,
    required this.totalBackups,
    required this.crashesLast24h,
    required this.offlineMcServers,
    required this.backupsTotalSizeMb,
  });

  final int totalNodes;
  final int onlineNodes;
  final int totalMcServers;
  final int onlineMcServers;
  final int playersOnline;
  final double avgCpuPercent;
  final double avgRamPercent;
  final double avgDiskPercent;
  final int totalBackups;
  final int crashesLast24h;
  final int offlineMcServers;
  final int backupsTotalSizeMb;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalNodes: _asInt(json['totalNodes']),
      onlineNodes: _asInt(json['onlineNodes']),
      totalMcServers: _asInt(json['totalMcServers']),
      onlineMcServers: _asInt(json['onlineMcServers']),
      playersOnline: _asInt(json['playersOnline']),
      avgCpuPercent: _asDouble(json['avgCpuPercent']),
      avgRamPercent: _asDouble(json['avgRamPercent']),
      avgDiskPercent: _asDouble(json['avgDiskPercent']),
      totalBackups: _asInt(json['totalBackups']),
      crashesLast24h: _asInt(json['crashesLast24h']),
      offlineMcServers: _asInt(json['offlineMcServers']),
      backupsTotalSizeMb: _asInt(json['backupsTotalSizeMb']),
    );
  }
}

int _asInt(dynamic value) {
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
