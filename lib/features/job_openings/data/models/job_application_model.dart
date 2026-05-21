import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/job_application.dart';

class JobApplicationModel {
  JobApplicationModel({
    required this.id,
    required this.jobOpeningId,
    required this.name,
    required this.phone,
    this.email,
    this.note,
    required this.createdAt,
  });

  final String id;
  final String jobOpeningId;
  final String name;
  final String phone;
  final String? email;
  final String? note;
  final DateTime createdAt;

  factory JobApplicationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return JobApplicationModel(
      id: doc.id,
      jobOpeningId: data['jobOpeningId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      email: (data['email'] as String?)?.trim(),
      note: (data['note'] as String?)?.trim(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  JobApplication toEntity() => JobApplication(
        id: id,
        jobOpeningId: jobOpeningId,
        name: name,
        phone: phone,
        email: email,
        note: note,
        createdAt: createdAt,
      );
}
