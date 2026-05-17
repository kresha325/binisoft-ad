import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/data_table_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/page_header_action_scope.dart';
import '../../../../core/widgets/shell_add_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/table_row_actions.dart';
import '../../domain/entities/offer.dart';
import '../providers/offers_providers.dart';
import '../widgets/add_offer_dialog.dart';

class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final offers = ref.watch(offersListProvider);

    return PageHeaderActionScope(
      route: '/offers',
      action: ShellAddButton(
        label: l10n.offerAddTitle,
        onPressed: () => showAddOfferDialog(context, ref),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: offers.when(
              loading: () => const LoadingOverlay(),
              error: (e, _) => Center(
                child: Text(l10n.errorGeneric('$e'), style: TextStyle(color: colors.danger)),
              ),
              data: (items) => DataTableCard(
                columns: [
                  l10n.tableName,
                  l10n.offerColumnProducts,
                  l10n.offerColumnDiscount,
                  l10n.offerColumnPeriod,
                  l10n.tableStatus,
                  l10n.tableActions,
                ],
                emptyMessage: l10n.offersEmpty,
                minHeight: 280,
                rows: [
                  for (final o in items)
                    DataRow(cells: [
                      DataCell(
                        Text(o.title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      ),
                      DataCell(Text('${o.productIds.length}')),
                      DataCell(Text(_discountSummary(context, o))),
                      DataCell(
                        Text(
                          '${DateFormat('d MMM').format(o.startsAt)} – '
                          '${DateFormat('d MMM yyyy').format(o.endsAt)}',
                          style: GoogleFonts.inter(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        StatusChip(
                          label: o.isCurrentlyActive
                              ? l10n.offerStatusLive
                              : o.active
                                  ? l10n.offerStatusScheduled
                                  : l10n.statusInactive,
                          tone: o.isCurrentlyActive
                              ? StatusChipTone.success
                              : StatusChipTone.warning,
                          icon: o.isCurrentlyActive
                              ? Icons.local_offer_outlined
                              : Icons.schedule_outlined,
                        ),
                      ),
                      DataCell(
                        TableRowActions(
                          onEdit: () => showOfferDialog(context, ref, offer: o),
                          onDelete: () => deleteOffer(context, ref, o),
                        ),
                      ),
                    ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _discountSummary(BuildContext context, Offer offer) {
    final l10n = context.l10n;
    if (offer.items.isEmpty) return '—';
    final first = offer.items.first;
    if (first.salePriceEur != null) {
      return l10n.offerSummarySalePrice(first.salePriceEur!);
    }
    if (first.discountPercent != null) {
      return l10n.offerSummaryPercent(first.discountPercent!);
    }
    if (offer.discountPercent != null) {
      return l10n.offerSummaryPercent(offer.discountPercent!);
    }
    return '—';
  }
}
