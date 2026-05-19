/// Scheduled reservation (termin / rezervim).
class Appointment {
  const Appointment({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.serviceType,
    required this.phoneNumber,
    required this.scheduledAt,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.reminderMinutesBefore,
    this.reminderSentAt,
    this.status = AppointmentStatus.scheduled,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String description;
  final String serviceType;
  final String phoneNumber;
  final DateTime scheduledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  /// Minutes before [scheduledAt] to fire an in-app reminder; `null` = off.
  final int? reminderMinutesBefore;
  final DateTime? reminderSentAt;
  final AppointmentStatus status;

  String get fullName => '$firstName $lastName'.trim();

  bool get hasReminder =>
      reminderMinutesBefore != null && reminderMinutesBefore! > 0;

  DateTime? get reminderAt {
    if (!hasReminder) return null;
    return scheduledAt.subtract(Duration(minutes: reminderMinutesBefore!));
  }

  /// True once [scheduledAt] has passed (termini ka skaduar).
  bool get isExpired => !scheduledAt.isAfter(DateTime.now());

  /// Shfaqet / filtrohet si përfunduar (jo anuluar, koha ka kaluar).
  bool get countsAsCompleted =>
      status == AppointmentStatus.completed ||
      (status == AppointmentStatus.scheduled && isExpired);

  /// Ende aktiv — planifikuar dhe koha nuk ka kaluar ende.
  bool get countsAsScheduled =>
      status == AppointmentStatus.scheduled && !isExpired;

  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final hay = '${fullName.toLowerCase()} ${description.toLowerCase()} '
        '${serviceType.toLowerCase()} ${phoneNumber.toLowerCase()}';
    return hay.contains(query);
  }
}

enum AppointmentStatus {
  scheduled,
  completed,
  cancelled;

  String get firestoreValue => name;
}
