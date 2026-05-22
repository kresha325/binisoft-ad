import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/domain/entities/business.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../../domain/entities/employee.dart';
import '../providers/employee_providers.dart';

/// In-app salary payment reminders while the admin shell is open.
class EmployeeReminderListener extends ConsumerStatefulWidget {
  const EmployeeReminderListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<EmployeeReminderListener> createState() =>
      _EmployeeReminderListenerState();
}

class _EmployeeReminderListenerState extends ConsumerState<EmployeeReminderListener> {
  Timer? _timer;
  Timer? _debounce;
  bool _syncInFlight = false;
  ProviderSubscription<AsyncValue<List<Employee>>>? _employeesSub;
  ProviderSubscription<AsyncValue<Business?>>? _businessSub;

  @override
  void initState() {
    super.initState();
    _employeesSub = ref.listenManual(
      employeesListProvider,
      (_, __) => _scheduleTick(),
    );
    _businessSub = ref.listenManual(
      currentBusinessProvider,
      (_, __) => _scheduleTick(),
    );
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _scheduleTick());
    WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleTick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _debounce?.cancel();
    _employeesSub?.close();
    _businessSub?.close();
    super.dispose();
  }

  void _scheduleTick() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) unawaited(_tick());
    });
  }

  Future<void> _tick() async {
    if (_syncInFlight || !mounted) return;
    _syncInFlight = true;
    try {
      await _runSync();
    } finally {
      _syncInFlight = false;
    }
  }

  Future<void> _runSync() async {
    if (!mounted) return;
    final providers = ProviderScope.containerOf(context, listen: false);
    final business = providers.read(currentBusinessProvider).valueOrNull;
    final uid = providers.read(authStateProvider).valueOrNull?.id;
    final employees = providers.read(employeesListProvider).valueOrNull;
    if (business == null || uid == null || employees == null) return;

    final l10n = context.l10n;
    await providers.read(employeeReminderServiceProvider).syncReminders(
          business: business,
          currentUserId: uid,
          employees: employees,
          reminderTitle: l10n.employeeReminderNotificationTitle,
          reminderBody: l10n.employeeReminderNotificationBody,
        );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
