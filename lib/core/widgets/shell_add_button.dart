import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../layout/app_breakpoints.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';

/// Primary “Add …” action for shell page headers (full-width on mobile).
class ShellAddButton extends StatelessWidget {
  const ShellAddButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add_rounded,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final colors = context.appColors;

    final button = ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: context.isDarkMode ? const Color(0xFF0F172A) : Colors.white,
        elevation: 0,
        minimumSize: Size(isMobile ? double.infinity : 0, 44),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        ),
      ),
    );

    if (!isMobile) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
