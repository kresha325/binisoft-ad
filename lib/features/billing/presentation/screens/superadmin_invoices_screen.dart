import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../domain/entities/invoice.dart';
import '../providers/invoice_providers.dart';
import '../widgets/invoice_period_list.dart';
import '../widgets/superadmin_invoice_tabs.dart';

class SuperAdminInvoicesScreen extends ConsumerStatefulWidget {
  const SuperAdminInvoicesScreen({super.key, this.initialTab});

  final String? initialTab;

  @override
  ConsumerState<SuperAdminInvoicesScreen> createState() => _SuperAdminInvoicesScreenState();
}

class _SuperAdminInvoicesScreenState extends ConsumerState<SuperAdminInvoicesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    final index = widget.initialTab == 'monthly' ? 1 : 0;
    _tabs = TabController(length: 2, vsync: this, initialIndex: index);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Faturat',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Abonimet dhe pagesat mujore të platformës.',
          style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted),
        ),
        const SizedBox(height: 20),
        SuperAdminInvoiceTabs(controller: _tabs),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: const [
              _InvoicesTab(subscription: true),
              _InvoicesTab(subscription: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _InvoicesTab extends ConsumerWidget {
  const _InvoicesTab({required this.subscription});

  final bool subscription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(
      subscription ? platformSubscriptionInvoicesProvider : platformMonthlyInvoicesProvider,
    );

    return async.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (List<Invoice> invoices) => SingleChildScrollView(
        child: InvoicePeriodList(invoices: invoices, showUserEmail: true),
      ),
    );
  }
}
