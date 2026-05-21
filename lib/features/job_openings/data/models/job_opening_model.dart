import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/employment_type.dart';
import '../../domain/entities/job_opening.dart';

String? _optionalLocalized(
  Map<String, dynamic> data,
  String primaryKey,
  String i18nKey,
  String locale,
) {
  final i18n = LocalizedText.parseMap(data[i18nKey]);
  final resolved = LocalizedText.resolve(
    primary: data[primaryKey],
    i18n: i18n,
    locale: locale,
    defaultLocale: locale,
  );
  return resolved.isEmpty ? null : resolved;
}

class JobOpeningModel {
  JobOpeningModel({
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

  factory JobOpeningModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String displayLocale = 'sq',
  }) {
    final data = doc.data() ?? {};
    return JobOpeningModel(
      id: doc.id,
      businessId: data['businessId'] as String? ?? '',
      title: LocalizedText.resolve(
        primary: data['title'] as String?,
        i18n: LocalizedText.parseMap(data['titleI18n']),
        locale: displayLocale,
      ),
      slug: (data['slug'] as String?)?.trim().isNotEmpty == true
          ? data['slug'] as String
          : doc.id,
      titleI18n: LocalizedText.parseMap(data['titleI18n']),
      description:
          _optionalLocalized(data, 'description', 'descriptionI18n', displayLocale),
      descriptionI18n: LocalizedText.parseMap(data['descriptionI18n']),
      requirements: _optionalLocalized(
        data,
        'requirements',
        'requirementsI18n',
        displayLocale,
      ),
      requirementsI18n: LocalizedText.parseMap(data['requirementsI18n']),
      location: (data['location'] as String?)?.trim(),
      employmentType:
          EmploymentType.fromStorage(data['employmentType'] as String?),
      salaryHint: (data['salaryHint'] as String?)?.trim(),
      applyEmail: (data['applyEmail'] as String?)?.trim(),
      applyUrl: (data['applyUrl'] as String?)?.trim(),
      imageUrl: (data['imageUrl'] as String?)?.trim(),
      durationDays: (data['durationDays'] as num?)?.toInt() ?? 30,
      startsAt: (data['startsAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endsAt: (data['endsAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      active: data['active'] as bool? ?? true,
      applicationCount: (data['applicationCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessId': businessId,
      'title': title,
      'slug': slug,
      if (titleI18n.isNotEmpty) 'titleI18n': titleI18n,
      if (description != null) 'description': description,
      if (descriptionI18n.isNotEmpty) 'descriptionI18n': descriptionI18n,
      if (requirements != null) 'requirements': requirements,
      if (requirementsI18n.isNotEmpty) 'requirementsI18n': requirementsI18n,
      if (location != null && location!.isNotEmpty) 'location': location,
      if (employmentType != null) 'employmentType': employmentType!.storageValue,
      if (salaryHint != null && salaryHint!.isNotEmpty) 'salaryHint': salaryHint,
      if (applyEmail != null && applyEmail!.isNotEmpty) 'applyEmail': applyEmail,
      if (applyUrl != null && applyUrl!.isNotEmpty) 'applyUrl': applyUrl,
      if (imageUrl != null && imageUrl!.isNotEmpty) 'imageUrl': imageUrl,
      'durationDays': durationDays,
      'startsAt': Timestamp.fromDate(startsAt),
      'endsAt': Timestamp.fromDate(endsAt),
      'active': active,
      'applicationCount': applicationCount,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  JobOpening toEntity() => JobOpening(
        id: id,
        businessId: businessId,
        title: title,
        slug: slug,
        titleI18n: titleI18n,
        description: description,
        descriptionI18n: descriptionI18n,
        requirements: requirements,
        requirementsI18n: requirementsI18n,
        location: location,
        employmentType: employmentType,
        salaryHint: salaryHint,
        applyEmail: applyEmail,
        applyUrl: applyUrl,
        imageUrl: imageUrl,
        durationDays: durationDays,
        startsAt: startsAt,
        endsAt: endsAt,
        active: active,
        applicationCount: applicationCount,
      );
}
