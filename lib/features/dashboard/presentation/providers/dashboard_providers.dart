import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/providers/products_providers.dart';

class DashboardStats {
  const DashboardStats({
    required this.totalProducts,
    required this.activeProducts,
    required this.totalCategories,
  });

  final int totalProducts;
  final int activeProducts;
  final int totalCategories;
}

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final products = ref.watch(productsListProvider).valueOrNull ?? [];
  final categories = ref.watch(categoriesListProvider).valueOrNull ?? [];
  final active = products.where((p) => p.status == ProductStatus.active).length;

  return DashboardStats(
    totalProducts: products.length,
    activeProducts: active,
    totalCategories: categories.length,
  );
});

/// Products grouped by category id (empty key = uncategorized).
final productsByCategoryProvider =
    Provider<Map<String, List<Product>>>((ref) {
  final products = ref.watch(productsListProvider).valueOrNull ?? [];
  final grouped = <String, List<Product>>{};

  for (final product in products) {
    if (product.categoryIds.isEmpty) {
      grouped.putIfAbsent('', () => []).add(product);
      continue;
    }
    for (final categoryId in product.categoryIds) {
      grouped.putIfAbsent(categoryId, () => []).add(product);
    }
  }

  return grouped;
});

/// Active products only — default for dashboard category grid.
final activeProductsByCategoryProvider =
    Provider<Map<String, List<Product>>>((ref) {
  final products = ref.watch(productsListProvider).valueOrNull ?? [];
  final active = products.where((p) => p.status == ProductStatus.active);
  final grouped = <String, List<Product>>{};

  for (final product in active) {
    if (product.categoryIds.isEmpty) {
      grouped.putIfAbsent('', () => []).add(product);
      continue;
    }
    for (final categoryId in product.categoryIds) {
      grouped.putIfAbsent(categoryId, () => []).add(product);
    }
  }

  return grouped;
});
