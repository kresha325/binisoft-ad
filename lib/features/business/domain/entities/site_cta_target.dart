/// Where a storefront CTA button scrolls or navigates.
enum SiteCtaTarget {
  products,
  services,
  contact,
  offers,
  whatsapp;

  String get value => name;

  static SiteCtaTarget? fromValue(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final t in SiteCtaTarget.values) {
      if (t.value == raw) return t;
    }
    return null;
  }
}
