import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/app_adaptive_sheet.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/invoice_type_l10n.dart';
import 'invoice_export_actions.dart';

Future<void> showInvoiceDetailSheet(BuildContext context, Invoice invoice) {
  return showAppAdaptiveSheet<void>(
    context: context,
    maxWidth: 500,
    builder: (ctx) => _InvoiceDetailSheet(invoice: invoice),
  );
}

class _InvoiceDetailSheet extends StatelessWidget {
  const _InvoiceDetailSheet({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final isMobile = AppBreakpoints.isMobile(context);
    final date = DateFormat('d MMMM yyyy, HH:mm').format(invoice.paidAt);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMobile)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: adaptiveSheetDragHandle(context),
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.invoiceTitle,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: colors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(24, isMobile ? 8 : 0, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isMobile) ...[
                Text(
                  l10n.invoiceTitle,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                invoice.invoiceNumber,
                style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 16 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              if (isMobile) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.close),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    if (isMobile) {
      return Material(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDesign.radiusXl)),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(child: body),
      );
    }

    return SingleChildScrollView(child: body);
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
            width: 88,
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
