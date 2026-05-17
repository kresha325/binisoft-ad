import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/tenant_paths.dart';
import '../../domain/entities/order.dart';
import '../models/order_model.dart';

class OrderRepository {
  OrderRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  Stream<List<BusinessOrder>> watchOrders({
    required String businessId,
    int limit = 200,
  }) {
    return _paths
        .orders(businessId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) => OrderModel.fromFirestore(d, businessId: businessId).toEntity(),
              )
              .toList(),
        );
  }

  Future<void> updateStatus({
    required String businessId,
    required String orderId,
    required OrderStatus status,
  }) async {
    final updates = <String, dynamic>{
      'status': status.value,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (status == OrderStatus.cancelled) {
      updates['cancelledAt'] = FieldValue.serverTimestamp();
      updates['cancelledBy'] = 'admin';
    } else if (status == OrderStatus.confirmed) {
      updates['confirmedAt'] = FieldValue.serverTimestamp();
    }
    await _paths.orders(businessId).doc(orderId).update(updates);
  }
}
