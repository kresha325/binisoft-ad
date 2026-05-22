import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../providers/auth_providers.dart';

/// Logged-in users can request a Firebase password-reset link to their account email.
class AccountPasswordSection extends ConsumerStatefulWidget {
  const AccountPasswordSection({super.key});

  @override
  ConsumerState<AccountPasswordSection> createState() => _AccountPasswordSectionState();
}

class _AccountPasswordSectionState extends ConsumerState<AccountPasswordSection> {
  var _sending = false;

  Future<void> _sendReset() async {
    final email = ref.read(authStateProvider).valueOrNull?.email;
    if (email == null || email.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref.read(authControllerProvider.notifier).sendPasswordReset(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.forgotPasswordSentSnackbar)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authErrorMessage(e)),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final email = ref.watch(authStateProvider).valueOrNull?.email ?? '';

    return AppSectionCard(
      title: l10n.accountPasswordTitle,
      subtitle: l10n.accountPasswordSubtitle,
      icon: Icons.lock_reset_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (email.isNotEmpty)
            Text(
              email,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            l10n.accountPasswordNote,
            style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted, height: 1.4),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _sending || email.isEmpty ? null : _sendReset,
              icon: _sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.mail_outline, size: 18),
              label: Text(l10n.accountPasswordSendLink),
            ),
          ),
        ],
      ),
    );
  }
}
