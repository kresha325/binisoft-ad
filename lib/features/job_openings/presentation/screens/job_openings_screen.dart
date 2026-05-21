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
import '../../domain/entities/job_opening.dart';
import '../employment_type_labels.dart';
import '../providers/job_openings_providers.dart';
import '../widgets/add_job_opening_sheet.dart';
import '../widgets/job_applications_sheet.dart';

class JobOpeningsScreen extends ConsumerStatefulWidget {
  const JobOpeningsScreen({super.key});

  @override
  ConsumerState<JobOpeningsScreen> createState() => _JobOpeningsScreenState();
}

class _JobOpeningsScreenState extends ConsumerState<JobOpeningsScreen> {
  String _search = '';
  JobOpeningLifecycleStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final openings = ref.watch(jobOpeningsListProvider);

    return PageHeaderActionScope(
      route: '/job-openings',
      action: ShellAddButton(
        label: l10n.jobAddTitle,
        onPressed: () => showAddJobOpeningSheet(context, ref),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchToolbar(
            searchHint: l10n.searchJobOpenings,
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
                l10n.jobStatusLive,
                _statusFilter == JobOpeningLifecycleStatus.live,
                () => setState(() => _statusFilter = JobOpeningLifecycleStatus.live),
              ),
              _filterChip(
                l10n.jobStatusScheduled,
                _statusFilter == JobOpeningLifecycleStatus.scheduled,
                () => setState(() => _statusFilter = JobOpeningLifecycleStatus.scheduled),
              ),
              _filterChip(
                l10n.jobStatusExpired,
                _statusFilter == JobOpeningLifecycleStatus.expired,
                () => setState(() => _statusFilter = JobOpeningLifecycleStatus.expired),
              ),
              _filterChip(
                l10n.statusInactive,
                _statusFilter == JobOpeningLifecycleStatus.inactive,
                () => setState(() => _statusFilter = JobOpeningLifecycleStatus.inactive),
              ),
            ],
          ),
          const SizedBox(height: 16),
          openings.when(
            loading: () => const SizedBox(height: 280, child: LoadingOverlay()),
            error: (e, _) => Center(
              child: Text(l10n.errorGeneric('$e'), style: TextStyle(color: colors.danger)),
            ),
            data: (items) {
              var filtered = items;
              if (_search.isNotEmpty) {
                filtered = filtered
                    .where(
                      (j) =>
                          j.title.toLowerCase().contains(_search) ||
                          (j.location?.toLowerCase().contains(_search) ?? false) ||
                          (j.description?.toLowerCase().contains(_search) ?? false),
                    )
                    .toList();
              }
              if (_statusFilter != null) {
                filtered =
                    filtered.where((j) => j.lifecycleStatus == _statusFilter).toList();
              }

              return CatalogCardGrid(
                emptyMessage: l10n.jobsEmpty,
                children: [
                  for (final j in filtered)
                    CatalogEntityCard(
                      title: j.title,
                      subtitle: j.location,
                      meta:
                          '${DateFormat('d MMM').format(j.startsAt)} – ${DateFormat('d MMM yyyy').format(j.endsAt)}',
                      leading: j.imageUrl != null && j.imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                j.imageUrl!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.work_outline,
                                  color: colors.accent,
                                  size: 28,
                                ),
                              ),
                            )
                          : Icon(Icons.work_outline, color: colors.accent, size: 28),
                      chips: [
                        _JobStatusChip(status: j.lifecycleStatus),
                        StatusChip(
                          label: l10n.jobApplicationCount(j.applicationCount),
                          tone: StatusChipTone.neutral,
                        ),
                        if (j.employmentType != null)
                          StatusChip(
                            label: employmentTypeLabel(l10n, j.employmentType),
                            tone: StatusChipTone.accent,
                          ),
                      ],
                      trailing: TableRowActions(
                        onViewEntries: () =>
                            showJobApplicationsSheet(context, ref, opening: j),
                        viewEntriesTooltip: l10n.jobViewApplications,
                        onEdit: () => showJobOpeningSheet(context, ref, opening: j),
                        onDelete: () => deleteJobOpening(context, ref, j),
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

class _JobStatusChip extends StatelessWidget {
  const _JobStatusChip({required this.status});

  final JobOpeningLifecycleStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, tone, icon) = switch (status) {
      JobOpeningLifecycleStatus.live => (
          l10n.jobStatusLive,
          StatusChipTone.success,
          Icons.work_outline,
        ),
      JobOpeningLifecycleStatus.scheduled => (
          l10n.jobStatusScheduled,
          StatusChipTone.accent,
          Icons.schedule_outlined,
        ),
      JobOpeningLifecycleStatus.expired => (
          l10n.jobStatusExpired,
          StatusChipTone.warning,
          Icons.event_busy_outlined,
        ),
      JobOpeningLifecycleStatus.inactive => (
          l10n.statusInactive,
          StatusChipTone.neutral,
          Icons.pause_circle_outline,
        ),
    };
    return StatusChip(label: label, tone: tone, icon: icon);
  }
}
