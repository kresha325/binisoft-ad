import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/appointment.dart';

class AppointmentModel {
  AppointmentModel({
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
  final int? reminderMinutesBefore;
  final DateTime? reminderSentAt;
  final AppointmentStatus status;

  factory AppointmentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    final legacyClient = data['clientName'] as String? ?? '';
    final legacyTitle = data['title'] as String? ?? '';
    final legacyNotes = data['notes'] as String? ?? '';

    var firstName = data['firstName'] as String? ?? '';
    var lastName = data['lastName'] as String? ?? '';
    if (firstName.isEmpty && legacyClient.isNotEmpty) {
      final parts = legacyClient.trim().split(RegExp(r'\s+'));
      firstName = parts.first;
      if (parts.length > 1) {
        lastName = parts.sublist(1).join(' ');
      }
    }

    return AppointmentModel(
      id: doc.id,
      firstName: firstName,
      lastName: lastName,
      description: (data['description'] as String?)?.trim().isNotEmpty == true
          ? data['description'] as String
          : legacyNotes,
      serviceType: (data['serviceType'] as String?)?.trim().isNotEmpty == true
          ? data['serviceType'] as String
          : legacyTitle,
      phoneNumber: data['phoneNumber'] as String? ?? '',
      scheduledAt: _readTimestamp(data['scheduledAt']),
      createdAt: _readTimestamp(data['createdAt']),
      updatedAt: _readTimestamp(data['updatedAt']),
      createdBy: data['createdBy'] as String? ?? '',
      reminderMinutesBefore: data['reminderMinutesBefore'] as int?,
      reminderSentAt: _readOptionalTimestamp(data['reminderSentAt']),
      status: AppointmentStatus.values.firstWhere(
        (s) => s.name == (data['status'] as String?),
        orElse: () => AppointmentStatus.scheduled,
      ),
    );
  }

  static DateTime _readTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  static DateTime? _readOptionalTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return null;
  }

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'description': description,
        'serviceType': serviceType,
        'phoneNumber': phoneNumber,
        'scheduledAt': Timestamp.fromDate(scheduledAt),
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
        'createdBy': createdBy,
        if (reminderMinutesBefore != null) 'reminderMinutesBefore': reminderMinutesBefore,
        if (reminderSentAt != null)
          'reminderSentAt': Timestamp.fromDate(reminderSentAt!),
        'status': status.firestoreValue,
      };

  Appointment toEntity() => Appointment(
        id: id,
        firstName: firstName,
        lastName: lastName,
        description: description,
        serviceType: serviceType,
        phoneNumber: phoneNumber,
        scheduledAt: scheduledAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
        createdBy: createdBy,
        reminderMinutesBefore: reminderMinutesBefore,
        reminderSentAt: reminderSentAt,
        status: status,
      );
}
