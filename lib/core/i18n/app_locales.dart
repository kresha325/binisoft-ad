/// Supported catalog / public API languages.
abstract final class AppLocales {
  static const sq = 'sq';
  static const en = 'en';
  static const de = 'de';

  static const defaultLocale = sq;

  static const all = <String>[sq, en, de];

  static const labels = <String, String>{
    sq: 'Shqip',
    en: 'English',
    de: 'Deutsch',
  };

  static String label(String code) => labels[code] ?? code.toUpperCase();

  static String? normalize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final code = raw.trim().toLowerCase().split(RegExp(r'[-_]')).first;
    return all.contains(code) ? code : null;
  }

  static List<String> normalizeList(Iterable<String>? raw) {
    if (raw == null) return List<String>.from(all);
    final out = <String>[];
    for (final item in raw) {
      final code = normalize(item);
      if (code != null && !out.contains(code)) out.add(code);
    }
    return out.isEmpty ? List<String>.from(all) : out;
  }
}
