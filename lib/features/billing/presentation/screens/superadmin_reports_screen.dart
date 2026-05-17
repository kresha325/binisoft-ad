import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../domain/report_period.dart';
import '../providers/invoice_providers.dart';
import '../widgets/report_period_list.dart';

class SuperAdminReportsScreen extends ConsumerStatefulWidget {
  const SuperAdminReportsScreen({super.key, this.initialTab});

  final String? initialTab;

  @override
  ConsumerState<SuperAdminReportsScreen> createState() => _SuperAdminReportsScreenState();
}

class _SuperAdminReportsScreenState extends ConsumerState<SuperAdminReportsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  static const _tabLabels = ['Ditor', 'Javor', 'Mujor', 'Vjetor'];
  static const _periods = ReportPeriod.values;

  @override
  void initState() {
    super.initState();
    final index = switch (widget.initialTab) {
      'weekly' => 1,
      'monthly' => 2,
      'yearly' => 3,
      _ => 0,
    };
    _tabs = TabController(length: 4, vsync: this, initialIndex: index);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    ref.watch(billingReportsSyncProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Raportet',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Gjenerohen automatikisht: ditore, javore, mujore dhe vjetore.',
          style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted),
        ),
        const SizedBox(height: 20),
        Material(
          color: colors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          child: TabBar(
            controller: _tabs,
            isScrollable: true,
            labelColor: colors.accent,
            unselectedLabelColor: colors.textMuted,
            indicatorColor: colors.accent,
            tabs: _tabLabels.map((l) => Tab(child: Text(l))).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              for (final period in _periods) _ReportsTab(period: period),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportsTab extends ConsumerWidget {
  const _ReportsTab({required this.period});

  final ReportPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(billingReportsProvider(period));

    return async.when(
      loading: () => const LoadingOverlay(message: 'Duke ngarkuar raportet…'),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (reports) => SingleChildScrollView(
        child: ReportPeriodList(reports: reports),
      ),
    );
  }
}
