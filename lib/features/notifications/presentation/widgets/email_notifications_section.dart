import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/email_prefs.dart';

class EmailNotificationsSection extends ConsumerStatefulWidget {
  const EmailNotificationsSection({super.key});

  @override
  ConsumerState<EmailNotificationsSection> createState() =>
      _EmailNotificationsSectionState();
}

class _EmailNotificationsSectionState
    extends ConsumerState<EmailNotificationsSection> {
  EmailPrefs? _prefs;
  bool _saving = false;
  String? _loadedUid;

  Future<void> _loadPrefs(String uid) async {
    if (_loadedUid == uid && _prefs != null) return;
    _loadedUid = uid;
    final doc = await ref.read(firestoreProvider).collection('users').doc(uid).get();
    final data = doc.data();
    final map = data?['emailPrefs'] as Map<String, dynamic>?;
    if (mounted) {
      setState(() => _prefs = EmailPrefs.fromMap(map));
    }
  }

  Future<void> _save(EmailPrefs prefs) async {
    final uid = ref.read(authStateProvider).valueOrNull?.id;
    if (uid == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(firestoreProvider).collection('users').doc(uid).update({
        'emailPrefs': prefs.toMap(),
      });
      if (mounted) setState(() => _prefs = prefs);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user != null && _prefs == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadPrefs(user.id));
    }
    final prefs = _prefs ?? EmailPrefs.defaults;

    return AppSectionCard(
      title: 'Email notifications',
      subtitle:
          'Account emails for welcome, plan changes, and new businesses. '
          'Sent via Firebase Trigger Email (Firestore mail queue).',
      icon: Icons.mail_outline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_saving) ...[
            const LinearProgressIndicator(minHeight: 2),
            const SizedBox(height: 16),
          ],
          _SwitchRow(
            label: 'Account & welcome',
            subtitle: 'Registration confirmation',
            value: prefs.accountAlerts,
            onChanged: _saving ? null : (v) => _save(prefs.copyWith(accountAlerts: v)),
          ),
          const SizedBox(height: 12),
          _SwitchRow(
            label: 'Plan updates',
            subtitle: 'When you change subscription plan',
            value: prefs.planUpdates,
            onChanged: _saving ? null : (v) => _save(prefs.copyWith(planUpdates: v)),
          ),
          const SizedBox(height: 12),
          _SwitchRow(
            label: 'Business updates',
            subtitle: 'When you create a new business',
            value: prefs.businessUpdates,
            onChanged: _saving ? null : (v) => _save(prefs.copyWith(businessUpdates: v)),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
              ),
            ],
          ),
        ),
        Switch.adaptive(value: value, onChanged: onChanged),
      ],
    );
  }
}
