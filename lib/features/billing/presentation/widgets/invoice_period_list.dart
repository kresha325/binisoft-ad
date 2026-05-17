import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../domain/invoice_type_l10n.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/invoice_type.dart';
import '../providers/invoice_providers.dart';
import 'invoice_detail_sheet.dart';
import 'invoice_export_actions.dart';

class InvoicePeriodList extends StatelessWidget {
  const InvoicePeriodList({
    super.key,
    required this.invoices,
    this.showUserEmail = false,
  });

  final List<Invoice> invoices;
  final bool showUserEmail;

  @override
  Widget build(BuildContext context) {
    if (invoices.isEmpty) {
      return _EmptyInvoices();
    }

    final grouped = groupInvoicesByPeriod(invoices);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in grouped.entries) ...[
          _PeriodHeader(periodKey: entry.key, count: entry.value.length),
          const SizedBox(height: 10),
          for (final inv in entry.value)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _InvoiceTile(
                invoice: inv,
                showUserEmail: showUserEmail,
                onTap: () => showInvoiceDetailSheet(context, inv),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _EmptyInvoices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.receipt_long_outlined, size: 48, color: colors.textMuted),
            const SizedBox(height: 12),
            Text(
              l10n.noInvoicesYet,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.noInvoicesHint,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodHeader extends StatelessWidget {
  const _PeriodHeader({required this.periodKey, required this.count});

  final String periodKey;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final parts = periodKey.split('-');
    final year = int.tryParse(parts.first) ?? 0;
    final month = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;
    final label = DateFormat.yMMMM().format(DateTime(year, month));

    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($count)',
          style: GoogleFonts.inter(fontSize: 13, color: colors.textMuted),
        ),
      ],
    );
  }
}

class _InvoiceTile extends ConsumerWidget {
  const _InvoiceTile({
    required this.invoice,
    required this.showUserEmail,
    required this.onTap,
  });

  final Invoice invoice;
  final bool showUserEmail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final date = DateFormat('d MMM yyyy, HH:mm').format(invoice.paidAt);
    final tone = invoice.type == InvoiceType.subscription
        ? StatusChipTone.accent
        : StatusChipTone.neutral;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppDesign.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            border: Border.all(color: colors.cardBorder),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                ),
                child: Icon(Icons.receipt_rounded, color: colors.accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.invoiceNumber,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invoice.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 12, color: colors.textMuted),
                    ),
                    if (showUserEmail) ...[
                      const SizedBox(height: 4),
                      Text(
                        invoice.userEmail,
                        style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(date, style: GoogleFonts.inter(fontSize: 11, color: colors.textMuted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    invoice.formattedAmount,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.accent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  StatusChip(
                    label: invoice.type.labelL10n(l10n),
                    tone: tone,
                    icon: invoice.type == InvoiceType.monthly
                        ? Icons.calendar_month_outlined
                        : Icons.workspace_premium_outlined,
                  ),
                ],
              ),
              InvoiceExportActions(invoice: invoice, compact: true),
              Icon(Icons.chevron_right_rounded, color: colors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
