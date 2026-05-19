import '../domain/entities/appointment.dart';
import 'repositories/appointment_repository.dart';

/// Keeps appointment status in sync (e.g. auto-complete after [scheduledAt]).
class AppointmentLifecycleService {
  AppointmentLifecycleService({required AppointmentRepository repository})
      : _repository = repository;

  final AppointmentRepository _repository;

  /// Past scheduled rows (not cancelled) → [AppointmentStatus.completed].
  Future<void> syncExpired({
    required String businessId,
    required List<Appointment> appointments,
  }) {
    return _repository.completeExpiredScheduled(
      businessId: businessId,
      appointments: appointments,
    );
  }
}
