import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../providers/order_providers.dart';

class TopProductsSection extends ConsumerWidget {
  const TopProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final stats = ref.watch(productSalesStatsProvider);

    if (stats.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppSectionCard(
      title: l10n.topProductsTitle,
      subtitle: l10n.topProductsSubtitle,
      icon: Icons.leaderboard_outlined,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.topProductsColumnProduct,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.textMuted,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                SizedBox(
                  width: 56,
                  child: Text(
                    l10n.topProductsColumnQty,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.textMuted,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                SizedBox(
                  width: 72,
                  child: Text(
                    l10n.topProductsColumnRevenue,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.textMuted,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < stats.length && i < 10; i++) ...[
            if (i > 0) Divider(height: 1, color: colors.cardBorder),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      stats[i].productName,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 56,
                    child: Text(
                      '${stats[i].quantitySold}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.accent,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 72,
                    child: Text(
                      '€${stats[i].revenueEur.toStringAsFixed(2)}',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
