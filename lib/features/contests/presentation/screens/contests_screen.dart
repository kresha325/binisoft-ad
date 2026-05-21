import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/catalog_card_grid.dart';
import '../../../../core/widgets/catalog_entity_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/page_header_action_scope.dart';
import '../../../../core/widgets/search_toolbar.dart';
import '../../../../core/widgets/shell_add_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/table_row_actions.dart';
import '../../domain/entities/contest.dart';
import '../providers/contests_providers.dart';
import '../widgets/add_contest_sheet.dart';
import '../widgets/contest_entries_sheet.dart';

class ContestsScreen extends ConsumerStatefulWidget {
  const ContestsScreen({super.key});

  @override
  ConsumerState<ContestsScreen> createState() => _ContestsScreenState();
}

class _ContestsScreenState extends ConsumerState<ContestsScreen> {
  String _search = '';
  ContestLifecycleStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final contests = ref.watch(contestsListProvider);

    return PageHeaderActionScope(
      route: '/contests',
      action: ShellAddButton(
        label: l10n.contestAddTitle,
        onPressed: () => showAddContestSheet(context, ref),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchToolbar(
            searchHint: l10n.searchContests,
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
                l10n.contestStatusLive,
                _statusFilter == ContestLifecycleStatus.live,
                () => setState(() => _statusFilter = ContestLifecycleStatus.live),
              ),
              _filterChip(
                l10n.contestStatusScheduled,
                _statusFilter == ContestLifecycleStatus.scheduled,
                () =>
                    setState(() => _statusFilter = ContestLifecycleStatus.scheduled),
              ),
              _filterChip(
                l10n.contestStatusExpired,
                _statusFilter == ContestLifecycleStatus.expired,
                () => setState(() => _statusFilter = ContestLifecycleStatus.expired),
              ),
              _filterChip(
                l10n.statusInactive,
                _statusFilter == ContestLifecycleStatus.inactive,
                () =>
                    setState(() => _statusFilter = ContestLifecycleStatus.inactive),
              ),
            ],
          ),
          const SizedBox(height: 16),
          contests.when(
            loading: () => const SizedBox(height: 280, child: LoadingOverlay()),
            error: (e, _) => Center(
              child: Text(l10n.errorGeneric('$e'), style: TextStyle(color: colors.danger)),
            ),
            data: (items) {
              var filtered = items;
              if (_search.isNotEmpty) {
                filtered = filtered
                    .where(
                      (c) =>
                          c.title.toLowerCase().contains(_search) ||
                          (c.prize?.toLowerCase().contains(_search) ?? false) ||
                          (c.description?.toLowerCase().contains(_search) ?? false),
                    )
                    .toList();
              }
              if (_statusFilter != null) {
                filtered =
                    filtered.where((c) => c.lifecycleStatus == _statusFilter).toList();
              }

              return CatalogCardGrid(
                tallCells: true,
                emptyMessage: l10n.contestsEmpty,
                children: [
                  for (final c in filtered)
                    CatalogEntityCard(
                      title: c.title,
                      subtitle: c.prize,
                      meta:
                          '${DateFormat('d MMM').format(c.startsAt)} – ${DateFormat('d MMM yyyy').format(c.endsAt)}',
                      leading: c.imageUrl != null && c.imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                c.imageUrl!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.emoji_events_outlined,
                                  color: colors.accent,
                                  size: 28,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.emoji_events_outlined,
                              color: colors.accent,
                              size: 28,
                            ),
                      chips: [
                        _ContestStatusChip(status: c.lifecycleStatus),
                        InkWell(
                          onTap: () =>
                              showContestEntriesSheet(context, ref, contest: c),
                          borderRadius: BorderRadius.circular(20),
                          child: StatusChip(
                            label: l10n.contestEntryCount(c.entryCount),
                            tone: c.entryCount > 0
                                ? StatusChipTone.accent
                                : StatusChipTone.neutral,
                          ),
                        ),
                        if (c.prize != null && c.prize!.isNotEmpty)
                          StatusChip(
                            label: c.prize!,
                            tone: StatusChipTone.accent,
                          ),
                      ],
                      footer: SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonalIcon(
                          onPressed: () =>
                              showContestEntriesSheet(context, ref, contest: c),
                          icon: const Icon(Icons.people_outline, size: 20),
                          label: Text(
                            c.entryCount > 0
                                ? '${l10n.contestViewEntries} (${c.entryCount})'
                                : l10n.contestViewEntries,
                          ),
                        ),
                      ),
                      trailing: TableRowActions(
                        onEdit: () => showContestSheet(context, ref, contest: c),
                        onDelete: () => deleteContest(context, ref, c),
                      ),
                    ),
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
}

class _ContestStatusChip extends StatelessWidget {
  const _ContestStatusChip({required this.status});

  final ContestLifecycleStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, tone, icon) = switch (status) {
      ContestLifecycleStatus.live => (
          l10n.contestStatusLive,
          StatusChipTone.success,
          Icons.emoji_events_outlined,
        ),
      ContestLifecycleStatus.scheduled => (
          l10n.contestStatusScheduled,
          StatusChipTone.accent,
          Icons.schedule_outlined,
        ),
      ContestLifecycleStatus.expired => (
          l10n.contestStatusExpired,
          StatusChipTone.warning,
          Icons.event_busy_outlined,
        ),
      ContestLifecycleStatus.inactive => (
          l10n.statusInactive,
          StatusChipTone.neutral,
          Icons.pause_circle_outline,
        ),
    };
    return StatusChip(label: label, tone: tone, icon: icon);
  }
}
