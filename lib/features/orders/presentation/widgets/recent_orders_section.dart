import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/app_section_card.dart';
import 'order_status_chip.dart';
import '../providers/order_providers.dart';
import 'order_customer_info.dart';
import 'order_detail_sheet.dart';
import 'order_product_lines_cell.dart';

class RecentOrdersSection extends ConsumerWidget {
  const RecentOrdersSection({super.key, this.limit = 10});

  final int limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final orders = ref.watch(ordersListProvider).valueOrNull ?? [];

    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }

    final recent = orders.take(limit).toList();

    return AppSectionCard(
      title: l10n.recentOrdersTitle,
      subtitle: l10n.recentOrdersSubtitle,
      icon: Icons.receipt_long_outlined,
      trailing: TextButton(
        onPressed: () => context.go('/orders'),
        child: Text(l10n.seeAll),
      ),
      child: Column(
        children: [
          for (var i = 0; i < recent.length; i++) ...[
            if (i > 0) Divider(height: 1, color: colors.cardBorder),
            InkWell(
              onTap: () => showOrderDetailSheet(context, recent[i]),
              borderRadius: BorderRadius.circular(AppDesign.radiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recent[i].orderNumber,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          OrderCustomerInfo(customer: recent[i].customer),
                          const SizedBox(height: 6),
                          OrderProductLinesCell(
                            lines: recent[i].lines,
                            maxWidth: double.infinity,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('d MMM, HH:mm').format(recent[i].createdAt),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '€${recent[i].subtotalEur.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: colors.accent,
                          ),
                        ),
                        const SizedBox(height: 6),
                        OrderStatusChip(status: recent[i].status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

}
