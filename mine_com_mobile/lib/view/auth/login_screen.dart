import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() => _obscure = !_obscure);
  }

  void _onLoginPressed() {
    // TODO: Добавить проверку корректности email с сервером
    // TODO: Добавить проверку корректности пароля с базой данных
    // TODO: Отправить значение _rememberMe в базу данных
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Логин: форма валидна (демо UI)')),
      );
    }
  }

  void _goToRegister() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
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
                final maxWidth = isWide ? 420.0 : double.infinity;

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
                              const SizedBox(height: 40),
                              Text(
                                'Добро пожаловать',
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Войдите в свой аккаунт',
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: const Color(0xFFBBBBBB),
                                        ),
                              ),
                              const SizedBox(height: 48),
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
                                  autofillHints: const [
                                    AutofillHints.username,
                                    AutofillHints.email
                                  ],
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(color: Color(0xFFBBBBBB)),
                                    prefixIcon:
                                        Icon(Icons.alternate_email, color: Color(0xFFBBBBBB)),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                  validator: (v) {
                                    // TODO: Добавить проверку существования email в базе данных
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Введите email';
                                    }
                                    final email = v.trim();
                                    final emailReg =
                                        RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
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
                                  controller: _passwordController,
                                  autofillHints: const [AutofillHints.password],
                                  obscureText: _obscure,
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Пароль',
                                    labelStyle: const TextStyle(color: Color(0xFFBBBBBB)),
                                    prefixIcon:
                                        const Icon(Icons.key, color: Color(0xFFBBBBBB)),
                                    suffixIcon: IconButton(
                                      onPressed: _toggleObscure,
                                      icon: Icon(
                                        _obscure
                                            ? Icons.remove_red_eye_outlined
                                            : Icons.remove_red_eye,
                                        color: const Color(0xFFBBBBBB),
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(12),
                                  ),
                                  onFieldSubmitted: (_) => _onLoginPressed(),
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
                                      color:
                                          const Color(0xFF00E676).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _onLoginPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Войти',
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
                                  border:
                                      Border.all(color: const Color(0xFF404040)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: OutlinedButton.icon(
                                  onPressed: _goToRegister,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon:
                                      const Icon(Icons.person_add, color: Color(0xFFBBBBBB)),
                                  label: const Text(
                                    'Нет аккаунта? Зарегистрироваться',
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
      ),
    );
  }
}
