import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/order_line.dart';

String _readCustomerName(Map<String, dynamic> customerMap, Map<String, dynamic> data) {
  final name = customerMap['name'] ?? data['customerName'];
  return name?.toString().trim() ?? '';
}

String _readCustomerPhone(Map<String, dynamic> customerMap, Map<String, dynamic> data) {
  final phone = customerMap['phone'] ??
      customerMap['phoneNumber'] ??
      data['customerPhone'];
  return phone?.toString().trim() ?? '';
}

class OrderModel {
  OrderModel({
    required this.id,
    required this.businessId,
    required this.orderNumber,
    required this.status,
    required this.createdAt,
    required this.customer,
    required this.lines,
    required this.subtotalEur,
    this.currency = 'EUR',
    this.source = 'api',
    this.notifyChannel,
  });

  final String id;
  final String businessId;
  final String orderNumber;
  final OrderStatus status;
  final DateTime createdAt;
  final OrderCustomer customer;
  final List<OrderLine> lines;
  final double subtotalEur;
  final String currency;
  final String source;
  final String? notifyChannel;

  factory OrderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    required String businessId,
  }) {
    final data = doc.data() ?? {};
    final createdAt =
        (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    final customerMap = data['customer'] as Map<String, dynamic>? ?? {};
    final rawLines = data['lines'] as List<dynamic>? ?? [];

    return OrderModel(
      id: doc.id,
      businessId: businessId,
      orderNumber: data['orderNumber'] as String? ?? doc.id,
      status: OrderStatusX.fromValue(data['status'] as String?),
      createdAt: createdAt,
      customer: OrderCustomer(
        name: _readCustomerName(customerMap, data),
        phone: _readCustomerPhone(customerMap, data),
        notes: customerMap['notes'] as String? ??
            data['customerNotes'] as String?,
      ),
      lines: rawLines.map((e) {
        final m = Map<String, dynamic>.from(e as Map);
        return OrderLine(
          productId: m['productId'] as String? ?? '',
          productName: m['productName'] as String? ?? '',
          quantity: (m['quantity'] as num?)?.toInt() ?? 0,
          unitPriceEur: (m['unitPriceEur'] as num?)?.toDouble() ?? 0,
          lineTotalEur: (m['lineTotalEur'] as num?)?.toDouble() ?? 0,
        );
      }).toList(),
      subtotalEur: (data['subtotalEur'] as num?)?.toDouble() ?? 0,
      currency: data['currency'] as String? ?? 'EUR',
      source: data['source'] as String? ?? 'api',
      notifyChannel: data['notifyChannel'] as String?,
    );
  }

  BusinessOrder toEntity() => BusinessOrder(
        id: id,
        businessId: businessId,
        orderNumber: orderNumber,
        status: status,
        createdAt: createdAt,
        customer: customer,
        lines: lines,
        subtotalEur: subtotalEur,
        currency: currency,
        source: source,
        notifyChannel: notifyChannel,
      );
}
