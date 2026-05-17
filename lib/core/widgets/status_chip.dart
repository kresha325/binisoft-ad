import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';

enum StatusChipTone { neutral, success, warning, danger, accent }

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = StatusChipTone.neutral,
    this.icon,
  });

  final String label;
  final StatusChipTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (bg, fg) = switch (tone) {
      StatusChipTone.success => (colors.success.withValues(alpha: 0.14), colors.success),
      StatusChipTone.warning => (const Color(0xFFF59E0B).withValues(alpha: 0.16), const Color(0xFFD97706)),
      StatusChipTone.danger => (colors.danger.withValues(alpha: 0.12), colors.danger),
      StatusChipTone.accent => (colors.accentSoft, colors.accent),
      StatusChipTone.neutral => (colors.chipBg, colors.textMuted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDesign.radiusSm),
        border: Border.all(color: fg.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
