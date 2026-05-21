import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/post_auth_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../data/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';
import '../widgets/register_pricing_card.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _displayName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onCreateAccountTap() async {
    if (!_formKey.currentState!.validate()) return;
    await _submit();
  }

  Future<void> _submit() async {
    try {
      final user = await ref.read(authControllerProvider.notifier).register(
            RegisterAdminInput(
              email: _email.text.trim(),
              password: _password.text,
              displayName: _displayName.text.trim().isEmpty
                  ? null
                  : _displayName.text.trim(),
            ),
          );
      if (!mounted) return;
      ref.invalidate(authStateProvider);
      navigateAfterAuth(GoRouter.of(context), user);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authErrorMessage(e)),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider).isLoading;
    final width = MediaQuery.sizeOf(context).width;
    final sideBySide = width >= 800;

    final colors = context.appColors;
    return AuthScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: BrandLogo(showTagline: true)),
                const SizedBox(height: 28),
                Text(
                  'Create admin account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Free account and app access. Payment is required only when you create a business (ATK invoice).',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted),
                ),
                const SizedBox(height: 28),
                if (sideBySide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: RegisterPricingCard()),
                      const SizedBox(width: 24),
                      Expanded(child: _buildForm(loading)),
                    ],
                  )
                else ...[
                  const RegisterPricingCard(),
                  const SizedBox(height: 24),
                  _buildForm(loading),
                ],
                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Log in',
                          style: GoogleFonts.inter(
                            color: colors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.go('/login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(bool loading) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        border: Border.all(color: colors.cardBorder),
        boxShadow: AppShadows.authCard,
      ),
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your details',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You will create your first business after signing in.',
              style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Name (optional)',
              controller: _displayName,
              hint: 'Your name',
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Email',
              controller: _email,
              hint: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || !v.contains('@') ? 'Invalid email' : null,
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Password',
              controller: _password,
              obscureText: true,
              validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: loading ? null : _onCreateAccountTap,
                child: loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Create free account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
