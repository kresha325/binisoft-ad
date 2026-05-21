import 'package:equatable/equatable.dart';

enum ContestLifecycleStatus {
  live,
  scheduled,
  expired,
  inactive,
}

class Contest extends Equatable {
  const Contest({
    required this.id,
    required this.businessId,
    required this.title,
    required this.slug,
    this.titleI18n = const {},
    this.description,
    this.descriptionI18n = const {},
    this.prize,
    this.prizeI18n = const {},
    this.rules,
    this.rulesI18n = const {},
    this.imageUrl,
    required this.durationDays,
    required this.startsAt,
    required this.endsAt,
    this.active = true,
    this.entryCount = 0,
  });

  final String id;
  final String businessId;
  final String title;
  final String slug;
  final Map<String, String> titleI18n;
  final String? description;
  final Map<String, String> descriptionI18n;
  final String? prize;
  final Map<String, String> prizeI18n;
  final String? rules;
  final Map<String, String> rulesI18n;
  final String? imageUrl;
  final int durationDays;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool active;
  final int entryCount;

  bool get isCurrentlyActive => lifecycleStatus == ContestLifecycleStatus.live;

  ContestLifecycleStatus get lifecycleStatus {
    if (!active) return ContestLifecycleStatus.inactive;
    final now = DateTime.now();
    if (now.isAfter(endsAt)) return ContestLifecycleStatus.expired;
    if (now.isBefore(startsAt)) return ContestLifecycleStatus.scheduled;
    return ContestLifecycleStatus.live;
  }

  bool get isExpired => lifecycleStatus == ContestLifecycleStatus.expired;

  @override
  List<Object?> get props => [
        id,
        businessId,
        title,
        slug,
        titleI18n,
        description,
        descriptionI18n,
        prize,
        prizeI18n,
        rules,
        rulesI18n,
        imageUrl,
        durationDays,
        startsAt,
        endsAt,
        active,
        entryCount,
      ];
}
