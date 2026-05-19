import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/post_auth_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_card.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _devApiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');

  static String _webDevLoginHint() {
    final origin = Uri.base.origin;
    if (_devApiKey.isNotEmpty) {
      final tail = _devApiKey.length >= 6 ? _devApiKey.substring(_devApiKey.length - 6) : _devApiKey;
      return 'Dev API key active (…$tail). Stop flutter run and use ./tool/dev_run_chrome.sh '
          'if login still shows key …UdGfU in Console.';
    }
    return 'WRONG KEY: still using production …UdGfU → 403. '
        '1) cp env/dev.json.example env/dev.json  2) paste NEW GCP key (None) '
        '3) q then ./tool/dev_run_chrome.sh (hot reload is NOT enough).';
  }

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final email = _email.text.trim().toLowerCase();
      final user = await ref.read(authControllerProvider.notifier).signIn(
            email,
            _password.text,
          );
      if (!mounted) return;
      // Let router + profile stream catch up (avoids mobile bounce back to /login).
      ref.invalidate(authStateProvider);
      navigateAfterAuth(
        GoRouter.of(context),
        user,
        loginEmail: email,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authErrorMessage(e)),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider).isLoading;

    return AuthCard(
      title: 'Log in',
      subtitle: 'Enter your credentials to access your dashboard',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'Email',
              controller: _email,
              hint: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v == null || !v.contains('@') ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Password',
              controller: _password,
              obscureText: true,
              validator: (v) =>
                  v == null || v.length < 6 ? 'Min 6 characters' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: loading ? null : _submit,
                child: loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Log in'),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: context.appColors.textMuted,
                  ),
                  children: [
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: 'Register',
                      style: GoogleFonts.inter(
                        color: context.appColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => context.go('/register'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => context.go('/join'),
                child: Text(context.l10n.loginJoinTeam),
              ),
            ),
            if (kDebugMode && kIsWeb) ...[
              const SizedBox(height: 20),
              Text(
                _webDevLoginHint(),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: context.appColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
