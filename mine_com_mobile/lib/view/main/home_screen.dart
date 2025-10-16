import 'package:flutter/material.dart';
import '../profile/profile_fragment.dart';
import '../servers/server_list_fragment.dart';
import '../settings/settings_fragment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  final List<Widget> _pages = const [
    ProfileFragment(),
    ServerListWrapper(),
    SettingsFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF222222),
        selectedItemColor: const Color(0xFF00E676),
        unselectedItemColor: const Color(0xFFBBBBBB),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Серверы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
