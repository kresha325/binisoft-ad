import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../models/api_key_model.dart';

class ApiKeyRepository {
  ApiKeyRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;
  static const _uuid = Uuid();

  String _hashKey(String plain) =>
      sha256.convert(utf8.encode(plain)).toString();

  String _generatePlainKey() => 'jsk_${_uuid.v4().replaceAll('-', '')}';

  Stream<List<BusinessApiKeyRecord>> watchKeys({required String businessId}) {
    return _paths
        .apiKeys(businessId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map(BusinessApiKeyRecord.fromFirestore).toList(),
        );
  }

  Future<CreatedApiKey> createKey({
    required String businessId,
    required String name,
  }) async {
    final plain = _generatePlainKey();
    final prefix = '${plain.substring(0, 12)}…';
    final ref = _paths.apiKeys(businessId).doc();
    await ref.set({
      'name': name.trim().isEmpty ? 'E-commerce' : name.trim(),
      'keyPrefix': prefix,
      'secretHash': _hashKey(plain),
      'scopes': ['orders:create'],
      'active': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    final snap = await ref.get();
    return CreatedApiKey(
      record: BusinessApiKeyRecord.fromFirestore(snap),
      plainKey: plain,
    );
  }

  Future<void> revokeKey({
    required String businessId,
    required String keyId,
  }) async {
    await _paths.apiKeys(businessId).doc(keyId).update({'active': false});
  }
}
