import 'slug.dart';

/// Normalizes user input to a stable internal slug (API / DB / relations).
String normalizeInternalSlug(String input) => slugify(input);

/// Returns an error message, or null if valid.
String? validateInternalSlug(String input) {
  final slug = normalizeInternalSlug(input);
  if (slug.isEmpty || slug == 'item') {
    return 'Enter a valid internal slug (e.g. electronics, pizza-drinks)';
  }
  return null;
}
