import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/domain/entities/business.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../../domain/entities/appointment.dart';
import '../providers/appointment_providers.dart';

/// Keeps appointment reminders in sync while the admin shell is visible.
class AppointmentReminderListener extends ConsumerStatefulWidget {
  const AppointmentReminderListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppointmentReminderListener> createState() =>
      _AppointmentReminderListenerState();
}

class _AppointmentReminderListenerState
    extends ConsumerState<AppointmentReminderListener> {
  Timer? _timer;
  Timer? _debounce;
  bool _syncInFlight = false;
  ProviderSubscription<AsyncValue<List<Appointment>>>? _appointmentsSub;
  ProviderSubscription<AsyncValue<Business?>>? _businessSub;

  @override
  void initState() {
    super.initState();
    _appointmentsSub = ref.listenManual(
      appointmentsListProvider,
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
    _appointmentsSub?.close();
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
    final appointments = providers.read(appointmentsListProvider).valueOrNull;
    if (business == null || uid == null || appointments == null) return;

    final l10n = context.l10n;
    final title = l10n.appointmentReminderNotificationTitle;
    String body(String name, String serviceType, String when) =>
        l10n.appointmentReminderNotificationBody(name, serviceType, when);

    await providers.read(appointmentReminderServiceProvider).syncReminders(
          business: business,
          currentUserId: uid,
          appointments: appointments,
          reminderTitle: title,
          reminderBody: body,
        );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
