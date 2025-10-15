import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _acceptTerms = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _password1Controller.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  void _toggleObscure1() {
    setState(() => _obscure1 = !_obscure1);
  }

  void _toggleObscure2() {
    setState(() => _obscure2 = !_obscure2);
  }

  void _onRegisterPressed() {
    // TODO: Добавить проверку корректности email с сервером
    // TODO: Добавить проверку уникальности email в базе данных
    // TODO: Добавить проверку сложности пароля на сервере
    // TODO: Отправить значение _rememberMe в базу данных
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Примите условия использования')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Регистрация: форма валидна (демо UI)')),
    );
  }

  void _goToLogin() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF141414), 
              Color(0xFF222222),
              Color(0xFF2A2A2A),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;
              final maxWidth = isWide ? 520.0 : double.infinity;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'Создание аккаунта',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Заполните данные для регистрации',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: const Color(0xFFBBBBBB),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF333333),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF404040),
                                ),
                              ),
                              child: TextFormField(
                                controller: _nameController,
                                autofillHints: const [AutofillHints.name],
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Имя',
                                  labelStyle: TextStyle(color: Color(0xFFBBBBBB)),
                                  prefixIcon: Icon(Icons.person_outline, color: Color(0xFFBBBBBB)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(12),
                                ),
                                validator: (v) {
                                  // TODO: Добавить проверку корректности имени на сервере
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Введите имя';
                                  }
                                  if (v.trim().length < 2) {
                                    return 'Слишком короткое имя';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF333333),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF404040),
                                ),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                autofillHints: const [AutofillHints.email],
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Color(0xFFBBBBBB)),
                                  prefixIcon: Icon(Icons.alternate_email, color: Color(0xFFBBBBBB)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(12),
                                ),
                                validator: (v) {
                                  // TODO: Добавить проверку уникальности email в базе данных
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Введите email';
                                  }
                                  final email = v.trim();
                                  final emailReg = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                                  if (!emailReg.hasMatch(email)) {
                                    return 'Некорректный email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF333333),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF404040),
                                ),
                              ),
                              child: TextFormField(
                                controller: _password1Controller,
                                autofillHints: const [AutofillHints.newPassword],
                                obscureText: _obscure1,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Пароль',
                                  labelStyle: const TextStyle(color: Color(0xFFBBBBBB)),
                                  prefixIcon: const Icon(Icons.key, color: Color(0xFFBBBBBB)),
                                  suffixIcon: IconButton(
                                    onPressed: _toggleObscure1,
                                    icon: Icon(
                                      _obscure1 ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                                      color: const Color(0xFFBBBBBB),
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Введите пароль';
                                  }
                                  if (v.length < 6) {
                                    return 'Минимум 6 символов';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF333333),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF404040),
                                ),
                              ),
                              child: TextFormField(
                                controller: _password2Controller,
                                obscureText: _obscure2,
                                textInputAction: TextInputAction.done,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Повторите пароль',
                                  labelStyle: const TextStyle(color: Color(0xFFBBBBBB)),
                                  prefixIcon: const Icon(Icons.key, color: Color(0xFFBBBBBB)),
                                  suffixIcon: IconButton(
                                    onPressed: _toggleObscure2,
                                    icon: Icon(
                                      _obscure2 ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                                      color: const Color(0xFFBBBBBB),
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                onFieldSubmitted: (_) => _onRegisterPressed(),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Повторите пароль';
                                  }
                                  if (v != _password1Controller.text) {
                                    return 'Пароли не совпадают';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                                  activeColor: const Color(0xFF00E676),
                                  checkColor: Colors.white,
                                ),
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      'Я принимаю Условия использования и Политику конфиденциальности',
                                      style: TextStyle(color: Color(0xFFBBBBBB)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (val) {
                                    setState(() => _rememberMe = val ?? false);
                                  },
                                  activeColor: const Color(0xFF00E676),
                                  checkColor: Colors.white,
                                ),
                                const Text(
                                  'Запомнить меня',
                                  style: TextStyle(color: Color(0xFFBBBBBB)),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00E676), 
                                    Color(0xFF00C853),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00E676).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _onRegisterPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Создать аккаунт',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF404040)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: OutlinedButton.icon(
                                onPressed: _goToLogin,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.login, color: Color(0xFFBBBBBB)),
                                label: const Text(
                                  'Уже есть аккаунт? Войти',
                                  style: TextStyle(color: Color(0xFFBBBBBB)),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
