import 'entities/business_type.dart';
import 'entities/site_config.dart';
import 'site_cta_presets.dart';

extension SiteConfigMerge on SiteConfig {
  /// Default sections plus CTA labels/targets suited to [businessType].
  SiteConfig mergeForBusiness({required BusinessType? businessType}) {
    return SiteCtaPresets.applyTo(mergeWithDefaults(), businessType);
  }
}
