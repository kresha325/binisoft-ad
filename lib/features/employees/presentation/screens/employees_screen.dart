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
import '../../../../core/widgets/storage_network_image.dart';
import '../../../../core/widgets/table_row_actions.dart';
import '../../data/employee_payment_schedule.dart';
import '../../domain/entities/employee.dart';
import '../providers/employee_providers.dart';
import '../widgets/add_employee_sheet.dart';

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  String _search = '';
  bool? _activeFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final employees = ref.watch(employeesListProvider);
    final money = NumberFormat.currency(locale: 'sq', symbol: '€');

    return PageHeaderActionScope(
      route: '/employees',
      action: ShellAddButton(
        label: l10n.employeeAddTitle,
        onPressed: () => showAddEmployeeSheet(context, ref),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchToolbar(
            searchHint: l10n.searchEmployees,
            onSearchChanged: (v) => setState(() => _search = v.toLowerCase()),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _filterChip(l10n.filterAll, _activeFilter == null, () {
                setState(() => _activeFilter = null);
              }),
              _filterChip(l10n.statusActive, _activeFilter == true, () {
                setState(() => _activeFilter = true);
              }),
              _filterChip(l10n.statusInactive, _activeFilter == false, () {
                setState(() => _activeFilter = false);
              }),
            ],
          ),
          const SizedBox(height: 16),
          employees.when(
            loading: () => const SizedBox(height: 280, child: LoadingOverlay()),
            error: (e, _) => Center(
              child: Text(l10n.errorGeneric('$e'), style: TextStyle(color: colors.danger)),
            ),
            data: (items) {
              var filtered = items;
              if (_search.isNotEmpty) {
                filtered = filtered.where((e) => e.matchesSearch(_search)).toList();
              }
              if (_activeFilter != null) {
                filtered = filtered.where((e) => e.active == _activeFilter).toList();
              }

              return CatalogCardGrid(
                tallCells: true,
                emptyMessage: l10n.employeesEmpty,
                children: [
                  for (final e in filtered)
                    CatalogEntityCard(
                      title: e.fullName,
                      subtitle: [
                        if (e.email.isNotEmpty) e.email,
                        if (e.phone.isNotEmpty) e.phone,
                      ].join(' · '),
                      meta: l10n.employeePayMeta(
                        money.format(e.salary),
                        e.paymentDayOfMonth,
                      ),
                      leading: _employeeAvatar(e, colors),
                      chips: [
                        StatusChip(
                          label: e.active ? l10n.statusActive : l10n.statusInactive,
                          tone: e.active ? StatusChipTone.success : StatusChipTone.neutral,
                        ),
                        if (e.showOnSite && e.active)
                          StatusChip(
                            label: l10n.employeeOnSiteBadge,
                            tone: StatusChipTone.accent,
                          ),
                        if (e.hasReminder)
                          StatusChip(
                            label: l10n.employeeReminderBadge(e.reminderDaysBefore),
                            tone: StatusChipTone.accent,
                            icon: Icons.notifications_outlined,
                          ),
                      ],
                      footer: Text(
                        l10n.employeeNextPay(
                          DateFormat.yMMMd().format(
                            EmployeePaymentSchedule.nextPaymentOnOrAfter(
                              e.paymentDayOfMonth,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 12, color: colors.textMuted),
                      ),
                      trailing: TableRowActions(
                        onEdit: () => showEmployeeSheet(context, ref, employee: e),
                        onDelete: () => deleteEmployee(context, ref, e),
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

  Widget _employeeAvatar(Employee e, AppColorScheme colors) {
    if (e.photoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 48,
          height: 48,
          child: StorageNetworkImage(url: e.photoUrl, fit: BoxFit.cover),
        ),
      );
    }
    final initials = '${e.firstName.isNotEmpty ? e.firstName[0] : ''}'
        '${e.lastName.isNotEmpty ? e.lastName[0] : ''}'.toUpperCase();
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: colors.accent,
        ),
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
