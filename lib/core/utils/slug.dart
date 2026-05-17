String slugify(String input) {
  var slug = input.toLowerCase().trim();
  slug = slug.replaceAll(RegExp(r'[^\w\s-]'), '');
  slug = slug.replaceAll(RegExp(r'[\s_-]+'), '-');
  slug = slug.replaceAll(RegExp(r'^-+|-+$'), '');
  return slug.isEmpty ? 'item' : slug;
}
