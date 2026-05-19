// Google Maps link handling for admin (URL only) and public shop embed.

final _iframeSrcPattern = RegExp(
  r'<iframe[^>]+src\s*=\s*"([^"]+)"',
  caseSensitive: false,
);
final _iframeSrcPatternSingle = RegExp(
  r"<iframe[^>]+src\s*=\s*'([^']+)'",
  caseSensitive: false,
);

final _httpUrlPattern = RegExp(r'https?://[^\s"<>]+');
final _urlTerminatorPattern = RegExp(r'[\s"<>]');

/// Extracts an HTTPS maps URL from plain link or legacy iframe paste.
String? extractGoogleMapsUrl(String? input) {
  final raw = input?.trim() ?? '';
  if (raw.isEmpty) return null;

  final iframe =
      _iframeSrcPattern.firstMatch(raw) ?? _iframeSrcPatternSingle.firstMatch(raw);
  if (iframe != null) {
    return iframe.group(1)?.trim();
  }

  if (RegExp(r'<\s*iframe', caseSensitive: false).hasMatch(raw) ||
      raw.contains('</iframe>')) {
    return null;
  }

  if (raw.startsWith('http://') || raw.startsWith('https://')) {
    final end = raw.indexOf(_urlTerminatorPattern);
    return (end > 0 ? raw.substring(0, end) : raw).trim();
  }

  final http = _httpUrlPattern.firstMatch(raw);
  return http?.group(0)?.trim();
}

/// Value to store in Firestore — URL only, never iframe HTML.
String? normalizeGoogleMapsUrl(String? input) {
  final url = extractGoogleMapsUrl(input);
  if (url == null || url.isEmpty) return null;
  if (!isLikelyGoogleMapsUrl(url)) return null;
  return url;
}

bool isLikelyGoogleMapsUrl(String value) {
  final v = value.trim().toLowerCase();
  if (v.isEmpty) return true;
  if (v.contains('<iframe') || v.contains('</iframe>') || v.startsWith('<')) {
    return false;
  }
  return (v.contains('google.') && v.contains('map')) ||
      v.contains('goo.gl/maps') ||
      v.contains('maps.app.goo.gl');
}

/// Normalizes a Google Maps share or embed URL for iframe [src] on the public shop.
String? googleMapsEmbedUrl(String? input) {
  final raw = extractGoogleMapsUrl(input);
  if (raw == null || raw.isEmpty) return null;
  if (raw.contains('/maps/embed')) return raw;

  final atCoords = RegExp(r'@(-?\d+\.?\d*),(-?\d+\.?\d*)').firstMatch(raw);
  if (atCoords != null) {
    final lat = atCoords.group(1);
    final lng = atCoords.group(2);
    return 'https://www.google.com/maps?q=$lat,$lng&z=15&output=embed';
  }

  final qParam = RegExp(r'[?&]q=([^&]+)').firstMatch(raw);
  if (qParam != null) {
    final q = Uri.decodeComponent(qParam.group(1)!);
    return 'https://www.google.com/maps?q=${Uri.encodeComponent(q)}&output=embed';
  }

  if (raw.startsWith('http')) {
    return 'https://www.google.com/maps?q=${Uri.encodeComponent(raw)}&output=embed';
  }

  return 'https://www.google.com/maps?q=${Uri.encodeComponent(raw)}&output=embed';
}
