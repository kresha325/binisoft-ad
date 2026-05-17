import 'report_period.dart';

/// Computes calendar period bounds and stable keys for billing reports.
abstract final class ReportPeriodCalculator {
  static String periodKey(ReportPeriod period, DateTime anchor) {
    switch (period) {
      case ReportPeriod.daily:
        return _dateKey(anchor);
      case ReportPeriod.weekly:
        return _isoWeekKey(anchor);
      case ReportPeriod.monthly:
        return '${anchor.year}-${anchor.month.toString().padLeft(2, '0')}';
      case ReportPeriod.yearly:
        return '${anchor.year}';
    }
  }

  static ({DateTime start, DateTime end}) bounds(ReportPeriod period, DateTime anchor) {
    switch (period) {
      case ReportPeriod.daily:
        final start = DateTime(anchor.year, anchor.month, anchor.day);
        final end = DateTime(anchor.year, anchor.month, anchor.day, 23, 59, 59, 999);
        return (start: start, end: end);
      case ReportPeriod.weekly:
        final weekday = anchor.weekday;
        final monday = anchor.subtract(Duration(days: weekday - 1));
        final start = DateTime(monday.year, monday.month, monday.day);
        final sunday = start.add(const Duration(days: 6));
        final end = DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59, 999);
        return (start: start, end: end);
      case ReportPeriod.monthly:
        final start = DateTime(anchor.year, anchor.month, 1);
        final lastDay = DateTime(anchor.year, anchor.month + 1, 0).day;
        final end = DateTime(anchor.year, anchor.month, lastDay, 23, 59, 59, 999);
        return (start: start, end: end);
      case ReportPeriod.yearly:
        final start = DateTime(anchor.year, 1, 1);
        final end = DateTime(anchor.year, 12, 31, 23, 59, 59, 999);
        return (start: start, end: end);
    }
  }

  /// Previous completed period anchor (for scheduled jobs).
  static DateTime previousPeriodAnchor(ReportPeriod period, DateTime now) {
    switch (period) {
      case ReportPeriod.daily:
        final y = now.subtract(const Duration(days: 1));
        return DateTime(y.year, y.month, y.day);
      case ReportPeriod.weekly:
        return now.subtract(const Duration(days: 7));
      case ReportPeriod.monthly:
        final prev = DateTime(now.year, now.month - 1, 1);
        return prev;
      case ReportPeriod.yearly:
        return DateTime(now.year - 1, 6, 1);
    }
  }

  static String docId(ReportPeriod period, String periodKey) => '${period.value}_$periodKey';

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _isoWeekKey(DateTime d) {
    final thursday = d.add(Duration(days: 4 - (d.weekday)));
    final yearStart = DateTime(thursday.year, 1, 1);
    final week = ((thursday.difference(yearStart).inDays + 1) / 7).ceil();
    return '${thursday.year}-W${week.toString().padLeft(2, '0')}';
  }
}
