import 'package:business_dashboard/l10n/app_localizations.dart';

import 'entities/order.dart';

extension OrderStatusL10n on OrderStatus {
  String labelL10n(AppLocalizations l10n) => switch (this) {
        OrderStatus.newOrder => l10n.orderStatusPending,
        OrderStatus.confirmed => l10n.orderStatusCompleted,
        OrderStatus.cancelled => l10n.orderStatusCancelled,
      };
}
