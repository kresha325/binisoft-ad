import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../providers/invoice_providers.dart';
import '../widgets/invoice_period_list.dart';

class UserInvoicesScreen extends ConsumerWidget {
  const UserInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(myInvoicesProvider);

    return invoicesAsync.when(
      loading: () => LoadingOverlay(message: context.l10n.loadingInvoices),
      error: (e, _) => Center(child: Text(context.l10n.errorGeneric('$e'))),
      data: (invoices) => SingleChildScrollView(
        child: InvoicePeriodList(invoices: invoices),
      ),
    );
  }
}
