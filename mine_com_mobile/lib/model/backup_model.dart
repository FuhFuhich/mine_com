class BackupModel {
  const BackupModel({
    required this.id,
    required this.minecraftServerId,
    required this.minecraftServerName,
    required this.fileName,
    required this.remotePath,
    required this.sizeMb,
    required this.backupType,
    required this.createdAt,
  });

  final String id;
  final String minecraftServerId;
  final String minecraftServerName;
  final String fileName;
  final String remotePath;
  final int? sizeMb;
  final String backupType;
  final DateTime? createdAt;

  factory BackupModel.fromJson(Map<String, dynamic> json) {
    return BackupModel(
      id: json['id'] as String? ?? '',
      minecraftServerId: json['minecraftServerId'] as String? ?? '',
      minecraftServerName: json['minecraftServerName'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      remotePath: json['remotePath'] as String? ?? '',
      sizeMb: _asInt(json['sizeMb']),
      backupType: json['backupType'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
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
