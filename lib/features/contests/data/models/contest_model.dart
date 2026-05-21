import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/i18n/localized_text.dart';
import '../../domain/entities/contest.dart';

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

class ContestModel {
  ContestModel({
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

  factory ContestModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    String displayLocale = 'sq',
  }) {
    final data = doc.data() ?? {};
    return ContestModel(
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
      prize: _optionalLocalized(data, 'prize', 'prizeI18n', displayLocale),
      prizeI18n: LocalizedText.parseMap(data['prizeI18n']),
      rules: _optionalLocalized(data, 'rules', 'rulesI18n', displayLocale),
      rulesI18n: LocalizedText.parseMap(data['rulesI18n']),
      imageUrl: (data['imageUrl'] as String?)?.trim(),
      durationDays: (data['durationDays'] as num?)?.toInt() ?? 14,
      startsAt: (data['startsAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endsAt: (data['endsAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      active: data['active'] as bool? ?? true,
      entryCount: (data['entryCount'] as num?)?.toInt() ?? 0,
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
      if (prize != null) 'prize': prize,
      if (prizeI18n.isNotEmpty) 'prizeI18n': prizeI18n,
      if (rules != null) 'rules': rules,
      if (rulesI18n.isNotEmpty) 'rulesI18n': rulesI18n,
      if (imageUrl != null && imageUrl!.isNotEmpty) 'imageUrl': imageUrl,
      'durationDays': durationDays,
      'startsAt': Timestamp.fromDate(startsAt),
      'endsAt': Timestamp.fromDate(endsAt),
      'active': active,
      'entryCount': entryCount,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Contest toEntity() => Contest(
        id: id,
        businessId: businessId,
        title: title,
        slug: slug,
        titleI18n: titleI18n,
        description: description,
        descriptionI18n: descriptionI18n,
        prize: prize,
        prizeI18n: prizeI18n,
        rules: rules,
        rulesI18n: rulesI18n,
        imageUrl: imageUrl,
        durationDays: durationDays,
        startsAt: startsAt,
        endsAt: endsAt,
        active: active,
        entryCount: entryCount,
      );
}
