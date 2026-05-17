/// Known notification categories for filtering and icons.
enum NotificationType {
  welcome('welcome'),
  businessCreated('business.created'),
  businessSwitched('business.switched'),
  planUpdated('plan.updated'),
  system('system'),
  platformUserRegistered('platform.user.registered'),
  platformBusinessCreated('platform.business.created');

  const NotificationType(this.value);
  final String value;

  static NotificationType fromString(String? raw) {
    return NotificationType.values.firstWhere(
      (t) => t.value == raw,
      orElse: () => NotificationType.system,
    );
  }
}
