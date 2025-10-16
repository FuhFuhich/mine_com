import 'package:flutter/material.dart';

class SettingsFragment extends StatefulWidget {
  const SettingsFragment({super.key});

  @override
  State<SettingsFragment> createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  bool notificationsEnabled = true;
  bool darkTheme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        title: const Text('Настройки'),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            activeThumbColor: const Color(0xFF00E676),
            title: const Text('Уведомления', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Получать уведомления о статусе серверов',
                style: TextStyle(color: Color(0xFFBBBBBB))),
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() => notificationsEnabled = val);
              // здесь будет включение отключение уведомлений
            },
          ),
          const Divider(color: Color(0xFF333333)),
          SwitchListTile(
            activeThumbColor: const Color(0xFF00E676),
            title: const Text('Тёмная тема', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Изменить внешний вид приложения',
                style: TextStyle(color: Color(0xFFBBBBBB))),
            value: darkTheme,
            onChanged: (val) {
              setState(() => darkTheme = val);
              // здесь будет смена темы
            },
          ),
          const Divider(color: Color(0xFF333333)),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF00E676)),
            title: const Text('Выйти из аккаунта', style: TextStyle(color: Colors.white)),
            onTap: () {
              // также здесь будет выход из аккаунта
            },
          ),
        ],
      ),
    );
  }
}
