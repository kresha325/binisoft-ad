import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:business_dashboard/l10n/app_localizations.dart';

import '../../../../core/l10n/app_locale_provider.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/l10n/ui_locales.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../billing/domain/report_period.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../../../orders/domain/order_sales_report_builder.dart';
import '../../../orders/presentation/providers/order_providers.dart';
import '../../../orders/presentation/providers/order_report_providers.dart';

class OrderReportExportSection extends ConsumerWidget {
  const OrderReportExportSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final orders = ref.watch(ordersListProvider).valueOrNull ?? [];
    final businessName =
        ref.watch(currentBusinessProvider).valueOrNull?.name ?? 'Business';
    final export = ref.read(orderReportExportServiceProvider);
    final lang = UiLocales.codeOf(resolveAppLocale(ref.watch(appLocaleProvider)));

    Future<void> runExport(
      ReportPeriod period, {
      required bool share,
    }) async {
      try {
        final report = OrderSalesReportBuilder.build(
          orders: orders,
          period: period,
          anchor: DateTime.now(),
          businessName: businessName,
          languageCode: lang,
        );
        if (share) {
          await export.share(report, languageCode: lang);
        } else {
          await export.download(context, report, languageCode: lang);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.exportFailed('$e'))),
          );
        }
      }
    }

    return AppSectionCard(
      title: l10n.reportsExportTitle,
      subtitle: l10n.reportsExportSubtitle,
      icon: Icons.download_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final period in ReportPeriod.values) ...[
            _PeriodExportRow(
              period: period,
              colors: colors,
              l10n: l10n,
              onDownload: () => runExport(period, share: false),
              onShare: () => runExport(period, share: true),
            ),
            if (period != ReportPeriod.yearly)
              Divider(height: 1, color: colors.cardBorder),
          ],
        ],
      ),
    );
  }
}

class _PeriodExportRow extends StatelessWidget {
  const _PeriodExportRow({
    required this.period,
    required this.colors,
    required this.l10n,
    required this.onDownload,
    required this.onShare,
  });

  final ReportPeriod period;
  final AppColorScheme colors;
  final AppLocalizations l10n;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  String get _title => switch (period) {
        ReportPeriod.daily => l10n.periodDaily,
        ReportPeriod.weekly => l10n.periodWeekly,
        ReportPeriod.monthly => l10n.periodMonthly,
        ReportPeriod.yearly => l10n.periodYearly,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_iconFor(period), size: 20, color: colors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.downloadPdf,
            onPressed: onDownload,
            icon: Icon(Icons.picture_as_pdf_outlined, color: colors.accent),
          ),
          IconButton(
            tooltip: l10n.sharePdf,
            onPressed: onShare,
            icon: Icon(Icons.ios_share_rounded, color: colors.accent),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(ReportPeriod period) => switch (period) {
        ReportPeriod.daily => Icons.today_outlined,
        ReportPeriod.weekly => Icons.date_range_outlined,
        ReportPeriod.monthly => Icons.calendar_month_outlined,
        ReportPeriod.yearly => Icons.calendar_today_outlined,
      };
}
