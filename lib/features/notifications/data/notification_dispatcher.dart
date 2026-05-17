import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/platform_notify_service.dart';
import 'models/notification_model.dart';
import 'repositories/notification_repository.dart';

/// Delivers notifications to the current user and platform superadmins.
class NotificationDispatcher {
  NotificationDispatcher({
    FirebaseFirestore? firestore,
    NotificationRepository? repository,
    PlatformNotifyService? platformNotify,
  })  : _repository = repository ?? NotificationRepository(firestore: firestore),
        _platformNotify = platformNotify ?? PlatformNotifyService();

  final NotificationRepository _repository;
  final PlatformNotifyService _platformNotify;

  Future<void> notifyUser({
    required String userId,
    required CreateNotificationInput input,
  }) async {
    await _repository.create(userId: userId, input: input);
  }

  /// Superadmin alerts are created by Firestore triggers; HTTP path is superadmin-only.
  Future<void> notifyPlatformAdmins(CreateNotificationInput input) async {
    try {
      await _platformNotify.notifySuperadmins(input);
    } catch (_) {
      // Non-superadmin callers rely on server triggers (registration / new business).
    }
  }
}
