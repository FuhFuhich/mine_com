class ApiEndpoints {
  const ApiEndpoints._();

  static const String authLogin = '/api/auth/login';
  static const String authRegister = '/api/auth/register';
  static const String authRefresh = '/api/auth/refresh';
  static const String authLogout = '/api/auth/logout';
  static const String authMe = '/api/auth/me';
  static const String userMe = '/api/user/me';
  static const String userPassword = '/api/user/me/password';
  static const String dashboard = '/api/dashboard';
  static const String nodes = '/api/nodes';
  static const String minecraftServers = '/api/mc-servers';
  static const String backups = '/api/backups';
  static const String metrics = '/api/metrics';
  static const String console = '/api/console';

  static String nodeById(String nodeId) => '$nodes/$nodeId';
  static String nodeUsage(String nodeId) => '$nodes/$nodeId/usage';
  static String nodeHardware(String nodeId) => '$nodes/$nodeId/hardware';
  static String nodeServers(String nodeId) => '$minecraftServers/node/$nodeId';

  static String mcServerById(String serverId) => '$minecraftServers/$serverId';
  static String mcServerStart(String serverId) => '$minecraftServers/$serverId/start';
  static String mcServerStop(String serverId) => '$minecraftServers/$serverId/stop';
  static String mcServerRestart(String serverId) => '$minecraftServers/$serverId/restart';
  static String mcServerRedeploy(String serverId) => '$minecraftServers/$serverId/redeploy';

  static String mcServerRcon(String serverId) =>
      '$minecraftServers/$serverId/rcon';

  static String mcServerModsShareLink(String serverId) =>
      '$minecraftServers/$serverId/mods/share-link';

  static String mcServerFsList(String serverId) =>
      '$minecraftServers/$serverId/fs/list';
  static String mcServerFsRead(String serverId) =>
      '$minecraftServers/$serverId/fs/read';
  static String mcServerFsWrite(String serverId) =>
      '$minecraftServers/$serverId/fs/write';

  static String backupsByServer(String serverId) => '$backups/$serverId';
  static String restoreBackup(String backupId) => '$backups/$backupId/restore';
  static String deleteBackup(String backupId) => '$backups/$backupId';

  static String latestMetrics(String serverId) => '$metrics/$serverId/latest';
  static String runtimeMetrics(String serverId) => '$metrics/$serverId/runtime';
  static String metricsSeries(String serverId) => '$metrics/$serverId/series';

  static String consoleStart(String serverId) => '$console/$serverId/start';
  static String consoleStop(String serverId) => '$console/$serverId/stop';
  static String consoleLogs(String serverId) => '$console/$serverId/log';
  static String consoleStatus(String serverId) => '$console/$serverId/status';
  static String consoleCommand(String serverId) => '$console/$serverId/command';

  static String consoleTopic(String serverId) => '/topic/console/$serverId';
}