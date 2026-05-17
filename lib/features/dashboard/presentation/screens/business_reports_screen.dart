import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/admin_page_layout.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/domain/order_status_l10n.dart';
import '../../../orders/presentation/providers/order_providers.dart';
import '../../../orders/presentation/widgets/order_product_lines_cell.dart';
import '../../../orders/presentation/widgets/order_status_chip.dart';
import '../widgets/order_report_export_section.dart';

class BusinessReportsScreen extends ConsumerWidget {
  const BusinessReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final orderStats = ref.watch(orderDashboardStatsProvider);
    final productStats = ref.watch(productSalesStatsProvider);
    final orders = ref.watch(ordersListProvider);

    return AdminPageLayout(
      showHeader: false,
      child: orders.when(
        loading: () => const SizedBox(height: 200, child: LoadingOverlay()),
        error: (e, _) => Text(l10n.errorGeneric('$e'), style: TextStyle(color: colors.danger)),
        data: (allOrders) {
          final now = DateTime.now();
          final weekStart = DateTime(now.year, now.month, now.day)
              .subtract(Duration(days: now.weekday - 1));

          final weekOrders = allOrders
              .where((o) => !o.createdAt.isBefore(weekStart))
              .toList();

          final activeCount = weekOrders
              .where((o) => o.status == OrderStatus.newOrder)
              .length;
          final completedCount = weekOrders
              .where((o) => o.status == OrderStatus.confirmed)
              .length;
          final cancelledCount = weekOrders
              .where((o) => o.status == OrderStatus.cancelled)
              .length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const OrderReportExportSection(),
              const SizedBox(height: 16),
              AppSectionCard(
                title: l10n.reportsThisWeek,
                subtitle: l10n.reportsThisWeekSubtitle,
                icon: Icons.calendar_today_outlined,
                child: Row(
                  children: [
                    _metric(
                      context,
                      label: l10n.reportsRevenue,
                      value: '€${orderStats.weekRevenueEur.toStringAsFixed(2)}',
                      hint: l10n.reportsRevenueHint,
                    ),
                    _metric(
                      context,
                      label: l10n.reportsOrders,
                      value: '${weekOrders.length}',
                    ),
                    _metric(
                      context,
                      label: l10n.reportsPending,
                      value: '$activeCount',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppSectionCard(
                title: l10n.reportsOrderStatus,
                subtitle: l10n.reportsOrderStatusSubtitle,
                icon: Icons.pie_chart_outline_rounded,
                child: Row(
                  children: [
                    _statusMetric(
                      context,
                      label: OrderStatus.newOrder.labelL10n(l10n),
                      count: activeCount,
                      color: colors.accent,
                    ),
                    _statusMetric(
                      context,
                      label: OrderStatus.confirmed.labelL10n(l10n),
                      count: completedCount,
                      color: colors.success,
                    ),
                    _statusMetric(
                      context,
                      label: OrderStatus.cancelled.labelL10n(l10n),
                      count: cancelledCount,
                      color: colors.danger,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (productStats.isNotEmpty)
                AppSectionCard(
                  title: l10n.reportsProductsSold,
                  subtitle: l10n.reportsProductsSoldSubtitle,
                  icon: Icons.leaderboard_outlined,
                  child: Column(
                    children: [
                      for (var i = 0; i < productStats.length; i++) ...[
                        if (i > 0) Divider(height: 1, color: colors.cardBorder),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  productStats[i].productName,
                                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                '×${productStats[i].quantitySold}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  color: colors.accent,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '€${productStats[i].revenueEur.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              if (weekOrders.isNotEmpty) ...[
                const SizedBox(height: 16),
                AppSectionCard(
                  title: l10n.reportsOrdersThisWeek,
                  icon: Icons.receipt_long_outlined,
                  child: Column(
                    children: [
                      for (var i = 0; i < weekOrders.length && i < 20; i++) ...[
                        if (i > 0) Divider(height: 1, color: colors.cardBorder),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            weekOrders[i].orderNumber,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        OrderStatusChip(status: weekOrders[i].status),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    OrderProductLinesCell(
                                      lines: weekOrders[i].lines,
                                      maxWidth: double.infinity,
                                    ),
                                    if (weekOrders[i].customer.hasDisplayPhone)
                                      Text(
                                        weekOrders[i].customer.displayPhone,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: colors.accent,
                                        ),
                                      ),
                                    Text(
                                      DateFormat('d MMM, HH:mm')
                                          .format(weekOrders[i].createdAt),
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: colors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '€${weekOrders[i].subtotalEur.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  color: weekOrders[i].status.countsTowardRevenue
                                      ? colors.accent
                                      : colors.textMuted,
                                  decoration: weekOrders[i].status.countsTowardRevenue
                                      ? null
                                      : TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _metric(
    BuildContext context, {
    required String label,
    required String value,
    String? hint,
  }) {
    final colors = context.appColors;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 2),
            Text(
              hint,
              style: GoogleFonts.inter(fontSize: 10, color: colors.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusMetric(
    BuildContext context, {
    required String label,
    required int count,
    required Color color,
  }) {
    final colors = context.appColors;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
