import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/post_auth_navigation.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../data/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';
import '../../../team/presentation/providers/team_providers.dart';

class JoinTeamScreen extends ConsumerStatefulWidget {
  const JoinTeamScreen({super.key});

  @override
  ConsumerState<JoinTeamScreen> createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends ConsumerState<JoinTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  var _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;

    setState(() => _loading = true);
    try {
      final result =
          await ref.read(authControllerProvider.notifier).registerStaffAndAcceptInvite(
                input: RegisterStaffInput(
                  email: _email.text.trim(),
                  password: _password.text,
                  displayName:
                      _name.text.trim().isEmpty ? null : _name.text.trim(),
                ),
                inviteCode: _code.text.trim(),
                staffApi: ref.read(staffApiServiceProvider),
              );
      if (!mounted) return;
      ref.invalidate(authStateProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.joinTeamSuccess(result.businessName))),
      );
      navigateAfterAuth(GoRouter.of(context), result.user);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorMessage(e)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: BrandLogo()),
            const SizedBox(height: 28),
            Text(
              l10n.joinTeamTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.joinTeamSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted, height: 1.4),
            ),
            const SizedBox(height: 28),
            AppTextField(
              label: l10n.inviteCodeLabel,
              controller: _code,
            ),
            const SizedBox(height: 16),
            AppTextField(label: l10n.fieldLabel, controller: _name),
            const SizedBox(height: 16),
            AppTextField(
              label: l10n.teamInviteEmail,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Password *',
              controller: _password,
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.joinTeamButton),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/login'),
              child: Text(l10n.haveAccountLogin),
            ),
          ],
        ),
      ),
    );
  }
}
