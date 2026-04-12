import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/backup_model.dart';
import 'app_dependencies.dart';

final serverBackupsProvider =
    FutureProvider.family<List<BackupModel>, String>((ref, serverId) {
  return ref.watch(backupRepositoryProvider).fetchBackups(serverId);
});
