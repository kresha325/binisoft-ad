import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../domain/entities/employee.dart';
import '../employee_payment_schedule.dart';
import '../models/employee_model.dart';

class EmployeeRepository {
  EmployeeRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  CollectionReference<Map<String, dynamic>> _employees(String businessId) =>
      _paths.employees(businessId);

  Stream<List<Employee>> watchList({required String businessId}) {
    return _employees(businessId).orderBy('lastName').snapshots().map((snap) {
      final list =
          snap.docs.map((d) => EmployeeModel.fromFirestore(d).toEntity()).toList();
      list.sort((a, b) {
        final ln = a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
        if (ln != 0) return ln;
        return a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
      });
      return list;
    });
  }

  Future<Employee> create({
    required String businessId,
    required String firstName,
    required String lastName,
    String email = '',
    String phone = '',
    String photoUrl = '',
    required double salary,
    required int paymentDayOfMonth,
    int reminderDaysBefore = 1,
    bool active = true,
    bool showOnSite = false,
  }) async {
    final ref = _employees(businessId).doc();
    final model = EmployeeModel(
      id: ref.id,
      businessId: businessId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
      salary: salary,
      paymentDayOfMonth: paymentDayOfMonth.clamp(1, 28),
      reminderDaysBefore: reminderDaysBefore,
      active: active,
      showOnSite: showOnSite,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.set(model.toFirestore(forCreate: true));
    final snap = await ref.get();
    return EmployeeModel.fromFirestore(snap).toEntity();
  }

  Future<void> update({
    required String businessId,
    required String employeeId,
    required String firstName,
    required String lastName,
    String email = '',
    String phone = '',
    String photoUrl = '',
    required double salary,
    required int paymentDayOfMonth,
    int reminderDaysBefore = 1,
    bool active = true,
    bool showOnSite = false,
  }) async {
    final ref = _employees(businessId).doc(employeeId);
    final snap = await ref.get();
    final existing = snap.exists ? EmployeeModel.fromFirestore(snap) : null;
    final payDay = paymentDayOfMonth.clamp(1, 28);
    final reminder = reminderDaysBefore.clamp(0, 30);

    String? reminderSentForMonth = existing?.reminderSentForMonth;
    if (existing != null &&
        (existing.paymentDayOfMonth != payDay ||
            existing.reminderDaysBefore != reminder)) {
      reminderSentForMonth = null;
    }

    await ref.set(
      {
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'photoUrl': photoUrl.trim(),
        'salary': salary,
        'paymentDayOfMonth': payDay,
        'reminderDaysBefore': reminder,
        'active': active,
        'showOnSite': showOnSite,
        'updatedAt': FieldValue.serverTimestamp(),
        if (reminderSentForMonth == null)
          'reminderSentForMonth': FieldValue.delete()
        else
          'reminderSentForMonth': reminderSentForMonth,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> delete({
    required String businessId,
    required String employeeId,
  }) async {
    await _employees(businessId).doc(employeeId).delete();
  }

  Future<bool> tryClaimPaymentReminder({
    required String businessId,
    required String employeeId,
    required String cycleMonthKey,
  }) async {
    final docRef = _employees(businessId).doc(employeeId);
    return docRef.firestore.runTransaction<bool>((txn) async {
      final snap = await txn.get(docRef);
      if (!snap.exists) return false;
      final data = snap.data()!;
      if (data['active'] != true) return false;
      if (data['reminderSentForMonth'] == cycleMonthKey) return false;
      final days = (data['reminderDaysBefore'] as num?)?.toInt() ?? 0;
      if (days <= 0) return false;
      final payDay = (data['paymentDayOfMonth'] as num?)?.toInt() ?? 1;
      if (!EmployeePaymentSchedule.shouldSendReminder(
        paymentDayOfMonth: payDay,
        reminderDaysBefore: days,
        reminderSentForMonth: data['reminderSentForMonth'] as String?,
      )) {
        return false;
      }
      txn.update(docRef, {
        'reminderSentForMonth': cycleMonthKey,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    });
  }
}
