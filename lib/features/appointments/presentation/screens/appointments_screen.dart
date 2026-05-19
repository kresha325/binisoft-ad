import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/layout/app_breakpoints.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/data_table_card.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/page_header_action_scope.dart';
import '../../../../core/widgets/search_toolbar.dart';
import '../../../../core/widgets/shell_add_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/table_row_actions.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../../domain/entities/appointment.dart';
import '../providers/appointment_providers.dart';
import '../../domain/appointment_date.dart';
import '../widgets/appointment_actions_sheet.dart';
import '../widgets/appointment_calendar_panel.dart';
import '../widgets/appointment_form_sheet.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  String _query = '';
  AppointmentStatus? _statusFilter;
  late DateTime _selectedDay;
  late DateTime _focusedMonth;
  ProviderSubscription<AsyncValue<List<Appointment>>>? _appointmentsSub;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = appointmentDateOnly(now);
    _focusedMonth = DateTime(now.year, now.month);
    _appointmentsSub = ref.listenManual(
      appointmentsListProvider,
      (_, next) => unawaited(_syncExpiredAppointments(next)),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_syncExpiredAppointments(ref.read(appointmentsListProvider)));
    });
  }

  @override
  void dispose() {
    _appointmentsSub?.close();
    super.dispose();
  }

  Future<void> _syncExpiredAppointments(
    AsyncValue<List<Appointment>> appointmentsAsync,
  ) async {
    if (!mounted) return;
    final businessId = ref.read(currentBusinessProvider).valueOrNull?.id;
    final list = appointmentsAsync.valueOrNull;
    if (businessId == null || list == null) return;
    await ref.read(appointmentLifecycleServiceProvider).syncExpired(
          businessId: businessId,
          appointments: list,
        );
  }

  bool _matchesStatusFilter(Appointment a) {
    final filter = _statusFilter;
    if (filter == null) return true;
    return switch (filter) {
      AppointmentStatus.scheduled => a.countsAsScheduled,
      AppointmentStatus.completed => a.countsAsCompleted,
      AppointmentStatus.cancelled => a.status == AppointmentStatus.cancelled,
    };
  }

  Set<DateTime> _daysWithAppointments(List<Appointment> items) {
    return items
        .map((a) => appointmentDateOnly(a.scheduledAt))
        .toSet();
  }

  List<Appointment> _filterAppointments(List<Appointment> items) {
    var filtered = items.where((a) {
      if (!appointmentIsSameDay(a.scheduledAt, _selectedDay)) return false;
      return a.matchesSearch(_query);
    }).toList();
    filtered = filtered.where(_matchesStatusFilter).toList();
    filtered.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final appointmentsAsync = ref.watch(appointmentsListProvider);
    final isMobile = AppBreakpoints.isMobile(context);
    final timeFmt = DateFormat.Hm();
    final dateTimeFmt = DateFormat('d MMM yyyy, HH:mm');

    return PageHeaderActionScope(
      route: '/appointments',
      action: ShellAddButton(
        label: l10n.appointmentAdd,
        onPressed: () => showAppointmentFormSheet(context, ref),
      ),
      child: appointmentsAsync.when(
        loading: () => const SizedBox(height: 280, child: LoadingOverlay()),
        error: (e, _) => Center(
          child: Text(
            l10n.errorGeneric('$e'),
            style: TextStyle(color: colors.danger),
          ),
        ),
        data: (allItems) {
          final daysWithEvents = _daysWithAppointments(allItems);
          final filtered = _filterAppointments(allItems);
          final countLabel = l10n.appointmentDayCount(filtered.length);

          final calendar = AppointmentCalendarPanel(
            focusedMonth: _focusedMonth,
            selectedDay: _selectedDay,
            daysWithAppointments: daysWithEvents,
            onDaySelected: (d) => setState(() => _selectedDay = d),
            onMonthChanged: (m) => setState(() {
              _focusedMonth = DateTime(m.year, m.month);
            }),
            onToday: () => setState(() {
              final now = DateTime.now();
              _selectedDay = appointmentDateOnly(now);
              _focusedMonth = DateTime(now.year, now.month);
            }),
          );

          final filters = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchToolbar(
                searchHint: l10n.searchAppointments,
                onSearchChanged: (v) => setState(() => _query = v.toLowerCase()),
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
                    l10n.appointmentStatusScheduled,
                    _statusFilter == AppointmentStatus.scheduled,
                    () => setState(
                        () => _statusFilter = AppointmentStatus.scheduled),
                  ),
                  _filterChip(
                    l10n.appointmentStatusCompleted,
                    _statusFilter == AppointmentStatus.completed,
                    () => setState(
                        () => _statusFilter = AppointmentStatus.completed),
                  ),
                  _filterChip(
                    l10n.appointmentStatusCancelled,
                    _statusFilter == AppointmentStatus.cancelled,
                    () => setState(
                        () => _statusFilter = AppointmentStatus.cancelled),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                countLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );

          final list = DataTableCard(
            columns: [
              l10n.appointmentTime,
              l10n.appointmentFullName,
              l10n.appointmentServiceType,
              l10n.appointmentPhone,
              l10n.appointmentDescription,
              l10n.tableStatus,
              '',
            ],
            emptyMessage: allItems.isEmpty
                ? l10n.appointmentEmpty
                : l10n.appointmentEmptyDay,
            rows: filtered.map((a) => _row(context, ref, a, timeFmt, dateTimeFmt))
                .toList(),
          );

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                calendar,
                const SizedBox(height: 16),
                filters,
                const SizedBox(height: 12),
                list,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 300, child: calendar),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    filters,
                    const SizedBox(height: 16),
                    list,
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  DataRow _row(
    BuildContext context,
    WidgetRef ref,
    Appointment a,
    DateFormat timeFmt,
    DateFormat dateTimeFmt,
  ) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final displayStatus = a.status == AppointmentStatus.cancelled
        ? AppointmentStatus.cancelled
        : a.countsAsCompleted
            ? AppointmentStatus.completed
            : AppointmentStatus.scheduled;
    final statusLabel = switch (displayStatus) {
      AppointmentStatus.scheduled => l10n.appointmentStatusScheduled,
      AppointmentStatus.completed => l10n.appointmentStatusCompleted,
      AppointmentStatus.cancelled => l10n.appointmentStatusCancelled,
    };
    final statusTone = switch (displayStatus) {
      AppointmentStatus.scheduled => StatusChipTone.accent,
      AppointmentStatus.completed => StatusChipTone.success,
      AppointmentStatus.cancelled => StatusChipTone.neutral,
    };

    void openActions() => showAppointmentActionsSheet(
          context,
          ref,
          appointment: a,
          onSetStatus: (appointment, status) =>
              _setStatus(ref, appointment, status),
        );

    return DataRow(
      cells: [
        _tapCell(
          onTap: openActions,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timeFmt.format(a.scheduledAt),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                dateTimeFmt.format(a.scheduledAt),
                style: TextStyle(fontSize: 11, color: colors.textMuted),
              ),
            ],
          ),
        ),
        _tapCell(onTap: openActions, child: Text(a.fullName)),
        _tapCell(onTap: openActions, child: Text(a.serviceType)),
        _tapCell(onTap: openActions, child: Text(a.phoneNumber)),
        _tapCell(
          onTap: openActions,
          child: Text(
            a.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _tapCell(
          onTap: openActions,
          child: StatusChip(label: statusLabel, tone: statusTone),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (a.countsAsScheduled) ...[
                IconButton(
                  tooltip: l10n.appointmentMarkCompleted,
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  onPressed: () => _setStatus(
                    ref,
                    a,
                    AppointmentStatus.completed,
                  ),
                ),
                IconButton(
                  tooltip: l10n.appointmentMarkCancelled,
                  icon: const Icon(Icons.cancel_outlined, size: 20),
                  onPressed: () => _setStatus(
                    ref,
                    a,
                    AppointmentStatus.cancelled,
                  ),
                ),
              ],
              TableRowActions(
                onEdit: () => showAppointmentFormSheet(
                  context,
                  ref,
                  appointment: a,
                ),
                onDelete: () => _delete(context, ref, a),
              ),
            ],
          ),
        ),
      ],
    );
  }

  DataCell _tapCell({required VoidCallback onTap, required Widget child}) {
    return DataCell(
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          child: child,
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }

  Future<void> _setStatus(
    WidgetRef ref,
    Appointment appointment,
    AppointmentStatus status,
  ) async {
    final businessId = ref.read(currentBusinessProvider).valueOrNull?.id;
    if (businessId == null) return;
    await ref.read(appointmentRepositoryProvider).update(
          businessId: businessId,
          appointment: appointment,
          status: status,
        );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Appointment appointment,
  ) async {
    final l10n = context.l10n;
    final ok = await showConfirmDeleteDialog(
      context,
      title: l10n.appointmentDeleteConfirm,
      message: appointment.fullName,
    );
    if (!ok) return;
    final businessId = ref.read(currentBusinessProvider).valueOrNull?.id;
    if (businessId == null) return;
    await ref.read(appointmentRepositoryProvider).delete(
          businessId: businessId,
          appointmentId: appointment.id,
        );
  }
}
