import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/constants/branding.dart';
import '../domain/billing_company_info.dart';
import '../domain/entities/billing_report.dart';
import 'billing_pdf_theme.dart';

class ReportPdfBuilder {
  ReportPdfBuilder._();

  static pw.MemoryImage? _logo;

  static Future<void> _ensureAssets() async {
    if (_logo == null) {
      final bytes = await rootBundle.load(AppBranding.logoAsset);
      _logo = pw.MemoryImage(bytes.buffer.asUint8List());
    }
  }

  static Future<pw.Document> build(BillingReport report) async {
    await _ensureAssets();
    final doc = pw.Document(theme: await BillingPdfTheme.themeData());
    final range = '${DateFormat('d MMM yyyy').format(report.periodStart)} - '
        '${DateFormat('d MMM yyyy').format(report.periodEnd)}';
    final generated = DateFormat('d MMM yyyy, HH:mm').format(report.generatedAt);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) => [
          pw.Row(
            children: [
              if (_logo != null)
                pw.SizedBox(width: 48, height: 48, child: pw.Image(_logo!, fit: pw.BoxFit.contain)),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      BillingCompanyInfo.legalName,
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Billing report · ${report.period.labelEn}',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                    ),
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    report.periodKey,
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(range, style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            children: [
              _kpi('Invoices', '${report.invoiceCount}'),
              _kpi('Subscriptions', _eur(report.subscriptionTotalEur)),
              _kpi('Monthly', _eur(report.monthlyTotalEur)),
              _kpi('Total', report.formattedTotal, highlight: true),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text('Generated: $generated', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
          pw.SizedBox(height: 20),
          if (report.invoices.isEmpty)
            pw.Text('No invoices in this period.', style: const pw.TextStyle(fontSize: 11))
          else
            pw.TableHelper.fromTextArray(
              headers: ['Invoice', 'Customer', 'Type', 'Amount', 'Paid'],
              data: report.invoices
                  .map(
                    (i) => [
                      i.invoiceNumber,
                      i.userEmail,
                      i.type,
                      _eur(i.amountEur),
                      DateFormat('d MMM yyyy').format(i.paidAt),
                    ],
                  )
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.white),
              cellStyle: const pw.TextStyle(fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: BillingPdfTheme.navy),
              cellHeight: 22,
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            ),
        ],
      ),
    );
    return doc;
  }

  static pw.Widget _kpi(String label, String value, {bool highlight = false}) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.only(right: 8),
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: highlight ? BillingPdfTheme.navy : PdfColors.grey100,
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 8,
                color: highlight ? PdfColors.white : PdfColors.grey600,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: highlight ? 14 : 12,
                fontWeight: pw.FontWeight.bold,
                color: highlight ? PdfColors.white : PdfColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _eur(double n) {
    final s = n == n.roundToDouble() ? n.toInt().toString() : n.toStringAsFixed(2);
    return '€$s';
  }
}
