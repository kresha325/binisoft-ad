import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/post_auth_navigation.dart';
import '../../../../core/utils/web_boot_overlay.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => dismissWebBootOverlay());
  }

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
          ],
        ),
      ),
    );
  }
}
