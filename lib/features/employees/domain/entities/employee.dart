import 'package:equatable/equatable.dart';

/// Payroll roster entry (not the same as login [TeamMember] staff).
class Employee extends Equatable {
  const Employee({
    required this.id,
    required this.businessId,
    required this.firstName,
    required this.lastName,
    this.email = '',
    this.phone = '',
    this.photoUrl = '',
    required this.salary,
    required this.paymentDayOfMonth,
    this.reminderDaysBefore = 1,
    this.reminderSentForMonth,
    this.active = true,
    this.showOnSite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String businessId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String photoUrl;
  final double salary;
  /// Day of month when salary is paid (1–28).
  final int paymentDayOfMonth;
  /// Days before payment day to send an in-app reminder; `0` = off.
  final int reminderDaysBefore;
  /// `YYYY-MM` of the payment cycle we already reminded for.
  final String? reminderSentForMonth;
  final bool active;
  /// When true (and [active]), shown on the public shop team section.
  final bool showOnSite;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName => '$firstName $lastName'.trim();

  bool get hasReminder => reminderDaysBefore > 0;

  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final hay = '${fullName.toLowerCase()} ${email.toLowerCase()} ${phone.toLowerCase()}';
    return hay.contains(query);
  }

  @override
  List<Object?> get props => [
        id,
        businessId,
        firstName,
        lastName,
        email,
        phone,
        photoUrl,
        salary,
        paymentDayOfMonth,
        reminderDaysBefore,
        reminderSentForMonth,
        active,
        showOnSite,
        createdAt,
        updatedAt,
      ];
}
