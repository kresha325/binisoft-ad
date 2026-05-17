import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Shared fonts and brand colors for invoice / report PDFs.
abstract final class BillingPdfTheme {
  static final navy = PdfColor.fromHex('1A2B56');
  static final teal = PdfColor.fromHex('2EC4C6');
  static final navyTint = PdfColor.fromHex('E8EEF8');
  static final textMuted = PdfColor.fromHex('64748B');

  static pw.Font? _base;
  static pw.Font? _bold;

  static Future<pw.ThemeData> themeData() async {
    _base ??= await PdfGoogleFonts.interRegular();
    _bold ??= await PdfGoogleFonts.interBold();
    return pw.ThemeData.withFont(base: _base!, bold: _bold!);
  }

  /// VAT / placeholder safe for PDF (Helvetica cannot render em dash or €).
  static String pdfSafe(String value) {
    if (value == '—' || value == '–') return 'N/A';
    return value;
  }
}
