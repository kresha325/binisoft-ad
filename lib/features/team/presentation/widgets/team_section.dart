import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/user_roles.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/l10n/role_l10n.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/user_role_badge.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/permissions_providers.dart';
import '../providers/team_providers.dart';

class TeamSection extends ConsumerStatefulWidget {
  const TeamSection({super.key});

  @override
  ConsumerState<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends ConsumerState<TeamSection> {
  final _email = TextEditingController();
  UserRole _inviteRole = UserRole.manager;
  var _busy = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _invite() async {
    final l10n = context.l10n;
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    final email = _email.text.trim();
    if (email.isEmpty) return;

    setState(() => _busy = true);
    try {
      final result = await ref.read(staffApiServiceProvider).inviteStaff(
            businessId: businessId,
            email: email,
            role: _inviteRole.value,
          );
      if (!mounted) return;
      _email.clear();
      final code = result['code'] as String?;
      if (code != null) {
        await Clipboard.setData(ClipboardData(text: code));
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            code != null
                ? l10n.teamInviteCreatedCopied(code)
                : l10n.teamInviteAssigned,
          ),
          duration: const Duration(seconds: 8),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorMessage(e)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove(String memberUid) async {
    final l10n = context.l10n;
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.teamRemoveTitle),
        content: Text(l10n.teamRemoveMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.teamRemoveConfirm)),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    try {
      await ref.read(staffApiServiceProvider).removeStaff(
            businessId: businessId,
            memberUid: memberUid,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.teamRemoved)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authErrorMessage(e)), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final perms = ref.watch(businessPermissionsProvider);
    if (!perms.canManageTeam) return const SizedBox.shrink();

    final membersAsync = ref.watch(teamMembersProvider);

    return AppSectionCard(
      title: l10n.teamSectionTitle,
      subtitle: l10n.teamSectionSubtitle,
      icon: Icons.groups_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: l10n.teamInviteEmail,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<UserRole>(
            value: _inviteRole,
            dropdownColor: colors.surface,
            decoration: InputDecoration(
              labelText: l10n.teamInviteRole,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: [
              DropdownMenuItem(
                value: UserRole.manager,
                child: Text(UserRole.manager.localizedLabel(l10n)),
              ),
              DropdownMenuItem(
                value: UserRole.employee,
                child: Text(UserRole.employee.localizedLabel(l10n)),
              ),
            ],
            onChanged: (v) => setState(() => _inviteRole = v ?? UserRole.manager),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: FilledButton.icon(
              onPressed: _busy ? null : _invite,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.person_add_outlined),
              label: Text(l10n.teamInviteButton),
            ),
          ),
          const SizedBox(height: 20),
          membersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(l10n.errorGeneric('$e'), style: TextStyle(color: colors.danger)),
            data: (members) {
              if (members.isEmpty) {
                return Text(
                  l10n.teamEmpty,
                  style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
                );
              }
              return Column(
                children: [
                  for (final m in members) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        m.displayName.isNotEmpty ? m.displayName : m.email,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(m.email, style: GoogleFonts.inter(fontSize: 12)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserRoleBadge(role: m.role, compact: true),
                          IconButton(
                            tooltip: l10n.teamRemoveConfirm,
                            onPressed: () => _remove(m.id),
                            icon: Icon(Icons.person_remove_outlined, color: colors.danger),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
