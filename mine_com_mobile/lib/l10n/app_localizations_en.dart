// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get darkThemeSubtitle => 'Change app appearance';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsSubtitle => 'Receive server status notifications';

  @override
  String get aboutApp => 'About app';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get helpSupportSubtitle => 'Documentation and FAQ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicySubtitle => 'Terms of use';

  @override
  String get account => 'Account';

  @override
  String get security => 'Security';

  @override
  String get securitySubtitle => 'Password and two-factor authentication';

  @override
  String get logout => 'Log out';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get openHelp => 'Open help';

  @override
  String get privacyPolicyAction => 'Privacy policy';

  @override
  String get securityAction => 'Security settings';

  @override
  String get appDescription =>
      'Software complex for automating deployment and management of Minecraft servers';

  @override
  String get featuresTitle => 'Features:';

  @override
  String get featureSsh => 'SSH console for management';

  @override
  String get featureMonitoring => 'Real-time metrics monitoring';

  @override
  String get featureLogs => 'Server log viewing';

  @override
  String get featureAutomation => 'Deployment automation';

  @override
  String get featureBackups => 'Backup management';

  @override
  String get version => 'Version';

  @override
  String get platform => 'Platform';

  @override
  String get platformValue => 'Unix-like systems';

  @override
  String get developer => 'Developer';

  @override
  String get developerValue => 'Minecraft Manager Team';

  @override
  String get settingsMainMenu => 'Settings';

  @override
  String get serversMainMenu => 'Servers';

  @override
  String get profileMainMenu => 'Profile';

  @override
  String get onlineServerList => 'Online';

  @override
  String get offlineServerList => 'Offline';

  @override
  String get playersServerList => 'players';

  @override
  String get launchServerList => 'Launch';

  @override
  String get stopServerList => 'Stop';

  @override
  String get restartServerList => 'Restart';

  @override
  String get searchingForServersServerList => 'Searching for servers...';

  @override
  String get clearServerList => 'Clear';

  @override
  String get refreshServerListServerList => 'Refresh server list';

  @override
  String get refreshServerList => 'Refresh';

  @override
  String get closeSearchServerList => 'Close search';

  @override
  String get searchServerList => 'Search';

  @override
  String get noServersFoundServerList => 'No servers found';

  @override
  String get noServersServerList => 'No servers';

  @override
  String get tryChangingYourQueryServerList => 'Try changing your query';

  @override
  String get addNewServerServerList => 'Add a new server';

  @override
  String get totalServersProfile => 'Total servers';

  @override
  String get onlineProfile => 'Online';

  @override
  String get playersProfile => 'players';

  @override
  String get playerProfile => 'Player';

  @override
  String get serverOverviewProfile => 'Server overview';

  @override
  String get averageCpuLoadProfile => 'Average CPU load';

  @override
  String get averageNumberOfPlayersProfile => 'Average number of players';

  @override
  String get averageRamLoadProfile => 'Average RAM load';

  @override
  String get mostPopularServerProfile => 'Most popular server';

  @override
  String get sshConnectionsProfile => 'SSH connections';

  @override
  String get keyAndSessionManagementProfile => 'Key and session management';

  @override
  String get activityHistoryProfile => 'Activity history';

  @override
  String get operationAndChangeLogProfile => 'Operation and change log';

  @override
  String get serverStatusProfile => 'Server status';

  @override
  String get plProfile => 'pl';

  @override
  String get editprofile1Profile => 'Edit profile';

  @override
  String get editProfileProfile => 'Edit profile';

  @override
  String get administratorProfile => 'Administrator';

  @override
  String get systemadministratorProfile => 'System administrator';

  @override
  String get detailedstatisticsProfile => 'detailed statistics';

  @override
  String get startServerDetailServerDetail => 'Start';

  @override
  String get stopServerDetail => 'Stop';

  @override
  String get restartServerDetail => 'Restart';

  @override
  String get onlineServerDetail => 'Online';

  @override
  String get serverStatusServerDetail => 'Server status';

  @override
  String get minecraftVersionServerDetail => 'Minecraft version';

  @override
  String get modLoaderServerDetail => 'Mod loader';

  @override
  String get activePlayersServerDetail => 'Active players';

  @override
  String get dedicatedCoresServerDetail => 'Dedicated cores';

  @override
  String get dedicatedRamServerDetail => 'Dedicated RAM';

  @override
  String get serverInformationServerDetail => 'Server information';

  @override
  String get currentMetricsServerDetail => 'Current metrics';

  @override
  String get cpuServerDetail => 'CPU';

  @override
  String get ramServerDetail => 'RAM';

  @override
  String get detailedMetricsServerDetail => 'Detailed metrics';

  @override
  String get linuxConsoleServerDetail => 'Linux console';

  @override
  String get serverLogsServerDetail => 'Server logs';

  @override
  String get creatingServerBackupServerDetail => 'Creating a server backup';

  @override
  String get hServerDetail => 'h';

  @override
  String get mServerDetail => 'm';

  @override
  String get worksServerDetail => 'Works:';

  @override
  String get launchedServerDetail => 'Launched:';

  @override
  String get connectedToLinuxConsole => 'Connected to';

  @override
  String get connectionErrorLinuxConsole => 'Connection Error:';

  @override
  String get failedToConnect1LinuxConsole => 'Failed to connect:';

  @override
  String get sshSessionEndedLinuxConsole => 'SSH session ended';

  @override
  String get shellStartupErrorLinuxConsole => 'Shell startup error:';

  @override
  String get disconnectedFromServerLinuxConsole => 'Disconnected from server';

  @override
  String get consoleLinuxConsole => 'Console';

  @override
  String get disconnectLinuxConsole => 'Disconnect';

  @override
  String get reconnectLinuxConsole => 'Reconnect';

  @override
  String get failedToConnect2LinuxConsole => 'Failed to connect';

  @override
  String get unknownErrorLinuxConsole => 'Unknown error';

  @override
  String get tryAgainLinuxConsole => 'Try again';

  @override
  String get autoscrollIsEnabledServerLogs => 'Autoscroll enabled';

  @override
  String get autoscrollIsDisabledServerLogs => 'Autoscroll disabled';

  @override
  String get refreshLogsServerLogs => 'Refresh';

  @override
  String get logsUpdatedServerLogs => 'Logs updated';

  @override
  String get clearLogsServerLogs => 'Clear logs';

  @override
  String get exportLogsServerLogs => 'Export';

  @override
  String get searchInLogsServerLogs => 'Search in logs...';

  @override
  String get logsInfoServerLogs => 'Showing \$filtered of \$total entries';

  @override
  String get noResultsFoundServerLogs => 'Nothing found';

  @override
  String get noLogsToDisplayServerLogs => 'No logs to display';

  @override
  String get timeServerLogs => 'Time';

  @override
  String get sourceServerLogs => 'Source';

  @override
  String get messageServerLogs => 'Message:';

  @override
  String get copyToClipboardServerLogs => 'Copy';

  @override
  String get copiedToClipboardServerLogs => 'Copied to clipboard';

  @override
  String get closeServerLogs => 'Close';

  @override
  String get exportLogsTitleServerLogs => 'Export logs';

  @override
  String get exportComingSoonServerLogs =>
      'Export feature will be implemented later.\n\nAvailable formats:\n• TXT\n• JSON\n• CSV';

  @override
  String get understoodServerLogs => 'Got it';

  @override
  String get shownServerLogs => 'shown';

  @override
  String get fromServerLogs => 'from';

  @override
  String get recordsServerLogs => 'records';

  @override
  String get logsServerLogs => 'Logs';

  @override
  String get metricsMetricsFragment => 'Metrics';

  @override
  String get cpuMetricsFragment => 'CPU';

  @override
  String get memoryMetricsFragment => 'Memory';

  @override
  String get overviewMetricsFragment => 'Overview';

  @override
  String get cpuLoadLast10MeasurementsMetricsFragment =>
      'CPU load (last 10 measurements)';

  @override
  String get ramUsageLast10MeasurementsMetricsFragment =>
      'RAM usage (last 10 measurements)';

  @override
  String get metricsOverviewMetricsFragment => 'Metrics overview';

  @override
  String get ramMetricsFragment => 'RAM';

  @override
  String get statisticsMetricsFragment => 'Statistics';

  @override
  String get averageCpuMetricsFragment => 'Average CPU';

  @override
  String get averageRamMetricsFragment => 'Average RAM';

  @override
  String get maxCpuMetricsFragment => 'Max CPU';

  @override
  String get maxRamMetricsFragment => 'Max RAM';

  @override
  String get authLoginTitle => 'Sign in';

  @override
  String get authIdentityLabel => 'Email, username or phone';

  @override
  String get authIdentityHint => 'Enter your identity';

  @override
  String get authIdentityRequired => 'Enter your email, username or phone';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordRequired => 'Enter your password';

  @override
  String get authRememberMe => 'Remember me';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authRegisterLink => 'No account? Create one';

  @override
  String get authGenericError => 'Something went wrong. Please try again.';

  @override
  String get authRegisterTitle => 'Create account';

  @override
  String get authUsernameLabel => 'Username';

  @override
  String get authUsernameRequired => 'Enter a username';

  @override
  String get authEmailOptionalLabel => 'Email (optional)';

  @override
  String get authEmailInvalid => 'Enter a valid email';

  @override
  String get authPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authAcceptTerms => 'I accept the terms of use';

  @override
  String get authCreateAccountButton => 'Create account';

  @override
  String get authBackToLogin => 'Already have an account? Sign in';

  @override
  String get authAcceptTermsError => 'Please accept the terms of use';

  @override
  String get profileJoinedLabel => 'Joined';

  @override
  String get profileNodesLabel => 'Nodes online/total';

  @override
  String get profileDiskLabel => 'Average disk load';

  @override
  String get profileBackupsLabel => 'Backups';

  @override
  String get profileCrashesLabel => 'Crashes in 24h';

  @override
  String get profileLoadError => 'Failed to load profile data';

  @override
  String get retryCommon => 'Retry';

  @override
  String get serverListLoadError => 'Failed to load nodes and servers';

  @override
  String get serverListNodesSectionTitle => 'Nodes';

  @override
  String get serverListNodeRoleLabel => 'Role';

  @override
  String get serverListNodeAddressLabel => 'Address';

  @override
  String get serverListNodeServersLabel => 'Servers';

  @override
  String get serverListNoNodes =>
      'No nodes are available for your account yet.';

  @override
  String get serverListEmptyDescription =>
      'This account does not have any Minecraft servers yet.';

  @override
  String get serverListReadOnlyRole => 'Read-only access';

  @override
  String get serverActionStartedMessage => 'Start command sent';

  @override
  String get serverActionStoppedMessage => 'Stop command sent';

  @override
  String get serverActionRestartedMessage => 'Restart command sent';

  @override
  String get serverStatusStarting => 'Starting';

  @override
  String get serverStatusStopping => 'Stopping';

  @override
  String get serverStatusRestarting => 'Restarting';

  @override
  String get serverStatusDeploying => 'Deploying';

  @override
  String get serverStatusUndeployed => 'Undeployed';

  @override
  String get serverStatusCrashed => 'Crashed';

  @override
  String get serverStatusError => 'Error';

  @override
  String get nodeDetailTitle => 'Node';

  @override
  String get nodeDetailLoadError => 'Failed to load node details';

  @override
  String get nodeDetailOsLabel => 'Operating system';

  @override
  String get nodeDetailSshUserLabel => 'SSH user';

  @override
  String get nodeDetailSshPortLabel => 'SSH port';

  @override
  String get nodeDetailAuthLabel => 'Auth type';

  @override
  String get nodeDetailDescriptionLabel => 'Description';

  @override
  String get nodeDetailUsageTitle => 'Live usage';

  @override
  String get nodeDetailDiskLabel => 'Disk';

  @override
  String get nodeDetailContainersLabel => 'Containers';

  @override
  String get nodeDetailNetworkRxLabel => 'Network RX';

  @override
  String get nodeDetailNetworkTxLabel => 'Network TX';

  @override
  String get nodeDetailCollectedAtLabel => 'Collected at';

  @override
  String get nodeDetailHardwareTitle => 'Hardware';

  @override
  String get nodeDetailCpuLabel => 'CPU';

  @override
  String get nodeDetailCoresLabel => 'Cores / threads';

  @override
  String get nodeDetailRamTotalLabel => 'RAM total';

  @override
  String get nodeDetailKernelLabel => 'Kernel';

  @override
  String get nodeDetailGpuLabel => 'GPU';

  @override
  String get nodeDetailScannedAtLabel => 'Scanned at';

  @override
  String get nodeDetailDisksTitle => 'Disks';

  @override
  String get nodeDetailServersTitle => 'Minecraft servers';

  @override
  String get nodeDetailNoServers =>
      'No Minecraft servers are linked to this node.';

  @override
  String get nodeDetailSectionUnavailable =>
      'This section is unavailable on the backend right now.';

  @override
  String get commonUnavailable => 'Unavailable';

  @override
  String get commonEnabled => 'Enabled';

  @override
  String get commonDisabled => 'Disabled';

  @override
  String get serverActionRedeployedMessage => 'Redeploy started';

  @override
  String get serverDetailRedeployAction => 'Redeploy';

  @override
  String get serverConsoleServerDetail => 'Server console';

  @override
  String get serverBackupsTitle => 'Backups';

  @override
  String get serverDetailDeployTargetLabel => 'Deploy target';

  @override
  String get serverDetailPortLabel => 'Game port';

  @override
  String get serverDetailBackupsEnabledLabel => 'Backups enabled';

  @override
  String get metricsUnavailableMessage =>
      'Metrics are not available for this server yet.';

  @override
  String get serverDetailReadOnlyHint =>
      'This server is available in read-only mode on mobile.';

  @override
  String get metricsLoadError => 'Failed to load metrics';

  @override
  String get logsLiveStatus => 'Live stream active';

  @override
  String get serverConsoleCommandHint => 'Enter a console command';

  @override
  String get serverConsoleReadOnlyMessage =>
      'Your role allows viewing console output, but not sending commands.';

  @override
  String get backupsCreateSuccess => 'Backup creation started';

  @override
  String get backupsRestoreTitle => 'Restore backup';

  @override
  String get backupsRestoreConfirm => 'Restore this backup to the server?';

  @override
  String get backupsRestoreSuccess => 'Backup restored';

  @override
  String get backupsDeleteTitle => 'Delete backup';

  @override
  String get backupsDeleteConfirm => 'Delete this backup permanently?';

  @override
  String get backupsDeleteSuccess => 'Backup deleted';

  @override
  String get confirmCommon => 'Confirm';

  @override
  String get backupsCreateAction => 'Create backup';

  @override
  String get backupsFeatureDisabledMessage =>
      'Automatic backups are disabled for this server. You can still review existing backups.';

  @override
  String get serverBackupsEmpty => 'No backups available yet.';

  @override
  String get serverBackupsLoadError => 'Failed to load backups';
}
