import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../domain/entities/attribute_definition.dart';

final attributesListProvider =
    StreamProvider.autoDispose<List<AttributeDefinition>>((ref) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  final locale = ref.watch(businessLocalesProvider).defaultLocale;
  return ref
      .watch(attributeRepositoryProvider)
      .watchList(businessId: businessId, displayLocale: locale);
});
