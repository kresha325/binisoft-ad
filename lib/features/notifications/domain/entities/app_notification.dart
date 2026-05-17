import 'package:equatable/equatable.dart';

import '../notification_type.dart';

class AppNotification extends Equatable {
  const AppNotification({
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
  final NotificationType type;
  final String title;
  final String body;
  final bool read;
  final DateTime createdAt;
  final String? businessId;
  final String? actionRoute;

  @override
  List<Object?> get props =>
      [id, type, title, body, read, createdAt, businessId, actionRoute];
}
