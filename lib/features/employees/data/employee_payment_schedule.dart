/// Recurring monthly pay day + reminder window.
class EmployeePaymentSchedule {
  EmployeePaymentSchedule._();

  static DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  static DateTime dayInMonth(int year, int month, int paymentDay) {
    final last = DateTime(year, month + 1, 0).day;
    final day = paymentDay.clamp(1, last);
    return DateTime(year, month, day);
  }

  /// Next payment date on or after [from] (date-only).
  static DateTime nextPaymentOnOrAfter(int paymentDayOfMonth, {DateTime? from}) {
    final anchor = dateOnly(from ?? DateTime.now());
    var pay = dayInMonth(anchor.year, anchor.month, paymentDayOfMonth);
    if (pay.isBefore(anchor)) {
      final nextMonth = anchor.month == 12
          ? DateTime(anchor.year + 1, 1, 1)
          : DateTime(anchor.year, anchor.month + 1, 1);
      pay = dayInMonth(nextMonth.year, nextMonth.month, paymentDayOfMonth);
    }
    return pay;
  }

  static String monthKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  /// First calendar day when reminder should fire for the upcoming payment.
  static DateTime? reminderStartDay({
    required int paymentDayOfMonth,
    required int reminderDaysBefore,
    DateTime? from,
  }) {
    if (reminderDaysBefore <= 0) return null;
    final pay = nextPaymentOnOrAfter(paymentDayOfMonth, from: from);
    return pay.subtract(Duration(days: reminderDaysBefore));
  }

  static bool shouldSendReminder({
    required int paymentDayOfMonth,
    required int reminderDaysBefore,
    required String? reminderSentForMonth,
    DateTime? now,
  }) {
    if (reminderDaysBefore <= 0) return false;
    final clock = dateOnly(now ?? DateTime.now());
    final pay = nextPaymentOnOrAfter(paymentDayOfMonth, from: clock);
    final cycleKey = monthKey(pay);
    if (reminderSentForMonth == cycleKey) return false;

    final start = reminderStartDay(
      paymentDayOfMonth: paymentDayOfMonth,
      reminderDaysBefore: reminderDaysBefore,
      from: clock,
    );
    if (start == null) return false;
    final startDay = dateOnly(start);
    return !clock.isBefore(startDay) && !clock.isAfter(pay);
  }
}
