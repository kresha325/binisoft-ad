import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../../../services/presentation/providers/services_providers.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/site_config.dart';
import '../providers/business_providers.dart';

enum StoreLaunchTaskId { slug, logo, catalog, contact, preview }

class StoreLaunchTask {
  const StoreLaunchTask({
    required this.id,
    required this.done,
    this.route,
  });

  final StoreLaunchTaskId id;
  final bool done;
  final String? route;
}

class StoreLaunchReadiness {
  const StoreLaunchReadiness({
    required this.tasks,
    required this.completedCount,
    required this.totalCount,
    required this.storeSlug,
  });

  final List<StoreLaunchTask> tasks;
  final int completedCount;
  final int totalCount;
  final String? storeSlug;

  bool get isComplete => completedCount >= totalCount && totalCount > 0;

  double get progress =>
      totalCount == 0 ? 0 : completedCount / totalCount;
}

final storeLaunchReadinessProvider = Provider<StoreLaunchReadiness?>((ref) {
  final business = ref.watch(currentBusinessProvider).valueOrNull;
  if (business == null) return null;

  final products = ref.watch(productsListProvider).valueOrNull ?? [];
  final services = ref.watch(servicesListProvider).valueOrNull ?? [];

  final slug = (business.slug ?? '').trim();
  final slugOk = slug.isNotEmpty;
  final logoOk = (business.logoUrl ?? '').trim().isNotEmpty;
  final activeProducts =
      products.where((p) => p.status == ProductStatus.active).length;
  final activeServices = services.where((s) => s.active).length;
  final catalogOk = activeProducts > 0 || activeServices > 0;
  final contactOk = _hasContactInfo(business);

  final catalogRoute = activeProducts == 0 ? '/products' : '/services';

  final tasks = [
    StoreLaunchTask(
      id: StoreLaunchTaskId.slug,
      done: slugOk,
      route: '/settings',
    ),
    StoreLaunchTask(
      id: StoreLaunchTaskId.logo,
      done: logoOk,
      route: '/settings',
    ),
    StoreLaunchTask(
      id: StoreLaunchTaskId.catalog,
      done: catalogOk,
      route: catalogRoute,
    ),
    StoreLaunchTask(
      id: StoreLaunchTaskId.contact,
      done: contactOk,
      route: '/settings',
    ),
    StoreLaunchTask(
      id: StoreLaunchTaskId.preview,
      done: slugOk,
    ),
  ];

  final done = tasks.where((t) => t.done).length;
  return StoreLaunchReadiness(
    tasks: tasks,
    completedCount: done,
    totalCount: tasks.length,
    storeSlug: slugOk ? slug : null,
  );
});

bool _hasContactInfo(Business business) {
  if ((business.orderPhone ?? '').trim().isNotEmpty) return true;
  if ((business.contactEmail ?? '').trim().isNotEmpty) return true;
  for (final s in business.siteConfig?.sections ?? const []) {
    if (s.id == SiteConfig.sectionContact && s.enabled) return true;
  }
  return false;
}
