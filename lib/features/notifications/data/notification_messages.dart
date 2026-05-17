import '../domain/notification_type.dart';
import 'models/notification_model.dart';

class NotificationMessages {
  NotificationMessages._();

  static CreateNotificationInput welcome() => const CreateNotificationInput(
        type: NotificationType.welcome,
        title: 'Welcome to Binisoft Admin',
        body: 'Your account is ready. Create your first business to start managing your catalog.',
        actionRoute: '/businesses',
      );

  static CreateNotificationInput businessCreated({
    required String businessName,
    required String businessId,
  }) =>
      CreateNotificationInput(
        type: NotificationType.businessCreated,
        title: 'Business created',
        body: '"$businessName" is ready. You can add products and categories.',
        businessId: businessId,
        actionRoute: '/dashboard',
      );

  static CreateNotificationInput planUpdated({
    required String planLabel,
  }) =>
      CreateNotificationInput(
        type: NotificationType.planUpdated,
        title: 'Plan updated',
        body: 'Your subscription is now on the $planLabel plan.',
        actionRoute: '/settings',
      );

  static CreateNotificationInput platformUserRegistered({
    required String email,
  }) =>
      CreateNotificationInput(
        type: NotificationType.platformUserRegistered,
        title: 'New user registered',
        body: '$email created an admin account.',
        actionRoute: '/superadmin',
      );

  static CreateNotificationInput platformBusinessCreated({
    required String businessName,
    required String businessId,
  }) =>
      CreateNotificationInput(
        type: NotificationType.platformBusinessCreated,
        title: 'New business',
        body: '"$businessName" was created on the platform.',
        businessId: businessId,
        actionRoute: '/superadmin',
      );

  static CreateNotificationInput businessSwitched({
    required String businessName,
    required String businessId,
  }) =>
      CreateNotificationInput(
        type: NotificationType.businessSwitched,
        title: 'Active business changed',
        body: 'You are now managing "$businessName".',
        businessId: businessId,
        actionRoute: '/dashboard',
      );
}
