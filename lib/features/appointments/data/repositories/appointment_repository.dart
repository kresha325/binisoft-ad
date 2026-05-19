import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../domain/entities/appointment.dart';
import '../models/appointment_model.dart';

class AppointmentRepository {
  AppointmentRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  CollectionReference<Map<String, dynamic>> _appointments(String businessId) =>
      _paths.appointments(businessId);

  Stream<List<Appointment>> watchList({required String businessId}) {
    return _appointments(businessId).snapshots().map((snap) {
      final items = snap.docs
          .map((d) => AppointmentModel.fromFirestore(d).toEntity())
          .toList();
      items.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      return items;
    });
  }

  Future<Appointment> create({
    required String businessId,
    required String firstName,
    required String lastName,
    required String description,
    required String serviceType,
    required String phoneNumber,
    required DateTime scheduledAt,
    required String createdBy,
    int? reminderMinutesBefore,
  }) async {
    final now = DateTime.now();
    final ref = _appointments(businessId).doc();
    final model = AppointmentModel(
      id: ref.id,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      description: description.trim(),
      serviceType: serviceType.trim(),
      phoneNumber: phoneNumber.trim(),
      scheduledAt: scheduledAt,
      createdAt: now,
      updatedAt: now,
      createdBy: createdBy,
      reminderMinutesBefore: reminderMinutesBefore,
    );
    await ref.set(model.toMap());
    return model.toEntity();
  }

  Future<void> update({
    required String businessId,
    required Appointment appointment,
    String? firstName,
    String? lastName,
    String? description,
    String? serviceType,
    String? phoneNumber,
    DateTime? scheduledAt,
    int? reminderMinutesBefore,
    bool updateReminder = false,
    bool clearReminderSent = false,
    AppointmentStatus? status,
  }) async {
    final ref = _appointments(businessId).doc(appointment.id);
    final data = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (firstName != null) data['firstName'] = firstName.trim();
    if (lastName != null) data['lastName'] = lastName.trim();
    if (description != null) data['description'] = description.trim();
    if (serviceType != null) data['serviceType'] = serviceType.trim();
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber.trim();
    if (scheduledAt != null) {
      data['scheduledAt'] = Timestamp.fromDate(scheduledAt);
    }
    if (updateReminder) {
      if (reminderMinutesBefore == null || reminderMinutesBefore <= 0) {
        data['reminderMinutesBefore'] = FieldValue.delete();
      } else {
        data['reminderMinutesBefore'] = reminderMinutesBefore;
      }
    }
    if (status != null) data['status'] = status.firestoreValue;
    if (clearReminderSent) {
      data['reminderSentAt'] = FieldValue.delete();
    }
    await ref.update(data);
  }

  /// Marks past [AppointmentStatus.scheduled] rows as completed so reminders stop.
  Future<void> completeExpiredScheduled({
    required String businessId,
    required List<Appointment> appointments,
  }) async {
    final now = DateTime.now();
    final expired = appointments.where(
      (a) => a.status == AppointmentStatus.scheduled && !a.scheduledAt.isAfter(now),
    );
    if (expired.isEmpty) return;

    final firestore = _appointments(businessId).firestore;
    var batch = firestore.batch();
    var pending = 0;

    for (final a in expired) {
      batch.update(_appointments(businessId).doc(a.id), {
        'status': AppointmentStatus.completed.firestoreValue,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      pending++;
      if (pending >= 500) {
        await batch.commit();
        batch = firestore.batch();
        pending = 0;
      }
    }
    if (pending > 0) await batch.commit();
  }

  /// Atomically marks reminder as sent. Returns false if already sent or missing.
  Future<bool> tryClaimReminderSend({
    required String businessId,
    required String appointmentId,
  }) async {
    final docRef = _appointments(businessId).doc(appointmentId);
    return docRef.firestore.runTransaction<bool>((txn) async {
      final snap = await txn.get(docRef);
      if (!snap.exists) return false;
      final data = snap.data()!;
      if (data['reminderSentAt'] != null) return false;
      final minutes = data['reminderMinutesBefore'];
      if (minutes is! num || minutes <= 0) return false;
      final scheduled = data['scheduledAt'];
      if (scheduled is Timestamp && !scheduled.toDate().isAfter(DateTime.now())) {
        txn.update(docRef, {
          'status': AppointmentStatus.completed.firestoreValue,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return false;
      }
      txn.update(docRef, {
        'reminderSentAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    });
  }

  Future<void> delete({
    required String businessId,
    required String appointmentId,
  }) async {
    await _appointments(businessId).doc(appointmentId).delete();
  }
}
