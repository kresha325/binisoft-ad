import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/platform_notify_service.dart';
import 'models/notification_model.dart';
import 'repositories/notification_repository.dart';

/// Delivers notifications to the current user and platform superadmins.
class NotificationDispatcher {
  NotificationDispatcher({
    FirebaseFirestore? firestore,
    NotificationRepository? repository,
    PlatformNotifyService? platformNotify,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _repository = repository ?? NotificationRepository(firestore: firestore),
        _platformNotify = platformNotify ?? PlatformNotifyService();

  final FirebaseFirestore _firestore;
  final NotificationRepository _repository;
  final PlatformNotifyService _platformNotify;

  Future<void> notifyUser({
    required String userId,
    required CreateNotificationInput input,
  }) async {
    await _repository.create(userId: userId, input: input);
  }

  /// Notifies superadmins via Cloud Function (works for any signed-in user).
  Future<void> notifyPlatformAdmins(CreateNotificationInput input) async {
    try {
      await _platformNotify.notifySuperadmins(input);
    } catch (_) {
      await _notifyPlatformAdminsDirect(input);
    }
  }

  Future<void> _notifyPlatformAdminsDirect(CreateNotificationInput input) async {
    final snap = await _firestore
        .collection(FirestoreCollections.users)
        .where('role', isEqualTo: 'superadmin')
        .get();

    if (snap.docs.isEmpty) return;

    await Future.wait(
      snap.docs.map((doc) => _repository.create(userId: doc.id, input: input)),
    );
  }
}
