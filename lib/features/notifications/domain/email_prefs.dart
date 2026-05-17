/// User email notification preferences (stored on `users/{uid}.emailPrefs`).
class EmailPrefs {
  const EmailPrefs({
    this.accountAlerts = true,
    this.planUpdates = true,
    this.businessUpdates = true,
  });

  final bool accountAlerts;
  final bool planUpdates;
  final bool businessUpdates;

  static const defaults = EmailPrefs();

  factory EmailPrefs.fromMap(Map<String, dynamic>? map) {
    if (map == null) return defaults;
    return EmailPrefs(
      accountAlerts: map['accountAlerts'] as bool? ?? true,
      planUpdates: map['planUpdates'] as bool? ?? true,
      businessUpdates: map['businessUpdates'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'accountAlerts': accountAlerts,
        'planUpdates': planUpdates,
        'businessUpdates': businessUpdates,
      };

  EmailPrefs copyWith({
    bool? accountAlerts,
    bool? planUpdates,
    bool? businessUpdates,
  }) {
    return EmailPrefs(
      accountAlerts: accountAlerts ?? this.accountAlerts,
      planUpdates: planUpdates ?? this.planUpdates,
      businessUpdates: businessUpdates ?? this.businessUpdates,
    );
  }
}
