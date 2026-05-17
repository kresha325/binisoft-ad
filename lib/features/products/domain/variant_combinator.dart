/// Generates variant combinations from attribute axes (e.g. Color × Size).
List<Map<String, String>> generateVariantCombinations(
  Map<String, List<String>> axes,
) {
  if (axes.isEmpty) return [{}];

  final keys = axes.keys.toList();
  final values = axes.values.toList();

  List<Map<String, String>> result = [{}];

  for (var i = 0; i < keys.length; i++) {
    final key = keys[i];
    final options = values[i];
    final next = <Map<String, String>>[];
    for (final combo in result) {
      for (final option in options) {
        next.add({...combo, key: option});
      }
    }
    result = next;
  }

  return result;
}

String buildSku(String productSlug, Map<String, String> attributes) {
  final parts = attributes.values.map((v) => v.toUpperCase().replaceAll(' ', ''));
  return '$productSlug-${parts.join('-')}';
}
