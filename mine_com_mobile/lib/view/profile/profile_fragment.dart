import 'package:flutter/material.dart';
import '../../model/user_model.dart';

class ProfileFragment extends StatelessWidget {
  const ProfileFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF00E676),
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Имя пользователя', // здесь будет загрузка имени
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'email@example.com', // здесь будет вывод почты
                style: const TextStyle(color: Color(0xFFBBBBBB)),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF404040)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.info_outline, color: Color(0xFF00E676)),
                  title: const Text(
                    'Информация профиля',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text('Статистика, серверы, активность',
                      style: TextStyle(color: Color(0xFFBBBBBB))),
                  onTap: () {
                    // здесь переход к расширенной информации профиля
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF00C853)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // здесь будет выход из аккаунта
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Выйти из аккаунта',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
