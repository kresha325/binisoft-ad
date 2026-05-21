import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/constants/branding.dart';
import '../../../core/l10n/document_l10n.dart';
import '../domain/billing_company_info.dart';
import '../domain/entities/invoice.dart';
import 'billing_pdf_theme.dart';

/// Builds a branded A4 invoice PDF in the chosen language.
class InvoicePdfBuilder {
  InvoicePdfBuilder._();

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
    Invoice invoice, {
    String languageCode = 'en',
  }) async {
    await _ensureAssets();
    final docL10n = DocumentL10n.fromLanguageCode(languageCode);
    final intlLocale = _intlLocale(languageCode);
    final pdfDoc = pw.Document(theme: await BillingPdfTheme.themeData());
    final paid = DateFormat('d MMMM yyyy, HH:mm', intlLocale).format(invoice.paidAt);
    final period = DateFormat.yMMMM(intlLocale).format(
      DateTime(invoice.periodYear, invoice.periodMonth),
    );

    pdfDoc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 44, vertical: 40),
        build: (context) => [
          _header(invoice, docL10n),
          pw.SizedBox(height: 28),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(child: _billTo(invoice, docL10n)),
              pw.SizedBox(width: 20),
              pw.Expanded(child: _metaBox(invoice, paid, period, docL10n)),
            ],
          ),
          pw.SizedBox(height: 28),
          _lineItemsTable(invoice, docL10n),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: _totalBox(invoice, docL10n),
          ),
          pw.SizedBox(height: 32),
          pw.Divider(color: PdfColors.grey300, height: 1),
          pw.SizedBox(height: 12),
          pw.Text(
            docL10n.thankYouFooter,
            style: pw.TextStyle(fontSize: 9, color: BillingPdfTheme.textMuted),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            '${BillingCompanyInfo.legalName} · ${BillingCompanyInfo.supportEmail}',
            style: pw.TextStyle(fontSize: 9, color: BillingPdfTheme.textMuted),
          ),
        ],
      ),
    );
    return pdfDoc;
  }

  static pw.Widget _header(Invoice invoice, DocumentL10n docL10n) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (_logo != null)
          pw.Container(
            width: 52,
            height: 52,
            child: pw.Image(_logo!, fit: pw.BoxFit.contain),
          ),
        pw.SizedBox(width: 14),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                BillingCompanyInfo.legalName,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: BillingPdfTheme.navy,
                ),
              ),
              pw.Text(
                BillingCompanyInfo.tagline,
                style: pw.TextStyle(fontSize: 10, color: BillingPdfTheme.textMuted),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                BillingCompanyInfo.addressLine1,
                style: pw.TextStyle(fontSize: 9, color: BillingPdfTheme.textMuted),
              ),
              pw.Text(
                BillingCompanyInfo.addressLine2,
                style: pw.TextStyle(fontSize: 9, color: BillingPdfTheme.textMuted),
              ),
            ],
          ),
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              docL10n.invoiceTitle,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: BillingPdfTheme.navy,
                letterSpacing: 1.2,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              invoice.invoiceNumber,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: pw.BoxDecoration(
                color: BillingPdfTheme.navyTint,
                borderRadius: pw.BorderRadius.circular(4),
                border: pw.Border.all(color: BillingPdfTheme.teal, width: 0.5),
              ),
              child: pw.Text(
                docL10n.invoiceTypeLabel(invoice.type).toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: BillingPdfTheme.navy,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _billTo(Invoice invoice, DocumentL10n docL10n) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            docL10n.billTo,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: BillingPdfTheme.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          pw.SizedBox(height: 8),
          if (invoice.buyerLegalName != null && invoice.buyerLegalName!.isNotEmpty)
            pw.Text(
              BillingPdfTheme.pdfSafe(invoice.buyerLegalName!),
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            )
          else
            pw.Text(
              invoice.userEmail,
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          if (invoice.buyerNipt != null && invoice.buyerNipt!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              'NIPT: ${BillingPdfTheme.pdfSafe(invoice.buyerNipt!)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
          if (invoice.buyerAddress != null && invoice.buyerAddress!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              BillingPdfTheme.pdfSafe(invoice.buyerAddress!),
              style: pw.TextStyle(fontSize: 10, color: BillingPdfTheme.textMuted),
            ),
          ],
          pw.SizedBox(height: 6),
          pw.Text(
            invoice.userEmail,
            style: pw.TextStyle(fontSize: 9, color: BillingPdfTheme.textMuted),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            '${docL10n.plan}: ${invoice.planTitle}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            docL10n.upToProductsCount(invoice.maxProducts),
            style: pw.TextStyle(fontSize: 10, color: BillingPdfTheme.textMuted),
          ),
        ],
      ),
    );
  }

  static pw.Widget _metaBox(
    Invoice invoice,
    String paid,
    String period,
    DocumentL10n docL10n,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _metaRow(docL10n.issueDate, paid, docL10n),
          _metaRow(docL10n.billingPeriod, period, docL10n),
          if (invoice.paymentMethod != null)
            _metaRow(docL10n.paymentMethod, invoice.paymentMethod!, docL10n),
          _metaRow(docL10n.currency, invoice.currency, docL10n),
          _metaRow(
            BillingCompanyInfo.vatLabel,
            BillingPdfTheme.pdfSafe(BillingCompanyInfo.vatNumber),
            docL10n,
          ),
        ],
      ),
    );
  }

  static pw.Widget _metaRow(String label, String value, DocumentL10n docL10n) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 96,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 9, color: BillingPdfTheme.textMuted),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _lineItemsTable(Invoice invoice, DocumentL10n docL10n) {
    final headerStyle = pw.TextStyle(
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    final cellStyle = pw.TextStyle(fontSize: 10);
    final detailStyle = pw.TextStyle(fontSize: 9, color: BillingPdfTheme.textMuted);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3.2),
        1: const pw.FlexColumnWidth(0.5),
        2: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: BillingPdfTheme.navy),
          children: [
            _tableCell(docL10n.description, headerStyle, align: pw.Alignment.centerLeft),
            _tableCell(docL10n.qty, headerStyle, align: pw.Alignment.center),
            _tableCell(docL10n.amount, headerStyle, align: pw.Alignment.centerRight),
          ],
        ),
        pw.TableRow(
          children: [
            _tableCell(invoice.description, cellStyle, align: pw.Alignment.centerLeft),
            _tableCell('1', cellStyle, align: pw.Alignment.center),
            _tableCell(
              invoice.formattedAmount,
              pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              align: pw.Alignment.centerRight,
            ),
          ],
        ),
        for (final line in invoice.lineItems)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(20, 6, 8, 6),
                child: pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text('• $line', style: detailStyle),
                ),
              ),
              _tableCell('', detailStyle),
              _tableCell('', detailStyle),
            ],
          ),
      ],
    );
  }

  static pw.Widget _tableCell(
    String text,
    pw.TextStyle style, {
    pw.Alignment align = pw.Alignment.centerLeft,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: pw.Align(alignment: align, child: pw.Text(text, style: style)),
    );
  }

  static pw.Widget _totalBox(Invoice invoice, DocumentL10n docL10n) {
    return pw.Container(
      width: 240,
      padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: pw.BoxDecoration(
        color: BillingPdfTheme.navy,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                docL10n.totalPaid,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  letterSpacing: 0.5,
                ),
              ),
              pw.Text(
                invoice.formattedAmount,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: BillingPdfTheme.teal,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: pw.BoxDecoration(
              color: PdfColors.green700,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              docL10n.paid,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
