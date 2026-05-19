/// City + state/country shown on the public shop; [location] kept in sync for API.
abstract final class BusinessAddress {
  BusinessAddress._();

  static String displayLocation({
    String? city,
    String? state,
    String? legacyLocation,
  }) {
    final c = city?.trim() ?? '';
    final s = state?.trim() ?? '';
    if (c.isNotEmpty && s.isNotEmpty) return '$c, $s';
    if (c.isNotEmpty) return c;
    if (s.isNotEmpty) return s;
    return legacyLocation?.trim() ?? '';
  }

  static ({String city, String state}) fromLegacyLocation(String? location) {
    final raw = location?.trim() ?? '';
    if (raw.isEmpty) return (city: '', state: '');
    final parts = raw.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return (city: parts.first, state: parts.sublist(1).join(', '));
    }
    return (city: raw, state: '');
  }
}
