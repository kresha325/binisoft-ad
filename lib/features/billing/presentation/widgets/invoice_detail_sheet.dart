import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/invoice_type_l10n.dart';
import 'invoice_export_actions.dart';

Future<void> showInvoiceDetailSheet(BuildContext context, Invoice invoice) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) => _InvoiceDetailSheet(
        invoice: invoice,
        scrollController: scrollController,
      ),
    ),
  );
}

class _InvoiceDetailSheet extends StatelessWidget {
  const _InvoiceDetailSheet({
    required this.invoice,
    required this.scrollController,
  });

  final Invoice invoice;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final date = DateFormat('d MMMM yyyy, HH:mm').format(invoice.paidAt);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        border: Border.all(color: colors.cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(24, 16, 24, 20 + bottomInset),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.invoiceTitle,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              invoice.invoiceNumber,
              style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted),
            ),
            const SizedBox(height: 20),
            _Row(
              label: l10n.invoiceAmount,
              value: invoice.formattedAmount,
              bold: true,
              colors: colors,
            ),
            _Row(
              label: l10n.invoiceType,
              value: invoice.type.labelL10n(l10n),
              colors: colors,
            ),
            _Row(
              label: l10n.invoicePlan,
              value: l10n.invoicePlanProducts(invoice.planTitle, invoice.maxProducts),
              colors: colors,
            ),
            _Row(label: l10n.invoicePaid, value: date, colors: colors),
            if (invoice.paymentMethod != null)
              _Row(label: l10n.invoiceMethod, value: invoice.paymentMethod!, colors: colors),
            const SizedBox(height: 12),
            Text(
              invoice.description,
              style: GoogleFonts.inter(fontSize: 14, color: colors.textPrimary, height: 1.4),
            ),
            if (invoice.lineItems.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.invoiceDetails,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              for (final line in invoice.lineItems)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: TextStyle(color: colors.textMuted)),
                      Expanded(
                        child: Text(
                          line,
                          style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: 20),
            InvoiceExportActions(invoice: invoice),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.close),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    required this.colors,
    this.bold = false,
  });

  final String label;
  final String value;
  final AppColorScheme colors;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted)),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: bold ? 18 : 14,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
