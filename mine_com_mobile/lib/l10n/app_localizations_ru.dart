// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settings => 'Настройки';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get darkTheme => 'Темная тема';

  @override
  String get darkThemeSubtitle => 'Изменить внешний вид приложения';

  @override
  String get language => 'Язык';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notificationsSubtitle => 'Получать уведомления о статусе серверов';

  @override
  String get aboutApp => 'О приложении';

  @override
  String versionLabel(String version) {
    return 'Версия $version';
  }

  @override
  String get helpSupport => 'Помощь и поддержка';

  @override
  String get helpSupportSubtitle => 'Документация и FAQ';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privacyPolicySubtitle => 'Условия использования';

  @override
  String get account => 'Аккаунт';

  @override
  String get security => 'Безопасность';

  @override
  String get securitySubtitle => 'Пароль и двухфакторная аутентификация';

  @override
  String get logout => 'Выйти из аккаунта';

  @override
  String get logoutTitle => 'Выход из аккаунта';

  @override
  String get logoutConfirm => 'Вы уверены, что хотите выйти из аккаунта?';

  @override
  String get cancel => 'Отмена';

  @override
  String get close => 'Закрыть';

  @override
  String get openHelp => 'Открыть справку';

  @override
  String get privacyPolicyAction => 'Политика конфиденциальности';

  @override
  String get securityAction => 'Настройки безопасности';

  @override
  String get appDescription =>
      'Программный комплекс автоматизации развертывания и управления Minecraft-серверами';

  @override
  String get featuresTitle => 'Возможности:';

  @override
  String get featureSsh => 'SSH консоль для управления';

  @override
  String get featureMonitoring => 'Мониторинг метрик в реальном времени';

  @override
  String get featureLogs => 'Просмотр логов серверов';

  @override
  String get featureAutomation => 'Автоматизация развертывания';

  @override
  String get featureBackups => 'Управление бэкапами';

  @override
  String get version => 'Версия';

  @override
  String get platform => 'Платформа';

  @override
  String get platformValue => 'Unix-подобные системы';

  @override
  String get developer => 'Разработчик';

  @override
  String get developerValue => 'Minecraft Manager Team';

  @override
  String get settingsMainMenu => 'Настройки';

  @override
  String get serversMainMenu => 'Серверы';

  @override
  String get profileMainMenu => 'Профиль';

  @override
  String get onlineServerList => 'Онлайн';

  @override
  String get offlineServerList => 'Офлайн';

  @override
  String get playersServerList => 'игроков';

  @override
  String get launchServerList => 'Запустить';

  @override
  String get stopServerList => 'Остановить';

  @override
  String get restartServerList => 'Перезапустить';

  @override
  String get searchingForServersServerList => 'Поиск серверов...';

  @override
  String get clearServerList => 'Очистить';

  @override
  String get refreshServerListServerList => 'Обновление списка серверов';

  @override
  String get refreshServerList => 'Обновить';

  @override
  String get closeSearchServerList => 'Закрыть поиск';

  @override
  String get searchServerList => 'Поиск';

  @override
  String get noServersFoundServerList => 'Серверы не найдены';

  @override
  String get noServersServerList => 'Нет серверов';

  @override
  String get tryChangingYourQueryServerList => 'Попробуйте изменить запрос';

  @override
  String get addNewServerServerList => 'Добавьте новый сервер';

  @override
  String get totalServersProfile => 'Всего серверов';

  @override
  String get onlineProfile => 'Онлайн';

  @override
  String get playersProfile => 'игроков';

  @override
  String get playerProfile => 'Игрок';

  @override
  String get serverOverviewProfile => 'Обзор серверов';

  @override
  String get averageCpuLoadProfile => 'Средняя нагрузка CPU';

  @override
  String get averageNumberOfPlayersProfile => 'Среднее количество игроков';

  @override
  String get averageRamLoadProfile => 'Средняя нагрузка RAM';

  @override
  String get mostPopularServerProfile => 'Самый популярный сервер';

  @override
  String get sshConnectionsProfile => 'SSH-подключения';

  @override
  String get keyAndSessionManagementProfile => 'Управление ключами и сессиями';

  @override
  String get activityHistoryProfile => 'История активности';

  @override
  String get operationAndChangeLogProfile => 'Журнал операций и изменений';

  @override
  String get serverStatusProfile => 'Статус сервера';

  @override
  String get plProfile => 'игр.';

  @override
  String get editprofile1Profile => 'Редактировать профиль';

  @override
  String get editProfileProfile => 'Редактирование профиля';

  @override
  String get administratorProfile => 'Администратор';

  @override
  String get systemadministratorProfile => 'Системный администратор';

  @override
  String get detailedstatisticsProfile => 'детальная статистика';

  @override
  String get startServerDetailServerDetail => 'Запуск';

  @override
  String get stopServerDetail => 'Стоп';

  @override
  String get restartServerDetail => 'Перезагрузка';

  @override
  String get onlineServerDetail => 'Онлайн';

  @override
  String get serverStatusServerDetail => 'Статус сервера';

  @override
  String get minecraftVersionServerDetail => 'Версия Minecraft';

  @override
  String get modLoaderServerDetail => 'Mod Loader';

  @override
  String get activePlayersServerDetail => 'Активные игроки';

  @override
  String get dedicatedCoresServerDetail => 'Выделенные ядра';

  @override
  String get dedicatedRamServerDetail => 'Выделенная ОП';

  @override
  String get serverInformationServerDetail => 'Информация о сервере';

  @override
  String get currentMetricsServerDetail => 'Текущие метрики';

  @override
  String get cpuServerDetail => 'CPU';

  @override
  String get ramServerDetail => 'Оперативная память';

  @override
  String get detailedMetricsServerDetail => 'Подробные метрики';

  @override
  String get linuxConsoleServerDetail => 'Консоль Linux';

  @override
  String get serverLogsServerDetail => 'Логи сервера';

  @override
  String get creatingServerBackupServerDetail => 'Создание бэкапа сервера';

  @override
  String get hServerDetail => 'ч';

  @override
  String get mServerDetail => 'м';

  @override
  String get worksServerDetail => 'Работает:';

  @override
  String get launchedServerDetail => 'Запущен:';

  @override
  String get connectedToLinuxConsole => 'Подключение к';

  @override
  String get connectionErrorLinuxConsole => 'Ошибка подключения:';

  @override
  String get failedToConnect1LinuxConsole => 'Не удалось подключиться:';

  @override
  String get sshSessionEndedLinuxConsole => 'SSH сессия завершена';

  @override
  String get shellStartupErrorLinuxConsole => 'Ошибка запуска shell:';

  @override
  String get disconnectedFromServerLinuxConsole => 'Отключено от сервера';

  @override
  String get consoleLinuxConsole => 'Консоль';

  @override
  String get disconnectLinuxConsole => 'Отключиться';

  @override
  String get reconnectLinuxConsole => 'Переподключиться';

  @override
  String get failedToConnect2LinuxConsole => 'Не удалось подключиться';

  @override
  String get unknownErrorLinuxConsole => 'Неизвестная ошибка';

  @override
  String get tryAgainLinuxConsole => 'Попробовать снова';

  @override
  String get autoscrollIsEnabledServerLogs => 'Автопрокрутка включена';

  @override
  String get autoscrollIsDisabledServerLogs => 'Автопрокрутка выключена';

  @override
  String get refreshLogsServerLogs => 'Обновить';

  @override
  String get logsUpdatedServerLogs => 'Логи обновлены';

  @override
  String get clearLogsServerLogs => 'Очистить логи';

  @override
  String get exportLogsServerLogs => 'Экспортировать';

  @override
  String get searchInLogsServerLogs => 'Поиск в логах...';

  @override
  String get logsInfoServerLogs => 'Показано \$filtered из \$total записей';

  @override
  String get noResultsFoundServerLogs => 'Ничего не найдено';

  @override
  String get noLogsToDisplayServerLogs => 'Нет логов для отображения';

  @override
  String get timeServerLogs => 'Время';

  @override
  String get sourceServerLogs => 'Источник';

  @override
  String get messageServerLogs => 'Сообщение:';

  @override
  String get copyToClipboardServerLogs => 'Копировать';

  @override
  String get copiedToClipboardServerLogs => 'Скопировано в буфер обмена';

  @override
  String get closeServerLogs => 'Закрыть';

  @override
  String get exportLogsTitleServerLogs => 'Экспорт логов';

  @override
  String get exportComingSoonServerLogs =>
      'Функция экспорта будет реализована позже.\n\nБудет доступен экспорт в форматы:\n• TXT\n• JSON\n• CSV';

  @override
  String get understoodServerLogs => 'Понятно';

  @override
  String get shownServerLogs => 'Показано';

  @override
  String get fromServerLogs => 'из';

  @override
  String get recordsServerLogs => 'записей';

  @override
  String get logsServerLogs => 'Логи';

  @override
  String get metricsMetricsFragment => 'Метрики';

  @override
  String get cpuMetricsFragment => 'CPU';

  @override
  String get memoryMetricsFragment => 'Память';

  @override
  String get overviewMetricsFragment => 'Обзор';

  @override
  String get cpuLoadLast10MeasurementsMetricsFragment =>
      'Нагрузка CPU (последние 10 измерений)';

  @override
  String get ramUsageLast10MeasurementsMetricsFragment =>
      'Использование ОП (последние 10 измерений)';

  @override
  String get metricsOverviewMetricsFragment => 'Общий обзор метрик';

  @override
  String get ramMetricsFragment => 'ОП';

  @override
  String get statisticsMetricsFragment => 'Статистика';

  @override
  String get averageCpuMetricsFragment => 'Среднее CPU';

  @override
  String get averageRamMetricsFragment => 'Среднее ОП';

  @override
  String get maxCpuMetricsFragment => 'Макс CPU';

  @override
  String get maxRamMetricsFragment => 'Макс ОП';

  @override
  String get authLoginTitle => 'Вход в аккаунт';

  @override
  String get authIdentityLabel => 'Email, логин или телефон';

  @override
  String get authIdentityHint => 'Введите идентификатор';

  @override
  String get authIdentityRequired => 'Введите email, логин или телефон';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authPasswordRequired => 'Введите пароль';

  @override
  String get authRememberMe => 'Запомнить меня';

  @override
  String get authLoginButton => 'Войти';

  @override
  String get authRegisterLink => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get authGenericError => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String get authRegisterTitle => 'Создание аккаунта';

  @override
  String get authUsernameLabel => 'Логин';

  @override
  String get authUsernameRequired => 'Введите логин';

  @override
  String get authEmailOptionalLabel => 'Email (необязательно)';

  @override
  String get authEmailInvalid => 'Введите корректный email';

  @override
  String get authPasswordTooShort => 'Пароль должен быть не короче 6 символов';

  @override
  String get authConfirmPasswordLabel => 'Повторите пароль';

  @override
  String get authPasswordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get authAcceptTerms => 'Я принимаю условия использования';

  @override
  String get authCreateAccountButton => 'Создать аккаунт';

  @override
  String get authBackToLogin => 'Уже есть аккаунт? Войти';

  @override
  String get authAcceptTermsError => 'Примите условия использования';

  @override
  String get profileJoinedLabel => 'Зарегистрирован';

  @override
  String get profileNodesLabel => 'Ноды онлайн/всего';

  @override
  String get profileDiskLabel => 'Средняя нагрузка диска';

  @override
  String get profileBackupsLabel => 'Бэкапы';

  @override
  String get profileCrashesLabel => 'Сбоев за 24ч';

  @override
  String get profileLoadError => 'Не удалось загрузить профиль';

  @override
  String get retryCommon => 'Повторить';

  @override
  String get serverListLoadError => 'Не удалось загрузить ноды и серверы';

  @override
  String get serverListNodesSectionTitle => 'Ноды';

  @override
  String get serverListNodeRoleLabel => 'Роль';

  @override
  String get serverListNodeAddressLabel => 'Адрес';

  @override
  String get serverListNodeServersLabel => 'Серверы';

  @override
  String get serverListNoNodes => 'Для этого аккаунта пока нет доступных нод.';

  @override
  String get serverListEmptyDescription =>
      'У этого аккаунта пока нет доступных Minecraft-серверов.';

  @override
  String get serverListReadOnlyRole => 'Только просмотр';

  @override
  String get serverActionStartedMessage => 'Команда запуска отправлена';

  @override
  String get serverActionStoppedMessage => 'Команда остановки отправлена';

  @override
  String get serverActionRestartedMessage => 'Команда перезапуска отправлена';

  @override
  String get serverStatusStarting => 'Запускается';

  @override
  String get serverStatusStopping => 'Останавливается';

  @override
  String get serverStatusRestarting => 'Перезапускается';

  @override
  String get serverStatusDeploying => 'Разворачивается';

  @override
  String get serverStatusUndeployed => 'Не развернут';

  @override
  String get serverStatusCrashed => 'Упал';

  @override
  String get serverStatusError => 'Ошибка';

  @override
  String get nodeDetailTitle => 'Нода';

  @override
  String get nodeDetailLoadError => 'Не удалось загрузить данные ноды';

  @override
  String get nodeDetailOsLabel => 'Операционная система';

  @override
  String get nodeDetailSshUserLabel => 'SSH-пользователь';

  @override
  String get nodeDetailSshPortLabel => 'SSH-порт';

  @override
  String get nodeDetailAuthLabel => 'Тип авторизации';

  @override
  String get nodeDetailDescriptionLabel => 'Описание';

  @override
  String get nodeDetailUsageTitle => 'Текущая загрузка';

  @override
  String get nodeDetailDiskLabel => 'Диск';

  @override
  String get nodeDetailContainersLabel => 'Контейнеры';

  @override
  String get nodeDetailNetworkRxLabel => 'Сеть RX';

  @override
  String get nodeDetailNetworkTxLabel => 'Сеть TX';

  @override
  String get nodeDetailCollectedAtLabel => 'Собрано';

  @override
  String get nodeDetailHardwareTitle => 'Аппаратная конфигурация';

  @override
  String get nodeDetailCpuLabel => 'CPU';

  @override
  String get nodeDetailCoresLabel => 'Ядра / потоки';

  @override
  String get nodeDetailRamTotalLabel => 'Всего RAM';

  @override
  String get nodeDetailKernelLabel => 'Ядро';

  @override
  String get nodeDetailGpuLabel => 'GPU';

  @override
  String get nodeDetailScannedAtLabel => 'Сканировано';

  @override
  String get nodeDetailDisksTitle => 'Диски';

  @override
  String get nodeDetailServersTitle => 'Minecraft-серверы';

  @override
  String get nodeDetailNoServers =>
      'К этой ноде не привязано ни одного Minecraft-сервера.';

  @override
  String get nodeDetailSectionUnavailable =>
      'Этот раздел сейчас недоступен на backend.';

  @override
  String get commonUnavailable => 'Недоступно';

  @override
  String get commonEnabled => 'Включено';

  @override
  String get commonDisabled => 'Выключено';

  @override
  String get serverActionRedeployedMessage => 'Переустановка запущена';

  @override
  String get serverDetailRedeployAction => 'Переустановить';

  @override
  String get serverConsoleServerDetail => 'Консоль сервера';

  @override
  String get serverBackupsTitle => 'Бэкапы';

  @override
  String get serverDetailDeployTargetLabel => 'Тип развертывания';

  @override
  String get serverDetailPortLabel => 'Игровой порт';

  @override
  String get serverDetailBackupsEnabledLabel => 'Бэкапы включены';

  @override
  String get metricsUnavailableMessage =>
      'Для этого сервера пока нет доступных метрик.';

  @override
  String get serverDetailReadOnlyHint =>
      'Этот сервер доступен в мобильной версии только для просмотра.';

  @override
  String get metricsLoadError => 'Не удалось загрузить метрики';

  @override
  String get logsLiveStatus => 'Live-стрим активен';

  @override
  String get serverConsoleCommandHint => 'Введите команду консоли';

  @override
  String get serverConsoleReadOnlyMessage =>
      'Ваша роль позволяет просматривать консоль, но не отправлять команды.';

  @override
  String get backupsCreateSuccess => 'Создание бэкапа запущено';

  @override
  String get backupsRestoreTitle => 'Восстановление бэкапа';

  @override
  String get backupsRestoreConfirm => 'Восстановить этот бэкап на сервер?';

  @override
  String get backupsRestoreSuccess => 'Бэкап восстановлен';

  @override
  String get backupsDeleteTitle => 'Удаление бэкапа';

  @override
  String get backupsDeleteConfirm => 'Удалить этот бэкап безвозвратно?';

  @override
  String get backupsDeleteSuccess => 'Бэкап удалён';

  @override
  String get confirmCommon => 'Подтвердить';

  @override
  String get backupsCreateAction => 'Создать бэкап';

  @override
  String get backupsFeatureDisabledMessage =>
      'Автоматические бэкапы для этого сервера выключены. Вы всё равно можете просматривать уже созданные бэкапы.';

  @override
  String get serverBackupsEmpty => 'Бэкапы пока отсутствуют.';

  @override
  String get serverBackupsLoadError => 'Не удалось загрузить бэкапы';
}
