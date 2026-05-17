import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/invoice.dart';
import '../../domain/invoice_type.dart';

class InvoiceModel {
  InvoiceModel({
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
  });

  final String id;
  final String userId;
  final String userEmail;
  final String type;
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

  factory InvoiceModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final paidAt = (data['paidAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    return InvoiceModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      userEmail: data['userEmail'] as String? ?? '',
      type: data['type'] as String? ?? InvoiceType.subscription.value,
      invoiceNumber: data['invoiceNumber'] as String? ?? doc.id,
      amountEur: (data['amountEur'] as num?)?.toDouble() ?? 0,
      currency: data['currency'] as String? ?? 'EUR',
      description: data['description'] as String? ?? '',
      planTitle: data['planTitle'] as String? ?? '',
      maxProducts: (data['maxProducts'] as num?)?.toInt() ?? 0,
      paidAt: paidAt,
      periodYear: (data['periodYear'] as num?)?.toInt() ?? paidAt.year,
      periodMonth: (data['periodMonth'] as num?)?.toInt() ?? paidAt.month,
      paymentMethod: data['paymentMethod'] as String?,
      lineItems: (data['lineItems'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userEmail': userEmail,
        'type': type,
        'invoiceNumber': invoiceNumber,
        'amountEur': amountEur,
        'currency': currency,
        'description': description,
        'planTitle': planTitle,
        'maxProducts': maxProducts,
        'paidAt': Timestamp.fromDate(paidAt),
        'periodYear': periodYear,
        'periodMonth': periodMonth,
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
        'lineItems': lineItems,
      };

  Invoice toEntity() => Invoice(
        id: id,
        userId: userId,
        userEmail: userEmail,
        type: InvoiceType.fromString(type),
        invoiceNumber: invoiceNumber,
        amountEur: amountEur,
        currency: currency,
        description: description,
        planTitle: planTitle,
        maxProducts: maxProducts,
        paidAt: paidAt,
        periodYear: periodYear,
        periodMonth: periodMonth,
        paymentMethod: paymentMethod,
        lineItems: lineItems,
      );
}
