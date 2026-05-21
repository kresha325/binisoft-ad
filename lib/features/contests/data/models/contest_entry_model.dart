import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/contest_entry.dart';

class ContestEntryModel {
  ContestEntryModel({
    required this.id,
    required this.contestId,
    required this.name,
    required this.phone,
    this.email,
    this.note,
    required this.createdAt,
  });

  final String id;
  final String contestId;
  final String name;
  final String phone;
  final String? email;
  final String? note;
  final DateTime createdAt;

  factory ContestEntryModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ContestEntryModel(
      id: doc.id,
      contestId: data['contestId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      email: data['email'] as String?,
      note: data['note'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contestId': contestId,
      'name': name,
      'phone': phone,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (note != null && note!.isNotEmpty) 'note': note,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  ContestEntry toEntity() => ContestEntry(
        id: id,
        contestId: contestId,
        name: name,
        phone: phone,
        email: email,
        note: note,
        createdAt: createdAt,
      );
}
