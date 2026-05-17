import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/entities/billing_report.dart';
import 'report_pdf_builder.dart';

class BillingReportExportService {
  const BillingReportExportService();

  Future<Uint8List> buildPdfBytes(BillingReport report) async {
    final doc = await ReportPdfBuilder.build(report);
    return doc.save();
  }

  String fileName(BillingReport report) =>
      'report-${report.period.value}-${report.periodKey}.pdf';

  Future<void> download(BuildContext context, BillingReport report) async {
    final bytes = await buildPdfBytes(report);
    if (!context.mounted) return;
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: fileName(report),
    );
  }

  Future<void> share(BillingReport report) async {
    final bytes = await buildPdfBytes(report);
    final file = XFile.fromData(
      bytes,
      name: fileName(report),
      mimeType: 'application/pdf',
    );
    await SharePlus.instance.share(
      ShareParams(
        files: [file],
        text: 'Billing report ${report.titleLabel} · ${report.formattedTotal}',
      ),
    );
  }
}
