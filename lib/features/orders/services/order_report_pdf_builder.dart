import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/constants/branding.dart';
import '../../../core/l10n/document_l10n.dart';
import '../../billing/services/billing_pdf_theme.dart';
import '../domain/entities/order_sales_report.dart';

class OrderReportPdfBuilder {
  OrderReportPdfBuilder._();

  static pw.MemoryImage? _logo;

  static Future<void> _ensureAssets() async {
    if (_logo == null) {
      final bytes = await rootBundle.load(AppBranding.logoAsset);
      _logo = pw.MemoryImage(bytes.buffer.asUint8List());
    }
  }

  static String _intlLocale(String languageCode) => switch (languageCode) {
        'sq' => 'sq',
        'de' => 'de',
        _ => 'en',
      };

  static Future<pw.Document> build(
    OrderSalesReport report, {
    String languageCode = 'en',
  }) async {
    await _ensureAssets();
    final docL10n = DocumentL10n.fromLanguageCode(languageCode);
    final intlLocale = _intlLocale(languageCode);
    final doc = pw.Document(theme: await BillingPdfTheme.themeData());
    final range = '${DateFormat('d MMM yyyy', intlLocale).format(report.periodStart)} - '
        '${DateFormat('d MMM yyyy', intlLocale).format(report.periodEnd)}';
    final generated =
        DateFormat('d MMM yyyy, HH:mm', intlLocale).format(report.generatedAt);
    final periodLabel = docL10n.periodLabel(report.period);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) => [
          pw.Row(
            children: [
              if (_logo != null)
                pw.SizedBox(
                  width: 48,
                  height: 48,
                  child: pw.Image(_logo!, fit: pw.BoxFit.contain),
                ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      report.businessName,
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      '${docL10n.ordersReportTitle} · $periodLabel',
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
              _kpi(docL10n.orders, '${report.orderCount}'),
              _kpi(docL10n.revenue, report.formattedRevenue, highlight: true),
              _kpi(docL10n.orderStatusPending, '${report.activeCount}'),
              _kpi(docL10n.orderStatusCompleted, '${report.completedCount}'),
              _kpi(docL10n.orderStatusCancelled, '${report.cancelledCount}'),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '${docL10n.generated}: $generated · ${docL10n.revenueExcludesCancelled}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          if (report.products.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text(
              docL10n.productsSold,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              headers: [docL10n.product, docL10n.tableQty, docL10n.revenue],
              data: report.products
                  .map(
                    (p) => [
                      p.productName,
                      '${p.quantitySold}',
                      _eur(p.revenueEur),
                    ],
                  )
                  .toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
                color: PdfColors.white,
              ),
              cellStyle: const pw.TextStyle(fontSize: 8),
              headerDecoration: pw.BoxDecoration(color: BillingPdfTheme.navy),
              cellHeight: 20,
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            ),
          ],
          pw.SizedBox(height: 20),
          pw.Text(
            docL10n.orders,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          if (report.orders.isEmpty)
            pw.Text(docL10n.noOrdersInPeriod, style: const pw.TextStyle(fontSize: 11))
          else
            pw.TableHelper.fromTextArray(
              headers: [
                docL10n.tableOrder,
                docL10n.tableCustomer,
                docL10n.tablePhone,
                docL10n.tableProducts,
                docL10n.tableTotal,
                docL10n.tableStatus,
                docL10n.tableDate,
              ],
              data: report.orders
                  .map(
                    (o) => [
                      o.orderNumber,
                      o.customerName,
                      o.customerPhone.isEmpty ? '—' : o.customerPhone,
                      o.productsSummary,
                      _eur(o.totalEur),
                      o.statusLabel,
                      DateFormat('d MMM yyyy, HH:mm', intlLocale).format(o.createdAt),
                    ],
                  )
                  .toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 8,
                color: PdfColors.white,
              ),
              cellStyle: const pw.TextStyle(fontSize: 7),
              headerDecoration: pw.BoxDecoration(color: BillingPdfTheme.navy),
              cellHeight: 24,
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.2),
                1: const pw.FlexColumnWidth(1.1),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1.6),
                4: const pw.FlexColumnWidth(0.7),
                5: const pw.FlexColumnWidth(0.8),
                6: const pw.FlexColumnWidth(1.1),
              },
            ),
        ],
      ),
    );
    return doc;
  }

  static pw.Widget _kpi(String label, String value, {bool highlight = false}) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.only(right: 6),
        padding: const pw.EdgeInsets.all(10),
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
                fontSize: 7,
                color: highlight ? PdfColors.white : PdfColors.grey600,
              ),
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: highlight ? 12 : 10,
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
    return 'EUR $s';
  }
}
