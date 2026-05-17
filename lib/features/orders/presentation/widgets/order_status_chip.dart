import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/entities/order.dart';
import '../../domain/order_status_l10n.dart';

/// Pending until admin confirms; then completed or cancelled.
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final label = status.labelL10n(context.l10n);
    return switch (status) {
      OrderStatus.newOrder => StatusChip(
          label: label,
          tone: StatusChipTone.warning,
          icon: Icons.schedule_outlined,
        ),
      OrderStatus.confirmed => StatusChip(
          label: label,
          tone: StatusChipTone.success,
          icon: Icons.check_circle_outline,
        ),
      OrderStatus.cancelled => StatusChip(
          label: label,
          tone: StatusChipTone.danger,
          icon: Icons.cancel_outlined,
        ),
    };
  }
}
