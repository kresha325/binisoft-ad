import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessApiKeyRecord {
  const BusinessApiKeyRecord({
    required this.id,
    required this.name,
    required this.keyPrefix,
    required this.active,
    required this.createdAt,
    this.lastUsedAt,
  });

  final String id;
  final String name;
  final String keyPrefix;
  final bool active;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  factory BusinessApiKeyRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return BusinessApiKeyRecord(
      id: doc.id,
      name: data['name'] as String? ?? 'API key',
      keyPrefix: data['keyPrefix'] as String? ?? 'jsk_…',
      active: data['active'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastUsedAt: (data['lastUsedAt'] as Timestamp?)?.toDate(),
    );
  }
}

class CreatedApiKey {
  const CreatedApiKey({
    required this.record,
    required this.plainKey,
  });

  final BusinessApiKeyRecord record;
  final String plainKey;
}
