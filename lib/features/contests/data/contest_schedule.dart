import '../domain/entities/contest.dart';

/// Contest visibility window on create/update (renew when expired or re-activated).
class ContestSchedule {
  ContestSchedule._();

  static const minDays = 1;
  static const maxDays = 90;

  static int clampDays(int days) => days.clamp(minDays, maxDays);

  static ({DateTime startsAt, DateTime endsAt}) windowForSave({
    required int durationDays,
    required bool active,
    Contest? existing,
  }) {
    final days = clampDays(durationDays);
    final now = DateTime.now();

    if (existing == null) {
      return (startsAt: now, endsAt: now.add(Duration(days: days)));
    }

    final wasExpired = existing.endsAt.isBefore(now);
    final reactivated = active && !existing.active;
    if (wasExpired || reactivated) {
      return (startsAt: now, endsAt: now.add(Duration(days: days)));
    }

    return (
      startsAt: existing.startsAt,
      endsAt: existing.startsAt.add(Duration(days: days)),
    );
  }
}
