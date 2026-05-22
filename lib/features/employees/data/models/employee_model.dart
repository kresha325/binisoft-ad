import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/employee.dart';

class EmployeeModel {
  EmployeeModel({
    required this.id,
    required this.businessId,
    required this.firstName,
    required this.lastName,
    this.email = '',
    this.phone = '',
    this.photoUrl = '',
    required this.salary,
    required this.paymentDayOfMonth,
    this.reminderDaysBefore = 1,
    this.reminderSentForMonth,
    this.active = true,
    this.showOnSite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String businessId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String photoUrl;
  final double salary;
  final int paymentDayOfMonth;
  final int reminderDaysBefore;
  final String? reminderSentForMonth;
  final bool active;
  final bool showOnSite;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory EmployeeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final created = data['createdAt'];
    final updated = data['updatedAt'];
    return EmployeeModel(
      id: doc.id,
      businessId: data['businessId'] as String? ?? '',
      firstName: data['firstName'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      photoUrl: data['photoUrl'] as String? ?? '',
      salary: (data['salary'] as num?)?.toDouble() ?? 0,
      paymentDayOfMonth: (data['paymentDayOfMonth'] as num?)?.toInt() ?? 1,
      reminderDaysBefore: (data['reminderDaysBefore'] as num?)?.toInt() ?? 0,
      reminderSentForMonth: data['reminderSentForMonth'] as String?,
      active: data['active'] as bool? ?? true,
      showOnSite: data['showOnSite'] as bool? ?? false,
      createdAt: created is Timestamp ? created.toDate() : DateTime.now(),
      updatedAt: updated is Timestamp ? updated.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore({bool forCreate = false}) {
    return {
      'businessId': businessId,
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'photoUrl': photoUrl.trim(),
      'salary': salary,
      'paymentDayOfMonth': paymentDayOfMonth.clamp(1, 28),
      'reminderDaysBefore': reminderDaysBefore.clamp(0, 30),
      if (reminderSentForMonth != null) 'reminderSentForMonth': reminderSentForMonth,
      'active': active,
      'showOnSite': showOnSite,
      if (forCreate) 'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Employee toEntity() => Employee(
        id: id,
        businessId: businessId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
        salary: salary,
        paymentDayOfMonth: paymentDayOfMonth,
        reminderDaysBefore: reminderDaysBefore,
        reminderSentForMonth: reminderSentForMonth,
        active: active,
        showOnSite: showOnSite,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
