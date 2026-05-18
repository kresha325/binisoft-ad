import 'localized_text.dart';

/// Multilingual catalog copy (name, description, SEO) per locale tab.
class CatalogLocalizedContent {
  const CatalogLocalizedContent({
    required this.name,
    required this.description,
    required this.seoTitle,
    required this.seoDescription,
  });

  final Map<String, String> name;
  final Map<String, String> description;
  final Map<String, String> seoTitle;
  final Map<String, String> seoDescription;

  factory CatalogLocalizedContent.initial({
    required String defaultLocale,
    required List<String> enabledLocales,
    Map<String, String>? nameI18n,
    Map<String, String>? descriptionI18n,
    Map<String, String>? seoTitleI18n,
    Map<String, String>? seoDescriptionI18n,
    String? primaryName,
    String? primaryDescription,
    String? primarySeoTitle,
    String? primarySeoDescription,
  }) {
    return CatalogLocalizedContent(
      name: LocalizedText.initialValues(
        defaultLocale: defaultLocale,
        enabledLocales: enabledLocales,
        i18n: nameI18n,
        primary: primaryName,
      ),
      description: LocalizedText.initialValues(
        defaultLocale: defaultLocale,
        enabledLocales: enabledLocales,
        i18n: descriptionI18n,
        primary: primaryDescription,
      ),
      seoTitle: LocalizedText.initialValues(
        defaultLocale: defaultLocale,
        enabledLocales: enabledLocales,
        i18n: seoTitleI18n,
        primary: primarySeoTitle,
      ),
      seoDescription: LocalizedText.initialValues(
        defaultLocale: defaultLocale,
        enabledLocales: enabledLocales,
        i18n: seoDescriptionI18n,
        primary: primarySeoDescription,
      ),
    );
  }

  CatalogLocalizedContent copyWith({
    Map<String, String>? name,
    Map<String, String>? description,
    Map<String, String>? seoTitle,
    Map<String, String>? seoDescription,
  }) {
    return CatalogLocalizedContent(
      name: name ?? this.name,
      description: description ?? this.description,
      seoTitle: seoTitle ?? this.seoTitle,
      seoDescription: seoDescription ?? this.seoDescription,
    );
  }

  CatalogLocalizedPack packForSave({
    required String defaultLocale,
    required List<String> enabledLocales,
  }) {
    return CatalogLocalizedPack(
      name: LocalizedText.packForSave(
        defaultLocale: defaultLocale,
        enabledLocales: enabledLocales,
        values: name,
      ),
      description: LocalizedText.packForSave(
        defaultLocale: defaultLocale,
        enabledLocales: enabledLocales,
        values: description,
      ),
      seoTitle: LocalizedText.packForSave(
        defaultLocale: defaultLocale,
        enabledLocales: enabledLocales,
        values: seoTitle,
      ),
      seoDescription: LocalizedText.packForSave(
        defaultLocale: defaultLocale,
        enabledLocales: enabledLocales,
        values: seoDescription,
      ),
    );
  }
}

class CatalogLocalizedPack {
  const CatalogLocalizedPack({
    required this.name,
    required this.description,
    required this.seoTitle,
    required this.seoDescription,
  });

  final ({String primary, Map<String, String> i18n}) name;
  final ({String primary, Map<String, String> i18n}) description;
  final ({String primary, Map<String, String> i18n}) seoTitle;
  final ({String primary, Map<String, String> i18n}) seoDescription;
}
