import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/document_l10n.dart';
import '../domain/entities/invoice.dart';
import 'invoice_pdf_builder.dart';

/// Download, print, or share invoice PDFs.
class InvoiceExportService {
  const InvoiceExportService();

  Future<Uint8List> buildPdfBytes(
    Invoice invoice, {
    String languageCode = 'en',
  }) async {
    final doc = await InvoicePdfBuilder.build(invoice, languageCode: languageCode);
    return doc.save();
  }

  String fileName(Invoice invoice) =>
      '${invoice.invoiceNumber.replaceAll('/', '-')}.pdf';

  Future<void> download(
    BuildContext context,
    Invoice invoice, {
    String languageCode = 'en',
  }) async {
    final bytes = await buildPdfBytes(invoice, languageCode: languageCode);
    if (!context.mounted) return;
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: fileName(invoice),
    );
  }

  Future<void> share(
    Invoice invoice, {
    String languageCode = 'en',
  }) async {
    final bytes = await buildPdfBytes(invoice, languageCode: languageCode);
    final docL10n = DocumentL10n.fromLanguageCode(languageCode);
    final file = XFile.fromData(
      bytes,
      name: fileName(invoice),
      mimeType: 'application/pdf',
    );
    await SharePlus.instance.share(
      ShareParams(
        files: [file],
        text: docL10n.shareInvoice(invoice.invoiceNumber, invoice.formattedAmount),
      ),
    );
  }
}
