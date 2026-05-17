import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/order.dart';
import '../../data/models/api_key_model.dart';

final ordersListProvider = StreamProvider.autoDispose<List<BusinessOrder>>((ref) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  return ref.watch(orderRepositoryProvider).watchOrders(businessId: businessId);
});

final businessApiKeysProvider =
    StreamProvider.autoDispose<List<BusinessApiKeyRecord>>((ref) {
  final businessId = ref.watch(currentBusinessIdProvider);
  if (businessId == null) return Stream.value([]);
  return ref.watch(apiKeyRepositoryProvider).watchKeys(businessId: businessId);
});

class OrderDashboardStats {
  const OrderDashboardStats({
    required this.todayCount,
    required this.newCount,
    required this.weekRevenueEur,
  });

  final int todayCount;
  final int newCount;
  final double weekRevenueEur;
}

class ProductSalesStat {
  const ProductSalesStat({
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.revenueEur,
    required this.orderCount,
  });

  final String productId;
  final String productName;
  final int quantitySold;
  final double revenueEur;
  final int orderCount;
}

/// Aggregated line items from non-cancelled orders (for dashboard analytics).
final productSalesStatsProvider = Provider<List<ProductSalesStat>>((ref) {
  final orders = ref.watch(ordersListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  final weekStart = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: now.weekday - 1));

  final byKey = <String, ProductSalesStat>{};
  final orderIdsPerProduct = <String, Set<String>>{};

  for (final order in orders) {
    if (!order.status.countsTowardRevenue) continue;
    if (order.createdAt.isBefore(weekStart)) continue;

    for (final line in order.lines) {
      final key = line.productId.isNotEmpty ? line.productId : line.productName;
      orderIdsPerProduct.putIfAbsent(key, () => {}).add(order.id);

      final existing = byKey[key];
      if (existing == null) {
        byKey[key] = ProductSalesStat(
          productId: line.productId,
          productName: line.productName,
          quantitySold: line.quantity,
          revenueEur: line.lineTotalEur,
          orderCount: 1,
        );
      } else {
        byKey[key] = ProductSalesStat(
          productId: existing.productId,
          productName: existing.productName,
          quantitySold: existing.quantitySold + line.quantity,
          revenueEur: existing.revenueEur + line.lineTotalEur,
          orderCount: orderIdsPerProduct[key]!.length,
        );
      }
    }
  }

  for (final entry in byKey.entries.toList()) {
    final key = entry.key;
    byKey[key] = ProductSalesStat(
      productId: entry.value.productId,
      productName: entry.value.productName,
      quantitySold: entry.value.quantitySold,
      revenueEur: entry.value.revenueEur,
      orderCount: orderIdsPerProduct[key]?.length ?? 0,
    );
  }

  final list = byKey.values.toList()
    ..sort((a, b) => b.quantitySold.compareTo(a.quantitySold));
  return list;
});

final orderDashboardStatsProvider = Provider<OrderDashboardStats>((ref) {
  final orders = ref.watch(ordersListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final weekStart = startOfDay.subtract(Duration(days: now.weekday - 1));

  var todayCount = 0;
  var newCount = 0;
  var weekRevenue = 0.0;

  for (final o in orders) {
    if (o.status == OrderStatus.newOrder) newCount++;
    if (!o.createdAt.isBefore(startOfDay) && o.status.countsTowardRevenue) {
      todayCount++;
    }
    if (!o.createdAt.isBefore(weekStart) && o.status.countsTowardRevenue) {
      weekRevenue += o.subtotalEur;
    }
  }

  return OrderDashboardStats(
    todayCount: todayCount,
    newCount: newCount,
    weekRevenueEur: weekRevenue,
  );
});
