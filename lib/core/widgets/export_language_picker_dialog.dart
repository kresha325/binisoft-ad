import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/l10n_extension.dart';
import '../l10n/ui_locales.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';

/// Asks which language to use for PDF export (En / Sq / De).
Future<String?> showExportLanguagePicker(
  BuildContext context, {
  String initialCode = 'en',
}) {
  var selected =
      UiLocales.codes.contains(initialCode) ? initialCode : 'en';

  return showDialog<String>(
    context: context,
    builder: (ctx) {
      final colors = ctx.appColors;
      final l10n = ctx.l10n;
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            l10n.exportPickLanguageTitle,
            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.exportPickLanguageSubtitle,
                style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (final locale in UiLocales.all) ...[
                    if (locale != UiLocales.all.first) const SizedBox(width: 8),
                    Expanded(
                      child: _LangChip(
                        label: UiLocales.menuBadge(locale),
                        selected: selected == UiLocales.codeOf(locale),
                        onTap: () =>
                            setState(() => selected = UiLocales.codeOf(locale)),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, selected),
              child: Text(l10n.exportContinue),
            ),
          ],
        ),
      );
    },
  );
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: selected ? colors.accentSoft : colors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppDesign.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            border: Border.all(
              color: selected ? colors.accent : colors.cardBorder,
              width: selected ? 1.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? colors.accent : colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
