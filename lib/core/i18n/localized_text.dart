import 'app_locales.dart';

/// Read / write multilingual strings stored as `name` + optional `nameI18n` map.
abstract final class LocalizedText {
  static Map<String, String> parseMap(dynamic raw) {
    if (raw is! Map) return {};
    final out = <String, String>{};
    for (final entry in raw.entries) {
      final code = AppLocales.normalize(entry.key.toString());
      if (code == null) continue;
      final value = entry.value?.toString().trim() ?? '';
      if (value.isNotEmpty) out[code] = value;
    }
    return out;
  }

  static String readPrimary(dynamic raw) {
    if (raw is String) return raw.trim();
    if (raw is Map) {
      final first = raw.values
          .map((v) => v?.toString().trim() ?? '')
          .firstWhere((v) => v.isNotEmpty, orElse: () => '');
      return first;
    }
    return '';
  }

  static String resolve({
    required dynamic primary,
    Map<String, String>? i18n,
    required String locale,
    String defaultLocale = AppLocales.defaultLocale,
  }) {
    final map = i18n ?? {};
    final localized = map[locale]?.trim();
    if (localized != null && localized.isNotEmpty) return localized;

    final primaryText = readPrimary(primary);
    if (primaryText.isNotEmpty) return primaryText;

    final fallback = map[defaultLocale]?.trim();
    if (fallback != null && fallback.isNotEmpty) return fallback;

    for (final code in AppLocales.all) {
      final v = map[code]?.trim();
      if (v != null && v.isNotEmpty) return v;
    }
    return '';
  }

  static ({String primary, Map<String, String> i18n}) pack({
    required String defaultLocale,
    required Map<String, String> values,
  }) {
    final i18n = <String, String>{};
    for (final code in AppLocales.all) {
      final v = values[code]?.trim();
      if (v != null && v.isNotEmpty) i18n[code] = v;
    }

    var primary = i18n[defaultLocale]?.trim() ?? '';
    if (primary.isEmpty && i18n.isNotEmpty) {
      primary = i18n.values.first;
    }
    if (primary.isNotEmpty && !i18n.containsKey(defaultLocale)) {
      i18n[defaultLocale] = primary;
    }

    return (primary: primary, i18n: i18n);
  }

  static Map<String, String> initialValues({
    required String defaultLocale,
    required List<String> enabledLocales,
    Map<String, String>? i18n,
    String? primary,
  }) {
    final out = <String, String>{};
    final map = i18n ?? {};
    for (final code in enabledLocales) {
      out[code] = map[code] ?? '';
    }
    if (out[defaultLocale]?.isEmpty ?? true) {
      final p = primary ?? readPrimary(map);
      if (p.isNotEmpty) out[defaultLocale] = p;
    }
    return out;
  }

  /// Keeps only [enabledLocales] with non-empty values.
  static Map<String, String> filterToLocales(
    Map<String, String> values,
    List<String> enabledLocales,
  ) {
    final allowed = enabledLocales.toSet();
    final out = <String, String>{};
    for (final entry in values.entries) {
      if (!allowed.contains(entry.key)) continue;
      final v = entry.value.trim();
      if (v.isNotEmpty) out[entry.key] = v;
    }
    return out;
  }

  static ({String primary, Map<String, String> i18n}) packForSave({
    required String defaultLocale,
    required List<String> enabledLocales,
    required Map<String, String> values,
  }) {
    final filtered = filterToLocales(values, enabledLocales);
    return pack(defaultLocale: defaultLocale, values: filtered);
  }
}
