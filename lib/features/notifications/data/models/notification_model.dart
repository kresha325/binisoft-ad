import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/notification_type.dart';

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.read,
    required this.createdAt,
    this.businessId,
    this.actionRoute,
  });

  final String id;
  final String type;
  final String title;
  final String body;
  final bool read;
  final DateTime createdAt;
  final String? businessId;
  final String? actionRoute;

  factory NotificationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    final created = data['createdAt'];
    return NotificationModel(
      id: doc.id,
      type: data['type'] as String? ?? NotificationType.system.value,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      read: data['read'] as bool? ?? false,
      createdAt: created is Timestamp
          ? created.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
      businessId: data['businessId'] as String?,
      actionRoute: data['actionRoute'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type,
        'title': title,
        'body': body,
        'read': read,
        'createdAt': Timestamp.fromDate(createdAt),
        if (businessId != null && businessId!.isNotEmpty) 'businessId': businessId,
        if (actionRoute != null && actionRoute!.isNotEmpty) 'actionRoute': actionRoute,
      };

  AppNotification toEntity() => AppNotification(
        id: id,
        type: NotificationType.fromString(type),
        title: title,
        body: body,
        read: read,
        createdAt: createdAt,
        businessId: businessId,
        actionRoute: actionRoute,
      );
}

class CreateNotificationInput {
  const CreateNotificationInput({
    required this.type,
    required this.title,
    required this.body,
    this.businessId,
    this.actionRoute,
  });

  final NotificationType type;
  final String title;
  final String body;
  final String? businessId;
  final String? actionRoute;
}
