import 'package:business_dashboard/l10n/app_localizations.dart';

import 'invoice_type.dart';

extension InvoiceTypeL10n on InvoiceType {
  String labelL10n(AppLocalizations l10n) => switch (this) {
        InvoiceType.subscription => l10n.invoiceTypeSubscription,
        InvoiceType.monthly => l10n.invoiceTypeMonthly,
      };
}
