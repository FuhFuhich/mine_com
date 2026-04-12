import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @darkThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change app appearance'**
  String get darkThemeSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive server status notifications'**
  String get notificationsSubtitle;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get aboutApp;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @helpSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Documentation and FAQ'**
  String get helpSupportSubtitle;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get privacyPolicySubtitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @securitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Password and two-factor authentication'**
  String get securitySubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTitle;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @openHelp.
  ///
  /// In en, this message translates to:
  /// **'Open help'**
  String get openHelp;

  /// No description provided for @privacyPolicyAction.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicyAction;

  /// No description provided for @securityAction.
  ///
  /// In en, this message translates to:
  /// **'Security settings'**
  String get securityAction;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Software complex for automating deployment and management of Minecraft servers'**
  String get appDescription;

  /// No description provided for @featuresTitle.
  ///
  /// In en, this message translates to:
  /// **'Features:'**
  String get featuresTitle;

  /// No description provided for @featureSsh.
  ///
  /// In en, this message translates to:
  /// **'SSH console for management'**
  String get featureSsh;

  /// No description provided for @featureMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Real-time metrics monitoring'**
  String get featureMonitoring;

  /// No description provided for @featureLogs.
  ///
  /// In en, this message translates to:
  /// **'Server log viewing'**
  String get featureLogs;

  /// No description provided for @featureAutomation.
  ///
  /// In en, this message translates to:
  /// **'Deployment automation'**
  String get featureAutomation;

  /// No description provided for @featureBackups.
  ///
  /// In en, this message translates to:
  /// **'Backup management'**
  String get featureBackups;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @platformValue.
  ///
  /// In en, this message translates to:
  /// **'Unix-like systems'**
  String get platformValue;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @developerValue.
  ///
  /// In en, this message translates to:
  /// **'Minecraft Manager Team'**
  String get developerValue;

  /// No description provided for @settingsMainMenu.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsMainMenu;

  /// No description provided for @serversMainMenu.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get serversMainMenu;

  /// No description provided for @profileMainMenu.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileMainMenu;

  /// No description provided for @onlineServerList.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get onlineServerList;

  /// No description provided for @offlineServerList.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offlineServerList;

  /// No description provided for @playersServerList.
  ///
  /// In en, this message translates to:
  /// **'players'**
  String get playersServerList;

  /// No description provided for @launchServerList.
  ///
  /// In en, this message translates to:
  /// **'Launch'**
  String get launchServerList;

  /// No description provided for @stopServerList.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopServerList;

  /// No description provided for @restartServerList.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restartServerList;

  /// No description provided for @searchingForServersServerList.
  ///
  /// In en, this message translates to:
  /// **'Searching for servers...'**
  String get searchingForServersServerList;

  /// No description provided for @clearServerList.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearServerList;

  /// No description provided for @refreshServerListServerList.
  ///
  /// In en, this message translates to:
  /// **'Refresh server list'**
  String get refreshServerListServerList;

  /// No description provided for @refreshServerList.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshServerList;

  /// No description provided for @closeSearchServerList.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get closeSearchServerList;

  /// No description provided for @searchServerList.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchServerList;

  /// No description provided for @noServersFoundServerList.
  ///
  /// In en, this message translates to:
  /// **'No servers found'**
  String get noServersFoundServerList;

  /// No description provided for @noServersServerList.
  ///
  /// In en, this message translates to:
  /// **'No servers'**
  String get noServersServerList;

  /// No description provided for @tryChangingYourQueryServerList.
  ///
  /// In en, this message translates to:
  /// **'Try changing your query'**
  String get tryChangingYourQueryServerList;

  /// No description provided for @addNewServerServerList.
  ///
  /// In en, this message translates to:
  /// **'Add a new server'**
  String get addNewServerServerList;

  /// No description provided for @totalServersProfile.
  ///
  /// In en, this message translates to:
  /// **'Total servers'**
  String get totalServersProfile;

  /// No description provided for @onlineProfile.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get onlineProfile;

  /// No description provided for @playersProfile.
  ///
  /// In en, this message translates to:
  /// **'players'**
  String get playersProfile;

  /// No description provided for @playerProfile.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get playerProfile;

  /// No description provided for @serverOverviewProfile.
  ///
  /// In en, this message translates to:
  /// **'Server overview'**
  String get serverOverviewProfile;

  /// No description provided for @averageCpuLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Average CPU load'**
  String get averageCpuLoadProfile;

  /// No description provided for @averageNumberOfPlayersProfile.
  ///
  /// In en, this message translates to:
  /// **'Average number of players'**
  String get averageNumberOfPlayersProfile;

  /// No description provided for @averageRamLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Average RAM load'**
  String get averageRamLoadProfile;

  /// No description provided for @mostPopularServerProfile.
  ///
  /// In en, this message translates to:
  /// **'Most popular server'**
  String get mostPopularServerProfile;

  /// No description provided for @sshConnectionsProfile.
  ///
  /// In en, this message translates to:
  /// **'SSH connections'**
  String get sshConnectionsProfile;

  /// No description provided for @keyAndSessionManagementProfile.
  ///
  /// In en, this message translates to:
  /// **'Key and session management'**
  String get keyAndSessionManagementProfile;

  /// No description provided for @activityHistoryProfile.
  ///
  /// In en, this message translates to:
  /// **'Activity history'**
  String get activityHistoryProfile;

  /// No description provided for @operationAndChangeLogProfile.
  ///
  /// In en, this message translates to:
  /// **'Operation and change log'**
  String get operationAndChangeLogProfile;

  /// No description provided for @serverStatusProfile.
  ///
  /// In en, this message translates to:
  /// **'Server status'**
  String get serverStatusProfile;

  /// No description provided for @plProfile.
  ///
  /// In en, this message translates to:
  /// **'pl'**
  String get plProfile;

  /// No description provided for @editprofile1Profile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editprofile1Profile;

  /// No description provided for @editProfileProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileProfile;

  /// No description provided for @administratorProfile.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administratorProfile;

  /// No description provided for @systemadministratorProfile.
  ///
  /// In en, this message translates to:
  /// **'System administrator'**
  String get systemadministratorProfile;

  /// No description provided for @detailedstatisticsProfile.
  ///
  /// In en, this message translates to:
  /// **'detailed statistics'**
  String get detailedstatisticsProfile;

  /// No description provided for @startServerDetailServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startServerDetailServerDetail;

  /// No description provided for @stopServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopServerDetail;

  /// No description provided for @restartServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restartServerDetail;

  /// No description provided for @onlineServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get onlineServerDetail;

  /// No description provided for @serverStatusServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Server status'**
  String get serverStatusServerDetail;

  /// No description provided for @minecraftVersionServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Minecraft version'**
  String get minecraftVersionServerDetail;

  /// No description provided for @modLoaderServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Mod loader'**
  String get modLoaderServerDetail;

  /// No description provided for @activePlayersServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Active players'**
  String get activePlayersServerDetail;

  /// No description provided for @dedicatedCoresServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Dedicated cores'**
  String get dedicatedCoresServerDetail;

  /// No description provided for @dedicatedRamServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Dedicated RAM'**
  String get dedicatedRamServerDetail;

  /// No description provided for @serverInformationServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Server information'**
  String get serverInformationServerDetail;

  /// No description provided for @currentMetricsServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Current metrics'**
  String get currentMetricsServerDetail;

  /// No description provided for @cpuServerDetail.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get cpuServerDetail;

  /// No description provided for @ramServerDetail.
  ///
  /// In en, this message translates to:
  /// **'RAM'**
  String get ramServerDetail;

  /// No description provided for @detailedMetricsServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Detailed metrics'**
  String get detailedMetricsServerDetail;

  /// No description provided for @linuxConsoleServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Linux console'**
  String get linuxConsoleServerDetail;

  /// No description provided for @serverLogsServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Server logs'**
  String get serverLogsServerDetail;

  /// No description provided for @creatingServerBackupServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Creating a server backup'**
  String get creatingServerBackupServerDetail;

  /// No description provided for @hServerDetail.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hServerDetail;

  /// No description provided for @mServerDetail.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get mServerDetail;

  /// No description provided for @worksServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Works:'**
  String get worksServerDetail;

  /// No description provided for @launchedServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Launched:'**
  String get launchedServerDetail;

  /// No description provided for @connectedToLinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Connected to'**
  String get connectedToLinuxConsole;

  /// No description provided for @connectionErrorLinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Connection Error:'**
  String get connectionErrorLinuxConsole;

  /// No description provided for @failedToConnect1LinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect:'**
  String get failedToConnect1LinuxConsole;

  /// No description provided for @sshSessionEndedLinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'SSH session ended'**
  String get sshSessionEndedLinuxConsole;

  /// No description provided for @shellStartupErrorLinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Shell startup error:'**
  String get shellStartupErrorLinuxConsole;

  /// No description provided for @disconnectedFromServerLinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Disconnected from server'**
  String get disconnectedFromServerLinuxConsole;

  /// No description provided for @consoleLinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Console'**
  String get consoleLinuxConsole;

  /// No description provided for @disconnectLinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnectLinuxConsole;

  /// No description provided for @reconnectLinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get reconnectLinuxConsole;

  /// No description provided for @failedToConnect2LinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect'**
  String get failedToConnect2LinuxConsole;

  /// No description provided for @unknownErrorLinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownErrorLinuxConsole;

  /// No description provided for @tryAgainLinuxConsole.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgainLinuxConsole;

  /// No description provided for @autoscrollIsEnabledServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Autoscroll enabled'**
  String get autoscrollIsEnabledServerLogs;

  /// No description provided for @autoscrollIsDisabledServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Autoscroll disabled'**
  String get autoscrollIsDisabledServerLogs;

  /// No description provided for @refreshLogsServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshLogsServerLogs;

  /// No description provided for @logsUpdatedServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Logs updated'**
  String get logsUpdatedServerLogs;

  /// No description provided for @clearLogsServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear logs'**
  String get clearLogsServerLogs;

  /// No description provided for @exportLogsServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportLogsServerLogs;

  /// No description provided for @searchInLogsServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Search in logs...'**
  String get searchInLogsServerLogs;

  /// No description provided for @logsInfoServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Showing \$filtered of \$total entries'**
  String get logsInfoServerLogs;

  /// No description provided for @noResultsFoundServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get noResultsFoundServerLogs;

  /// No description provided for @noLogsToDisplayServerLogs.
  ///
  /// In en, this message translates to:
  /// **'No logs to display'**
  String get noLogsToDisplayServerLogs;

  /// No description provided for @timeServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeServerLogs;

  /// No description provided for @sourceServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceServerLogs;

  /// No description provided for @messageServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Message:'**
  String get messageServerLogs;

  /// No description provided for @copyToClipboardServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyToClipboardServerLogs;

  /// No description provided for @copiedToClipboardServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboardServerLogs;

  /// No description provided for @closeServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeServerLogs;

  /// No description provided for @exportLogsTitleServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Export logs'**
  String get exportLogsTitleServerLogs;

  /// No description provided for @exportComingSoonServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Export feature will be implemented later.\n\nAvailable formats:\n• TXT\n• JSON\n• CSV'**
  String get exportComingSoonServerLogs;

  /// No description provided for @understoodServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get understoodServerLogs;

  /// No description provided for @shownServerLogs.
  ///
  /// In en, this message translates to:
  /// **'shown'**
  String get shownServerLogs;

  /// No description provided for @fromServerLogs.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get fromServerLogs;

  /// No description provided for @recordsServerLogs.
  ///
  /// In en, this message translates to:
  /// **'records'**
  String get recordsServerLogs;

  /// No description provided for @logsServerLogs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logsServerLogs;

  /// No description provided for @metricsMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get metricsMetricsFragment;

  /// No description provided for @cpuMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get cpuMetricsFragment;

  /// No description provided for @memoryMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memoryMetricsFragment;

  /// No description provided for @overviewMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewMetricsFragment;

  /// No description provided for @cpuLoadLast10MeasurementsMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'CPU load (last 10 measurements)'**
  String get cpuLoadLast10MeasurementsMetricsFragment;

  /// No description provided for @ramUsageLast10MeasurementsMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'RAM usage (last 10 measurements)'**
  String get ramUsageLast10MeasurementsMetricsFragment;

  /// No description provided for @metricsOverviewMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'Metrics overview'**
  String get metricsOverviewMetricsFragment;

  /// No description provided for @ramMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'RAM'**
  String get ramMetricsFragment;

  /// No description provided for @statisticsMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsMetricsFragment;

  /// No description provided for @averageCpuMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'Average CPU'**
  String get averageCpuMetricsFragment;

  /// No description provided for @averageRamMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'Average RAM'**
  String get averageRamMetricsFragment;

  /// No description provided for @maxCpuMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'Max CPU'**
  String get maxCpuMetricsFragment;

  /// No description provided for @maxRamMetricsFragment.
  ///
  /// In en, this message translates to:
  /// **'Max RAM'**
  String get maxRamMetricsFragment;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginTitle;

  /// No description provided for @authIdentityLabel.
  ///
  /// In en, this message translates to:
  /// **'Email, username or phone'**
  String get authIdentityLabel;

  /// No description provided for @authIdentityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your identity'**
  String get authIdentityHint;

  /// No description provided for @authIdentityRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email, username or phone'**
  String get authIdentityRequired;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordRequired;

  /// No description provided for @authRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get authRememberMe;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginButton;

  /// No description provided for @authRegisterLink.
  ///
  /// In en, this message translates to:
  /// **'No account? Create one'**
  String get authRegisterLink;

  /// No description provided for @authGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authGenericError;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authRegisterTitle;

  /// No description provided for @authUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsernameLabel;

  /// No description provided for @authUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a username'**
  String get authUsernameRequired;

  /// No description provided for @authEmailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get authEmailOptionalLabel;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authPasswordTooShort;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the terms of use'**
  String get authAcceptTerms;

  /// No description provided for @authCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccountButton;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authBackToLogin;

  /// No description provided for @authAcceptTermsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms of use'**
  String get authAcceptTermsError;

  /// No description provided for @profileJoinedLabel.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get profileJoinedLabel;

  /// No description provided for @profileNodesLabel.
  ///
  /// In en, this message translates to:
  /// **'Nodes online/total'**
  String get profileNodesLabel;

  /// No description provided for @profileDiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Average disk load'**
  String get profileDiskLabel;

  /// No description provided for @profileBackupsLabel.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get profileBackupsLabel;

  /// No description provided for @profileCrashesLabel.
  ///
  /// In en, this message translates to:
  /// **'Crashes in 24h'**
  String get profileCrashesLabel;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile data'**
  String get profileLoadError;

  /// No description provided for @retryCommon.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryCommon;

  /// No description provided for @serverListLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load nodes and servers'**
  String get serverListLoadError;

  /// No description provided for @serverListNodesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nodes'**
  String get serverListNodesSectionTitle;

  /// No description provided for @serverListNodeRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get serverListNodeRoleLabel;

  /// No description provided for @serverListNodeAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get serverListNodeAddressLabel;

  /// No description provided for @serverListNodeServersLabel.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get serverListNodeServersLabel;

  /// No description provided for @serverListNoNodes.
  ///
  /// In en, this message translates to:
  /// **'No nodes are available for your account yet.'**
  String get serverListNoNodes;

  /// No description provided for @serverListEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'This account does not have any Minecraft servers yet.'**
  String get serverListEmptyDescription;

  /// No description provided for @serverListReadOnlyRole.
  ///
  /// In en, this message translates to:
  /// **'Read-only access'**
  String get serverListReadOnlyRole;

  /// No description provided for @serverActionStartedMessage.
  ///
  /// In en, this message translates to:
  /// **'Start command sent'**
  String get serverActionStartedMessage;

  /// No description provided for @serverActionStoppedMessage.
  ///
  /// In en, this message translates to:
  /// **'Stop command sent'**
  String get serverActionStoppedMessage;

  /// No description provided for @serverActionRestartedMessage.
  ///
  /// In en, this message translates to:
  /// **'Restart command sent'**
  String get serverActionRestartedMessage;

  /// No description provided for @serverStatusStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get serverStatusStarting;

  /// No description provided for @serverStatusStopping.
  ///
  /// In en, this message translates to:
  /// **'Stopping'**
  String get serverStatusStopping;

  /// No description provided for @serverStatusRestarting.
  ///
  /// In en, this message translates to:
  /// **'Restarting'**
  String get serverStatusRestarting;

  /// No description provided for @serverStatusDeploying.
  ///
  /// In en, this message translates to:
  /// **'Deploying'**
  String get serverStatusDeploying;

  /// No description provided for @serverStatusUndeployed.
  ///
  /// In en, this message translates to:
  /// **'Undeployed'**
  String get serverStatusUndeployed;

  /// No description provided for @serverStatusCrashed.
  ///
  /// In en, this message translates to:
  /// **'Crashed'**
  String get serverStatusCrashed;

  /// No description provided for @serverStatusError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get serverStatusError;

  /// No description provided for @nodeDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Node'**
  String get nodeDetailTitle;

  /// No description provided for @nodeDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load node details'**
  String get nodeDetailLoadError;

  /// No description provided for @nodeDetailOsLabel.
  ///
  /// In en, this message translates to:
  /// **'Operating system'**
  String get nodeDetailOsLabel;

  /// No description provided for @nodeDetailSshUserLabel.
  ///
  /// In en, this message translates to:
  /// **'SSH user'**
  String get nodeDetailSshUserLabel;

  /// No description provided for @nodeDetailSshPortLabel.
  ///
  /// In en, this message translates to:
  /// **'SSH port'**
  String get nodeDetailSshPortLabel;

  /// No description provided for @nodeDetailAuthLabel.
  ///
  /// In en, this message translates to:
  /// **'Auth type'**
  String get nodeDetailAuthLabel;

  /// No description provided for @nodeDetailDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get nodeDetailDescriptionLabel;

  /// No description provided for @nodeDetailUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Live usage'**
  String get nodeDetailUsageTitle;

  /// No description provided for @nodeDetailDiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Disk'**
  String get nodeDetailDiskLabel;

  /// No description provided for @nodeDetailContainersLabel.
  ///
  /// In en, this message translates to:
  /// **'Containers'**
  String get nodeDetailContainersLabel;

  /// No description provided for @nodeDetailNetworkRxLabel.
  ///
  /// In en, this message translates to:
  /// **'Network RX'**
  String get nodeDetailNetworkRxLabel;

  /// No description provided for @nodeDetailNetworkTxLabel.
  ///
  /// In en, this message translates to:
  /// **'Network TX'**
  String get nodeDetailNetworkTxLabel;

  /// No description provided for @nodeDetailCollectedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Collected at'**
  String get nodeDetailCollectedAtLabel;

  /// No description provided for @nodeDetailHardwareTitle.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get nodeDetailHardwareTitle;

  /// No description provided for @nodeDetailCpuLabel.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get nodeDetailCpuLabel;

  /// No description provided for @nodeDetailCoresLabel.
  ///
  /// In en, this message translates to:
  /// **'Cores / threads'**
  String get nodeDetailCoresLabel;

  /// No description provided for @nodeDetailRamTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'RAM total'**
  String get nodeDetailRamTotalLabel;

  /// No description provided for @nodeDetailKernelLabel.
  ///
  /// In en, this message translates to:
  /// **'Kernel'**
  String get nodeDetailKernelLabel;

  /// No description provided for @nodeDetailGpuLabel.
  ///
  /// In en, this message translates to:
  /// **'GPU'**
  String get nodeDetailGpuLabel;

  /// No description provided for @nodeDetailScannedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Scanned at'**
  String get nodeDetailScannedAtLabel;

  /// No description provided for @nodeDetailDisksTitle.
  ///
  /// In en, this message translates to:
  /// **'Disks'**
  String get nodeDetailDisksTitle;

  /// No description provided for @nodeDetailServersTitle.
  ///
  /// In en, this message translates to:
  /// **'Minecraft servers'**
  String get nodeDetailServersTitle;

  /// No description provided for @nodeDetailNoServers.
  ///
  /// In en, this message translates to:
  /// **'No Minecraft servers are linked to this node.'**
  String get nodeDetailNoServers;

  /// No description provided for @nodeDetailSectionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This section is unavailable on the backend right now.'**
  String get nodeDetailSectionUnavailable;

  /// No description provided for @commonUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get commonUnavailable;

  /// No description provided for @commonEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get commonEnabled;

  /// No description provided for @commonDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get commonDisabled;

  /// No description provided for @serverActionRedeployedMessage.
  ///
  /// In en, this message translates to:
  /// **'Redeploy started'**
  String get serverActionRedeployedMessage;

  /// No description provided for @serverDetailRedeployAction.
  ///
  /// In en, this message translates to:
  /// **'Redeploy'**
  String get serverDetailRedeployAction;

  /// No description provided for @serverConsoleServerDetail.
  ///
  /// In en, this message translates to:
  /// **'Server console'**
  String get serverConsoleServerDetail;

  /// No description provided for @serverBackupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get serverBackupsTitle;

  /// No description provided for @serverDetailDeployTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Deploy target'**
  String get serverDetailDeployTargetLabel;

  /// No description provided for @serverDetailPortLabel.
  ///
  /// In en, this message translates to:
  /// **'Game port'**
  String get serverDetailPortLabel;

  /// No description provided for @serverDetailBackupsEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Backups enabled'**
  String get serverDetailBackupsEnabledLabel;

  /// No description provided for @metricsUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Metrics are not available for this server yet.'**
  String get metricsUnavailableMessage;

  /// No description provided for @serverDetailReadOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'This server is available in read-only mode on mobile.'**
  String get serverDetailReadOnlyHint;

  /// No description provided for @metricsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load metrics'**
  String get metricsLoadError;

  /// No description provided for @logsLiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Live stream active'**
  String get logsLiveStatus;

  /// No description provided for @serverConsoleCommandHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a console command'**
  String get serverConsoleCommandHint;

  /// No description provided for @serverConsoleReadOnlyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your role allows viewing console output, but not sending commands.'**
  String get serverConsoleReadOnlyMessage;

  /// No description provided for @backupsCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup creation started'**
  String get backupsCreateSuccess;

  /// No description provided for @backupsRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get backupsRestoreTitle;

  /// No description provided for @backupsRestoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup to the server?'**
  String get backupsRestoreConfirm;

  /// No description provided for @backupsRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupsRestoreSuccess;

  /// No description provided for @backupsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete backup'**
  String get backupsDeleteTitle;

  /// No description provided for @backupsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this backup permanently?'**
  String get backupsDeleteConfirm;

  /// No description provided for @backupsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup deleted'**
  String get backupsDeleteSuccess;

  /// No description provided for @confirmCommon.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmCommon;

  /// No description provided for @backupsCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get backupsCreateAction;

  /// No description provided for @backupsFeatureDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups are disabled for this server. You can still review existing backups.'**
  String get backupsFeatureDisabledMessage;

  /// No description provided for @serverBackupsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No backups available yet.'**
  String get serverBackupsEmpty;

  /// No description provided for @serverBackupsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load backups'**
  String get serverBackupsLoadError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
