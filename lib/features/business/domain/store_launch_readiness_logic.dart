import 'entities/business.dart';
import 'entities/site_config.dart';

/// Pure rules for the store launch checklist (unit-testable).
class StoreLaunchReadinessLogic {
  StoreLaunchReadinessLogic._();

  static bool hasSlug(Business business) => (business.slug ?? '').trim().isNotEmpty;

  static bool hasLogo(Business business) => (business.logoUrl ?? '').trim().isNotEmpty;

  static bool hasContactInfo(Business business) {
    if ((business.orderPhone ?? '').trim().isNotEmpty) return true;
    if ((business.contactEmail ?? '').trim().isNotEmpty) return true;
    for (final s in business.siteConfig?.sections ?? const []) {
      if (s.id == SiteConfig.sectionContact && s.enabled) return true;
    }
    return false;
  }

  static bool hasCatalog({required int activeProducts, required int activeServices}) =>
      activeProducts > 0 || activeServices > 0;
}
