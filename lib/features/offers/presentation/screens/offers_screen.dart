import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/data_table_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/page_header_action_scope.dart';
import '../../../../core/widgets/search_toolbar.dart';
import '../../../../core/widgets/shell_add_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/table_row_actions.dart';
import '../../domain/entities/offer.dart';
import '../providers/offers_providers.dart';
import '../widgets/add_offer_sheet.dart';

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen> {
  String _search = '';
  OfferLifecycleStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final offers = ref.watch(offersListProvider);

    return PageHeaderActionScope(
      route: '/offers',
      action: ShellAddButton(
        label: l10n.offerAddTitle,
        onPressed: () => showAddOfferSheet(context, ref),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchToolbar(
            searchHint: l10n.searchOffers,
            onSearchChanged: (v) => setState(() => _search = v.toLowerCase()),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _filterChip(l10n.filterAll, _statusFilter == null, () {
                setState(() => _statusFilter = null);
              }),
              _filterChip(
                l10n.offerStatusLive,
                _statusFilter == OfferLifecycleStatus.live,
                () => setState(() => _statusFilter = OfferLifecycleStatus.live),
              ),
              _filterChip(
                l10n.offerStatusScheduled,
                _statusFilter == OfferLifecycleStatus.scheduled,
                () => setState(() => _statusFilter = OfferLifecycleStatus.scheduled),
              ),
              _filterChip(
                l10n.offerStatusExpired,
                _statusFilter == OfferLifecycleStatus.expired,
                () => setState(() => _statusFilter = OfferLifecycleStatus.expired),
              ),
              _filterChip(
                l10n.statusInactive,
                _statusFilter == OfferLifecycleStatus.inactive,
                () => setState(() => _statusFilter = OfferLifecycleStatus.inactive),
              ),
            ],
          ),
          const SizedBox(height: 16),
          offers.when(
              loading: () => const SizedBox(height: 280, child: LoadingOverlay()),
              error: (e, _) => Center(
                child: Text(l10n.errorGeneric('$e'), style: TextStyle(color: colors.danger)),
              ),
              data: (items) {
                var filtered = items;
                if (_search.isNotEmpty) {
                  filtered = filtered
                      .where(
                        (o) =>
                            o.title.toLowerCase().contains(_search) ||
                            (o.description?.toLowerCase().contains(_search) ?? false),
                      )
                      .toList();
                }
                if (_statusFilter != null) {
                  filtered = filtered
                      .where((o) => o.lifecycleStatus == _statusFilter)
                      .toList();
                }

                return DataTableCard(
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
                  dataRowMaxHeight: 88,
                  rows: [
                    for (final o in filtered)
                      DataRow(cells: [
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                o.title,
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                              if (o.description != null && o.description!.isNotEmpty)
                                Text(
                                  o.description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: colors.textMuted,
                                  ),
                                ),
                            ],
                          ),
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
                        DataCell(_OfferStatusChip(status: o.lifecycleStatus)),
                        DataCell(
                          TableRowActions(
                            onEdit: () => showOfferSheet(context, ref, offer: o),
                            onDelete: () => deleteOffer(context, ref, o),
                          ),
                        ),
                      ]),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
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

class _OfferStatusChip extends StatelessWidget {
  const _OfferStatusChip({required this.status});

  final OfferLifecycleStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, tone, icon) = switch (status) {
      OfferLifecycleStatus.live => (
          l10n.offerStatusLive,
          StatusChipTone.success,
          Icons.local_offer_outlined,
        ),
      OfferLifecycleStatus.scheduled => (
          l10n.offerStatusScheduled,
          StatusChipTone.accent,
          Icons.schedule_outlined,
        ),
      OfferLifecycleStatus.expired => (
          l10n.offerStatusExpired,
          StatusChipTone.warning,
          Icons.event_busy_outlined,
        ),
      OfferLifecycleStatus.inactive => (
          l10n.statusInactive,
          StatusChipTone.neutral,
          Icons.pause_circle_outline,
        ),
    };
    return StatusChip(label: label, tone: tone, icon: icon);
  }
}
