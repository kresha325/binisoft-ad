import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/i18n/app_locales.dart';
import 'business_providers.dart';

class BusinessLocalesConfig {
  const BusinessLocalesConfig({
    required this.defaultLocale,
    required this.enabledLocales,
  });

  final String defaultLocale;
  final List<String> enabledLocales;
}

final businessLocalesProvider = Provider<BusinessLocalesConfig>((ref) {
  final business = ref.watch(currentBusinessProvider).valueOrNull;
  if (business == null) {
    return const BusinessLocalesConfig(
      defaultLocale: AppLocales.defaultLocale,
      enabledLocales: AppLocales.all,
    );
  }
  return BusinessLocalesConfig(
    defaultLocale: business.defaultLocale,
    enabledLocales: business.locales,
  );
});
