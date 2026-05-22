import 'package:flutter_test/flutter_test.dart';

import 'package:business_dashboard/features/business/domain/entities/business.dart';
import 'package:business_dashboard/features/business/domain/entities/site_config.dart';
import 'package:business_dashboard/features/business/domain/store_launch_readiness_logic.dart';

Business _business({
  String? slug,
  String? logoUrl,
  String? orderPhone,
  String? contactEmail,
  SiteConfig? siteConfig,
}) =>
    Business(
      id: 'b1',
      name: 'Shop',
      ownerId: 'u1',
      createdAt: DateTime(2024),
      slug: slug,
      logoUrl: logoUrl,
      orderPhone: orderPhone,
      contactEmail: contactEmail,
      siteConfig: siteConfig,
    );

void main() {
  group('StoreLaunchReadinessLogic', () {
    test('hasSlug requires non-empty slug', () {
      expect(StoreLaunchReadinessLogic.hasSlug(_business()), isFalse);
      expect(StoreLaunchReadinessLogic.hasSlug(_business(slug: 'napoletana')), isTrue);
    });

    test('hasContactInfo from phone, email, or contact section', () {
      expect(StoreLaunchReadinessLogic.hasContactInfo(_business()), isFalse);
      expect(
        StoreLaunchReadinessLogic.hasContactInfo(_business(orderPhone: '+38344111222')),
        isTrue,
      );
      expect(
        StoreLaunchReadinessLogic.hasContactInfo(
          _business(
            siteConfig: SiteConfig(
              sections: [
                const SiteSectionConfig(id: SiteConfig.sectionContact, enabled: true),
              ],
            ),
          ),
        ),
        isTrue,
      );
    });

    test('hasCatalog needs product or service', () {
      expect(
        StoreLaunchReadinessLogic.hasCatalog(activeProducts: 0, activeServices: 0),
        isFalse,
      );
      expect(
        StoreLaunchReadinessLogic.hasCatalog(activeProducts: 1, activeServices: 0),
        isTrue,
      );
    });
  });
}
