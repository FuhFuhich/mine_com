import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mine_com_mobile/l10n/app_localizations.dart';

import '../../provider/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _rememberIdentity = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedIdentity();
  }

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberedIdentity() async {
    final identity = await ref.read(authProvider.notifier).getRememberedIdentity();
    if (!mounted || identity == null || identity.isEmpty) {
      return;
    }

    _identityController.text = identity;
    setState(() => _rememberIdentity = true);
  }

  Future<void> _onLoginPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;

    try {
      await ref.read(authProvider.notifier).login(
            identity: _identityController.text.trim(),
            password: _passwordController.text,
            rememberIdentity: _rememberIdentity,
          );
    } catch (_) {
      if (!mounted) {
        return;
      }

      final message =
          ref.read(authProvider).errorMessage ?? l10n.authGenericError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        l10n.authLoginTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _identityController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.authIdentityLabel,
                          hintText: l10n.authIdentityHint,
                          prefixIcon: const Icon(Icons.alternate_email),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.authIdentityRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _onLoginPressed(),
                        decoration: InputDecoration(
                          labelText: l10n.authPasswordLabel,
                          prefixIcon: const Icon(Icons.key),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon:
                                Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.authPasswordRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberIdentity,
                            onChanged: (value) {
                              setState(() => _rememberIdentity = value ?? false);
                            },
                          ),
                          Text(l10n.authRememberMe),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed:
                            authState.isSubmitting ? null : _onLoginPressed,
                        child: authState.isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.authLoginButton),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: authState.isSubmitting
                            ? null
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                ),
                        child: Text(l10n.authRegisterLink),
                      ),
                      if (authState.errorMessage != null &&
                          authState.errorMessage!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          authState.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
