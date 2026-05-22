import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/layout/app_breakpoints.dart';
import 'package:business_dashboard/l10n/app_localizations.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/admin_page_layout.dart';
import '../../../../core/widgets/data_table_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/search_toolbar.dart';
import '../widgets/order_status_chip.dart';
import '../../domain/entities/order.dart';
import '../providers/order_providers.dart';
import '../widgets/order_customer_info.dart';
import '../widgets/order_detail_sheet.dart';
import '../widgets/order_mobile_card.dart';
import '../widgets/order_product_lines_cell.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key, this.view});

  /// `today` — orders created today; `latest` — most recent order only.
  final String? view;

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  String _query = '';
  bool _openedLatest = false;

  @override
  void didUpdateWidget(covariant OrdersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.view != widget.view) {
      _openedLatest = false;
    }
  }

  void _maybeOpenLatest(List<BusinessOrder> orders) {
    if (widget.view != 'latest' || _openedLatest || orders.isEmpty) return;
    _openedLatest = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showOrderDetailSheet(context, orders.first);
    });
  }

  List<BusinessOrder> _applyViewFilter(List<BusinessOrder> orders) {
    switch (widget.view) {
      case 'today':
        final now = DateTime.now();
        final start = DateTime(now.year, now.month, now.day);
        return orders.where((o) => !o.createdAt.isBefore(start)).toList();
      case 'latest':
        return orders.isEmpty ? [] : [orders.first];
      default:
        return orders;
    }
  }

  String _emptyMessage(AppLocalizations l10n) => switch (widget.view) {
        'today' => l10n.ordersEmptyToday,
        'latest' => l10n.ordersEmptyNone,
        _ => l10n.ordersEmptyConnect,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final isMobile = AppBreakpoints.isMobile(context);
    final ordersAsync = ref.watch(ordersListProvider);

    return AdminPageLayout(
      showHeader: false,
      scrollable: isMobile,
      child: ordersAsync.when(
        loading: () => const SizedBox(height: 200, child: LoadingOverlay()),
        error: (e, _) => Center(
          child: Text(l10n.errorGeneric('$e'), style: TextStyle(color: colors.danger)),
        ),
        data: (orders) {
          final viewFiltered = _applyViewFilter(orders);
          _maybeOpenLatest(viewFiltered);

          final q = _query.toLowerCase();
          final filtered = viewFiltered.where((o) => o.matchesSearch(q)).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchToolbar(
                searchHint: l10n.ordersSearchHint,
                onSearchChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 16),
              if (isMobile)
                _buildMobileList(context, l10n, filtered)
              else
                Expanded(child: _buildDesktopTable(context, l10n, filtered)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, AppLocalizations l10n, List<BusinessOrder> filtered) {
    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            _emptyMessage(l10n),
            textAlign: TextAlign.center,
            style: TextStyle(color: context.appColors.textMuted),
          ),
        ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < filtered.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          OrderMobileCard(
            order: filtered[i],
            onTap: () => showOrderDetailSheet(context, filtered[i]),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDesktopTable(BuildContext context, AppLocalizations l10n, List<BusinessOrder> filtered) {
    return DataTableCard(
      columns: [
        l10n.tableOrder,
        l10n.tableCustomer,
        l10n.tableProduct,
        l10n.tableQty,
        l10n.tableTotal,
        l10n.tableStatus,
        l10n.tableDate,
      ],
      emptyMessage: _emptyMessage(l10n),
      rows: filtered.map((o) {
        final date = DateFormat('d MMM yyyy, HH:mm').format(o.createdAt);
        return DataRow(
          cells: [
            DataCell(
              InkWell(
                onTap: () => showOrderDetailSheet(context, o),
                child: Text(
                  o.orderNumber,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            DataCell(OrderCustomerInfo(customer: o.customer)),
            DataCell(
              OrderProductLinesCell(lines: o.lines, namesOnly: true, maxWidth: 160),
            ),
            DataCell(
              OrderProductLinesCell(
                lines: o.lines,
                quantitiesOnly: true,
                maxWidth: 56,
              ),
            ),
            DataCell(Text('€${o.subtotalEur.toStringAsFixed(2)}')),
            DataCell(OrderStatusChip(status: o.status)),
            DataCell(Text(date)),
          ],
        );
      }).toList(),
    );
  }
}
