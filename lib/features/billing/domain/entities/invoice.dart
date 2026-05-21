import 'package:equatable/equatable.dart';

import '../invoice_type.dart';

class Invoice extends Equatable {
  const Invoice({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.type,
    required this.invoiceNumber,
    required this.amountEur,
    required this.currency,
    required this.description,
    required this.planTitle,
    required this.maxProducts,
    required this.paidAt,
    required this.periodYear,
    required this.periodMonth,
    this.paymentMethod,
    this.lineItems = const [],
    this.buyerLegalName,
    this.buyerNipt,
    this.buyerAddress,
  });

  final String id;
  final String userId;
  final String userEmail;
  final InvoiceType type;
  final String invoiceNumber;
  final double amountEur;
  final String currency;
  final String description;
  final String planTitle;
  final int maxProducts;
  final DateTime paidAt;
  final int periodYear;
  final int periodMonth;
  final String? paymentMethod;
  final List<String> lineItems;
  final String? buyerLegalName;
  final String? buyerNipt;
  final String? buyerAddress;

  String get periodKey =>
      '$periodYear-${periodMonth.toString().padLeft(2, '0')}';

  String get formattedAmount {
    final n = amountEur;
    final s = n == n.roundToDouble() ? n.toInt().toString() : n.toStringAsFixed(2);
    return '€$s';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userEmail,
        type,
        invoiceNumber,
        amountEur,
        paidAt,
      ];
}
