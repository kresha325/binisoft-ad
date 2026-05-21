import 'package:equatable/equatable.dart';

import 'employment_type.dart';

enum JobOpeningLifecycleStatus {
  live,
  scheduled,
  expired,
  inactive,
}

class JobOpening extends Equatable {
  const JobOpening({
    required this.id,
    required this.businessId,
    required this.title,
    required this.slug,
    this.titleI18n = const {},
    this.description,
    this.descriptionI18n = const {},
    this.requirements,
    this.requirementsI18n = const {},
    this.location,
    this.employmentType,
    this.salaryHint,
    this.applyEmail,
    this.applyUrl,
    this.imageUrl,
    required this.durationDays,
    required this.startsAt,
    required this.endsAt,
    this.active = true,
    this.applicationCount = 0,
  });

  final String id;
  final String businessId;
  final String title;
  final String slug;
  final Map<String, String> titleI18n;
  final String? description;
  final Map<String, String> descriptionI18n;
  final String? requirements;
  final Map<String, String> requirementsI18n;
  final String? location;
  final EmploymentType? employmentType;
  final String? salaryHint;
  final String? applyEmail;
  final String? applyUrl;
  final String? imageUrl;
  final int durationDays;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool active;
  final int applicationCount;

  JobOpeningLifecycleStatus get lifecycleStatus {
    if (!active) return JobOpeningLifecycleStatus.inactive;
    final now = DateTime.now();
    if (now.isAfter(endsAt)) return JobOpeningLifecycleStatus.expired;
    if (now.isBefore(startsAt)) return JobOpeningLifecycleStatus.scheduled;
    return JobOpeningLifecycleStatus.live;
  }

  bool get isExpired => lifecycleStatus == JobOpeningLifecycleStatus.expired;

  @override
  List<Object?> get props => [
        id,
        businessId,
        title,
        slug,
        titleI18n,
        description,
        descriptionI18n,
        requirements,
        requirementsI18n,
        location,
        employmentType,
        salaryHint,
        applyEmail,
        applyUrl,
        imageUrl,
        durationDays,
        startsAt,
        endsAt,
        active,
        applicationCount,
      ];
}
