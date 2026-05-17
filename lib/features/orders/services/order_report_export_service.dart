import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/document_l10n.dart';
import '../domain/entities/order_sales_report.dart';
import 'order_report_pdf_builder.dart';

class OrderReportExportService {
  const OrderReportExportService();

  Future<Uint8List> buildPdfBytes(
    OrderSalesReport report, {
    String languageCode = 'en',
  }) async {
    final doc = await OrderReportPdfBuilder.build(report, languageCode: languageCode);
    return doc.save();
  }

  String fileName(OrderSalesReport report) =>
      'orders-${report.period.value}-${report.periodKey}.pdf';

  Future<void> download(
    BuildContext context,
    OrderSalesReport report, {
    String languageCode = 'en',
  }) async {
    final bytes = await buildPdfBytes(report, languageCode: languageCode);
    if (!context.mounted) return;
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: fileName(report),
    );
  }

  Future<void> share(
    OrderSalesReport report, {
    String languageCode = 'en',
  }) async {
    final bytes = await buildPdfBytes(report, languageCode: languageCode);
    final docL10n = DocumentL10n.fromLanguageCode(languageCode);
    final file = XFile.fromData(
      bytes,
      name: fileName(report),
      mimeType: 'application/pdf',
    );
    await SharePlus.instance.share(
      ShareParams(
        files: [file],
        text: docL10n.shareReport(
          report.businessName,
          report.titleLabelFor(languageCode),
          report.formattedRevenue,
        ),
      ),
    );
  }
}
