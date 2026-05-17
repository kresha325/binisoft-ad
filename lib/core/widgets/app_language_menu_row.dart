import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_locale_provider.dart';
import '../l10n/l10n_extension.dart';
import '../l10n/ui_locales.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_design.dart';

/// En / Sq / De toggle row for the burger menu.
class AppLanguageMenuRow extends ConsumerWidget {
  const AppLanguageMenuRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final current = resolveAppLocale(ref.watch(appLocaleProvider));
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.menuLanguage,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final locale in UiLocales.all) ...[
                if (locale != UiLocales.all.first) const SizedBox(width: 8),
                Expanded(
                  child: _LocaleChip(
                    label: UiLocales.menuBadge(locale),
                    selected: current == locale,
                    onTap: () =>
                        ref.read(appLocaleProvider.notifier).setLocale(locale),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _LocaleChip extends StatelessWidget {
  const _LocaleChip({
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
          padding: const EdgeInsets.symmetric(vertical: 10),
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
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: selected ? colors.accent : colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
