import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/user_roles.dart';
import '../l10n/l10n_extension.dart';
import '../l10n/role_l10n.dart';
import '../theme/app_color_scheme.dart';
class UserRoleBadge extends StatelessWidget {
  const UserRoleBadge({
    super.key,
    required this.role,
    this.compact = false,
  });

  final UserRole role;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isSuper = role.isSuperAdmin;
    final bg = isSuper ? colors.accentSoft : colors.chipBg;
    final fg = isSuper ? colors.accent : colors.textPrimary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSuper ? colors.accent.withValues(alpha: 0.4) : colors.cardBorder,
        ),
      ),
      child: Text(
        role.localizedLabel(context.l10n),
        style: GoogleFonts.inter(
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
