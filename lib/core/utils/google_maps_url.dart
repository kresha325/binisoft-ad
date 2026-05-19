/// Normalizes a Google Maps share link for iframe embed on the public shop.
String? googleMapsEmbedUrl(String? input) {
  final raw = input?.trim() ?? '';
  if (raw.isEmpty) return null;
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

bool isLikelyGoogleMapsUrl(String value) {
  final v = value.trim().toLowerCase();
  if (v.isEmpty) return true;
  return v.contains('google.') && v.contains('map') ||
      v.contains('goo.gl/maps') ||
      v.contains('maps.app.goo.gl');
}
