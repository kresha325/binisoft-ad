import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import 'order_status_chip.dart';
import '../../domain/entities/order.dart';
import 'order_customer_info.dart';

Future<void> showOrderDetailSheet(
  BuildContext context,
  BusinessOrder order,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _OrderDetailSheet(order: order),
  );
}

class _OrderDetailSheet extends ConsumerWidget {
  const _OrderDetailSheet({required this.order});

  final BusinessOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final date = DateFormat('d MMMM yyyy, HH:mm').format(order.createdAt);

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDesign.radiusXl),
            ),
            border: Border.all(color: colors.cardBorder),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.orderNumber,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  OrderStatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(date, style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted)),
              const SizedBox(height: 20),
              _sectionTitle(context, l10n.orderDetailCustomer),
              const SizedBox(height: 8),
              OrderCustomerInfo(customer: order.customer),
              if (order.customer.notes?.isNotEmpty == true) ...[
                const SizedBox(height: 6),
                Text(order.customer.notes!,
                    style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted)),
              ],
              const SizedBox(height: 20),
              _sectionTitle(context, l10n.orderDetailProducts),
              const SizedBox(height: 8),
              ...order.lines.map(
                (l) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${l.quantity}× ${l.productName}',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ),
                      Text(
                        '€${l.lineTotalEur.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 28),
              Row(
                children: [
                  Text('Total', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text(
                    '€${order.subtotalEur.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.accent,
                    ),
                  ),
                ],
              ),
              if (order.status != OrderStatus.cancelled) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (order.status == OrderStatus.newOrder)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _setStatus(ref, context, OrderStatus.confirmed),
                          child: Text(l10n.orderConfirm),
                        ),
                      ),
                    if (order.status == OrderStatus.newOrder) const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        onPressed: () => _setStatus(ref, context, OrderStatus.cancelled),
                        child: Text(l10n.cancel, style: TextStyle(color: colors.danger)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: context.appColors.textMuted,
      ),
    );
  }

  Future<void> _setStatus(
    WidgetRef ref,
    BuildContext context,
    OrderStatus status,
  ) async {
    try {
      await ref.read(orderRepositoryProvider).updateStatus(
            businessId: order.businessId,
            orderId: order.id,
            status: status,
          );
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }
}
