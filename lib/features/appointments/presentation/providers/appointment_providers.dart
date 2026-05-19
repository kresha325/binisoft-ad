import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../business/presentation/providers/business_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../data/appointment_lifecycle_service.dart';
import '../../data/appointment_reminder_service.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../domain/appointment_date.dart';
import '../../domain/entities/appointment.dart';

class AppointmentDashboardStats {
  const AppointmentDashboardStats({
    required this.todayCount,
    required this.upcomingCount,
  });

  final int todayCount;
  final int upcomingCount;
}

final appointmentDashboardStatsProvider =
    Provider<AppointmentDashboardStats>((ref) {
  final appointments = ref.watch(appointmentsListProvider).valueOrNull ?? [];
  final today = appointmentDateOnly(DateTime.now());

  var todayCount = 0;
  var upcomingCount = 0;

  for (final a in appointments) {
    if (!a.countsAsScheduled) continue;
    final day = appointmentDateOnly(a.scheduledAt);
    if (appointmentIsSameDay(day, today)) {
      todayCount++;
    } else if (day.isAfter(today)) {
      upcomingCount++;
    }
  }

  return AppointmentDashboardStats(
    todayCount: todayCount,
    upcomingCount: upcomingCount,
  );
});

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository(firestore: ref.watch(firestoreProvider));
});

final appointmentLifecycleServiceProvider =
    Provider<AppointmentLifecycleService>((ref) {
  return AppointmentLifecycleService(
    repository: ref.watch(appointmentRepositoryProvider),
  );
});

final appointmentReminderServiceProvider =
    Provider<AppointmentReminderService>((ref) {
  return AppointmentReminderService(
    repository: ref.watch(appointmentRepositoryProvider),
    lifecycle: ref.watch(appointmentLifecycleServiceProvider),
    dispatcher: ref.watch(notificationDispatcherProvider),
  );
});

final appointmentsListProvider = StreamProvider<List<Appointment>>((ref) {
  final businessId = ref.watch(currentBusinessProvider).valueOrNull?.id;
  if (businessId == null) return Stream.value([]);
  return ref
      .watch(appointmentRepositoryProvider)
      .watchList(businessId: businessId);
});
