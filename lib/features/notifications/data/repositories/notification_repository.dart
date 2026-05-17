import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../domain/entities/app_notification.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  NotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final FirebaseFirestore _firestore;
  final TenantPaths _paths;

  static const _collection = 'notifications';

  CollectionReference<Map<String, dynamic>> _notifications(String userId) =>
      _paths.user(userId).collection(_collection);

  Stream<List<AppNotification>> watchForUser(String userId, {int limit = 50}) {
    return _notifications(userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => NotificationModel.fromFirestore(d).toEntity())
              .toList(),
        );
  }

  Future<void> create({
    required String userId,
    required CreateNotificationInput input,
  }) async {
    await _notifications(userId).add(
      NotificationModel(
        id: '',
        type: input.type.value,
        title: input.title,
        body: input.body,
        read: false,
        createdAt: DateTime.now(),
        businessId: input.businessId,
        actionRoute: input.actionRoute,
      ).toMap(),
    );
  }

  Future<void> markAsRead({
    required String userId,
    required String notificationId,
  }) async {
    await _notifications(userId).doc(notificationId).update({'read': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final snap = await _notifications(userId).where('read', isEqualTo: false).get();
    if (snap.docs.isEmpty) return;
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }
}
