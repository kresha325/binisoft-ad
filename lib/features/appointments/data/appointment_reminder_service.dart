import 'package:intl/intl.dart';

import '../../business/domain/entities/business.dart';
import '../../notifications/data/models/notification_model.dart';
import '../../notifications/data/notification_dispatcher.dart';
import '../../notifications/domain/notification_type.dart';
import '../domain/entities/appointment.dart';
import 'appointment_lifecycle_service.dart';
import 'repositories/appointment_repository.dart';

/// Fires in-app reminders when an appointment enters its reminder window.
class AppointmentReminderService {
  AppointmentReminderService({
    required AppointmentRepository repository,
    required AppointmentLifecycleService lifecycle,
    required NotificationDispatcher dispatcher,
  })  : _repository = repository,
        _lifecycle = lifecycle,
        _dispatcher = dispatcher;

  final AppointmentRepository _repository;
  final AppointmentLifecycleService _lifecycle;
  final NotificationDispatcher _dispatcher;

  Future<void> syncReminders({
    required Business business,
    required String currentUserId,
    required List<Appointment> appointments,
    required String reminderTitle,
    required String Function(String name, String serviceType, String when)
        reminderBody,
  }) async {
    await _lifecycle.syncExpired(
      businessId: business.id,
      appointments: appointments,
    );

    final now = DateTime.now();
    final recipients = <String>{
      business.ownerId,
      currentUserId,
    };

    for (final appointment in appointments) {
      if (!appointment.countsAsScheduled) continue;
      if (!appointment.hasReminder || appointment.reminderSentAt != null) {
        continue;
      }
      final remindAt = appointment.reminderAt;
      if (remindAt == null || now.isBefore(remindAt)) continue;

      final claimed = await _repository.tryClaimReminderSend(
        businessId: business.id,
        appointmentId: appointment.id,
      );
      if (!claimed) continue;

      final when = DateFormat.yMMMd().add_jm().format(appointment.scheduledAt);
      final body = reminderBody(
        appointment.fullName,
        appointment.serviceType,
        when,
      );

      for (final userId in recipients) {
        if (userId.isEmpty) continue;
        await _dispatcher.notifyUser(
          userId: userId,
          input: CreateNotificationInput(
            type: NotificationType.appointmentReminder,
            title: reminderTitle,
            body: body,
            businessId: business.id,
            actionRoute: '/appointments',
          ),
        );
      }
    }
  }
}
