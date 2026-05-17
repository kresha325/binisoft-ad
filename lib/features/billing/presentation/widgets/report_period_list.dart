import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../domain/entities/billing_report.dart';
import '../providers/invoice_providers.dart';

class ReportPeriodList extends ConsumerWidget {
  const ReportPeriodList({super.key, required this.reports});

  final List<BillingReport> reports;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (reports.isEmpty) {
      return _EmptyReports();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final report in reports) ...[
          _ReportCard(report: report),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _EmptyReports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.assessment_outlined, size: 48, color: colors.textMuted),
            const SizedBox(height: 12),
            Text(
              'Nuk ka raporte ende',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Raportet gjenerohen automatikisht çdo ditë, javë, muaj dhe vit.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends ConsumerWidget {
  const _ReportCard({required this.report});

  final BillingReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final export = ref.read(billingReportExportServiceProvider);
    final generated = DateFormat('d MMM yyyy, HH:mm').format(report.generatedAt);
    final range = '${DateFormat('d MMM').format(report.periodStart)} – '
        '${DateFormat('d MMM yyyy').format(report.periodEnd)}';

    Future<void> run(Future<void> Function() action) async {
      try {
        await action();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Export failed: $e')),
          );
        }
      }
    }

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppDesign.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        onTap: () => run(() => export.download(context, report)),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            border: Border.all(color: colors.cardBorder),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.titleLabel,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(range, style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted)),
                        Text(
                          '$generated · ${report.invoiceCount} fatura',
                          style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    report.formattedTotal,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _chip(colors, 'Abonime', report.subscriptionTotalEur),
                  const SizedBox(width: 8),
                  _chip(colors, 'Mujore', report.monthlyTotalEur),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Shkarko PDF',
                    onPressed: () => run(() => export.download(context, report)),
                    icon: Icon(Icons.download_rounded, color: colors.accent),
                  ),
                  IconButton(
                    tooltip: 'Ndaj',
                    onPressed: () => run(() => export.share(report)),
                    icon: Icon(Icons.ios_share_rounded, color: colors.accent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(AppColorScheme colors, String label, double amount) {
    final s = amount == amount.roundToDouble()
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(AppDesign.radiusSm),
      ),
      child: Text(
        '$label €$s',
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.accent),
      ),
    );
  }
}
