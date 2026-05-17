import 'package:equatable/equatable.dart';

import 'order_line.dart';

enum OrderStatus { newOrder, confirmed, cancelled }

extension OrderStatusX on OrderStatus {
  String get value => switch (this) {
        OrderStatus.newOrder => 'pending',
        OrderStatus.confirmed => 'confirmed',
        OrderStatus.cancelled => 'cancelled',
      };

  static OrderStatus fromValue(String? raw) => switch (raw) {
        'confirmed' => OrderStatus.confirmed,
        'cancelled' => OrderStatus.cancelled,
        'pending' || 'new' => OrderStatus.newOrder,
        _ => OrderStatus.newOrder,
      };

  String get label => switch (this) {
        OrderStatus.newOrder => 'Pending',
        OrderStatus.confirmed => 'Completed',
        OrderStatus.cancelled => 'Cancelled',
      };

  bool get isPending => this == OrderStatus.newOrder;

  /// Revenue counts only non-cancelled orders.
  bool get countsTowardRevenue => this != OrderStatus.cancelled;
}

class OrderCustomer extends Equatable {
  const OrderCustomer({
    required this.name,
    required this.phone,
    this.notes,
  });

  final String name;
  final String phone;
  final String? notes;

  /// Real phone for display; ignores demo placeholder values.
  String get displayPhone {
    final p = phone.trim();
    if (p.length < 6) return '';
    final lower = p.toLowerCase();
    if (lower == 'klient' || lower == 'client') return '';
    return p;
  }

  bool get hasDisplayPhone => displayPhone.isNotEmpty;

  @override
  List<Object?> get props => [name, phone, notes];
}

class BusinessOrder extends Equatable {
  const BusinessOrder({
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

  int get itemCount => lines.fold(0, (sum, l) => sum + l.quantity);

  /// e.g. "2× Margherita, 1× Cola"
  String get productsSummary => lines
      .map(
        (l) => l.quantity > 1 ? '${l.quantity}× ${l.productName}' : l.productName,
      )
      .join(', ');

  bool matchesSearch(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    if (orderNumber.toLowerCase().contains(q)) return true;
    if (customer.name.toLowerCase().contains(q)) return true;
    if (customer.phone.contains(q)) return true;
    if (customer.displayPhone.contains(q)) return true;
    if (customer.notes?.toLowerCase().contains(q) ?? false) return true;
    return lines.any((l) => l.productName.toLowerCase().contains(q));
  }

  @override
  List<Object?> get props => [
        id,
        businessId,
        orderNumber,
        status,
        createdAt,
        customer,
        lines,
        subtotalEur,
        currency,
        source,
        notifyChannel,
      ];
}
