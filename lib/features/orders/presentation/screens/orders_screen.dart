import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final ordersAsync = ref.watch(ordersListProvider);

    return AdminPageLayout(
      showHeader: false,
      child: ordersAsync.when(
        loading: () => const SizedBox(height: 200, child: LoadingOverlay()),
        error: (e, _) => Center(child: Text(l10n.errorGeneric('$e'), style: TextStyle(color: colors.danger))),
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
              DataTableCard(
                columns: [
                  l10n.tableOrder,
                  l10n.tableCustomer,
                  l10n.tableProduct,
                  l10n.tableQty,
                  l10n.tableTotal,
                  l10n.tableStatus,
                  l10n.tableDate,
                ],
                emptyMessage: switch (widget.view) {
                  'today' => l10n.ordersEmptyToday,
                  'latest' => l10n.ordersEmptyNone,
                  _ => l10n.ordersEmptyConnect,
                },
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
              ),
            ],
          );
        },
      ),
    );
  }
}
