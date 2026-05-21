import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/constants/payment_config.dart';
import '../../../../core/services/invoice_api_service.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/invoice_type.dart';
import '../models/invoice_model.dart';

class CreateInvoiceInput {
  const CreateInvoiceInput({
    required this.userId,
    required this.userEmail,
    required this.type,
    required this.amountEur,
    required this.description,
    required this.plan,
    this.paymentMethod,
    this.lineItems = const [],
    this.paidAt,
    this.buyerLegalName,
    this.buyerNipt,
    this.buyerAddress,
  });

  final String userId;
  final String userEmail;
  final InvoiceType type;
  final double amountEur;
  final String description;
  final BusinessPlan plan;
  final String? paymentMethod;
  final List<String> lineItems;
  final DateTime? paidAt;
  final String? buyerLegalName;
  final String? buyerNipt;
  final String? buyerAddress;
}

class InvoiceRepository {
  InvoiceRepository({
    required FirebaseFirestore firestore,
    InvoiceApiService? invoiceApi,
  })  : _firestore = firestore,
        _invoiceApi = invoiceApi ?? InvoiceApiService();

  final FirebaseFirestore _firestore;
  final InvoiceApiService _invoiceApi;

  CollectionReference<Map<String, dynamic>> _userInvoices(String userId) =>
      _firestore.collection('users').doc(userId).collection('invoices');

  Invoice _invoiceFromApi(Map<String, dynamic> data) {
    final paidAt = DateTime.tryParse(data['paidAt'] as String? ?? '') ?? DateTime.now();
    return InvoiceModel(
      id: data['id'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      userEmail: data['userEmail'] as String? ?? '',
      type: data['type'] as String? ?? InvoiceType.subscription.value,
      invoiceNumber: data['invoiceNumber'] as String? ?? '',
      amountEur: (data['amountEur'] as num?)?.toDouble() ?? 0,
      currency: data['currency'] as String? ?? PaymentConfig.currencyCode,
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
      buyerLegalName: data['buyerLegalName'] as String?,
      buyerNipt: data['buyerNipt'] as String?,
      buyerAddress: data['buyerAddress'] as String?,
    ).toEntity();
  }

  Future<Invoice> createInvoice(CreateInvoiceInput input) async {
    final paidAt = input.paidAt ?? DateTime.now();
    final data = await _invoiceApi.createInvoice({
      'userId': input.userId,
      'userEmail': input.userEmail,
      'type': input.type.value,
      'amountEur': input.amountEur,
      'currency': PaymentConfig.currencyCode,
      'description': input.description,
      'planTitle': input.plan.title,
      'maxProducts': input.plan.maxProducts,
      'paidAt': paidAt.toUtc().toIso8601String(),
      'periodYear': paidAt.year,
      'periodMonth': paidAt.month,
      if (input.paymentMethod != null) 'paymentMethod': input.paymentMethod,
      'lineItems': input.lineItems,
      if (input.buyerLegalName != null && input.buyerLegalName!.isNotEmpty)
        'buyerLegalName': input.buyerLegalName,
      if (input.buyerNipt != null && input.buyerNipt!.isNotEmpty)
        'buyerNipt': input.buyerNipt,
      if (input.buyerAddress != null && input.buyerAddress!.isNotEmpty)
        'buyerAddress': input.buyerAddress,
    });
    return _invoiceFromApi(data);
  }

  Stream<List<Invoice>> watchUserInvoices(String userId) {
    return _userInvoices(userId)
        .orderBy('paidAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(InvoiceModel.fromFirestore).map((m) => m.toEntity()).toList());
  }

  Future<List<Invoice>> listUserInvoices(String userId) async {
    final snap = await _userInvoices(userId).orderBy('paidAt', descending: true).get();
    return snap.docs.map(InvoiceModel.fromFirestore).map((m) => m.toEntity()).toList();
  }

  Future<List<Invoice>> listInvoicesInRange(DateTime start, DateTime end) async {
    final snap = await _firestore
        .collectionGroup('invoices')
        .where('paidAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('paidAt', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('paidAt', descending: true)
        .get();
    return snap.docs.map(InvoiceModel.fromFirestore).map((m) => m.toEntity()).toList();
  }

  Stream<List<Invoice>> watchAllInvoices({InvoiceType? type}) {
    Query<Map<String, dynamic>> q =
        _firestore.collectionGroup('invoices').orderBy('paidAt', descending: true);
    if (type != null) {
      q = q.where('type', isEqualTo: type.value);
    }
    return q.snapshots().map(
          (snap) => snap.docs.map(InvoiceModel.fromFirestore).map((m) => m.toEntity()).toList(),
        );
  }

  Future<Invoice> createRegistrationInvoice({
    required String userId,
    required String userEmail,
    required BusinessPlan plan,
    required double amountEur,
    String? paymentMethod,
  }) {
    return createInvoice(
      CreateInvoiceInput(
        userId: userId,
        userEmail: userEmail,
        type: InvoiceType.subscription,
        amountEur: amountEur,
        description: 'Registration · ${plan.title} (${plan.maxProducts} products)',
        plan: plan,
        paymentMethod: paymentMethod,
        lineItems: [
          '${plan.registrationPriceLabel} (includes 1st month)',
          'Then ${plan.priceLabel}',
          'Up to ${plan.maxBusinesses} businesses · ${plan.maxProducts} products',
        ],
      ),
    );
  }

  Future<Invoice> createNewBusinessInvoice({
    required String userId,
    required String userEmail,
    required BusinessPlan plan,
    required String businessName,
    required double amountEur,
    String? paymentMethod,
    String? buyerLegalName,
    String? buyerNipt,
    String? buyerAddress,
  }) {
    final buyer = buyerLegalName?.trim();
    final nipt = buyerNipt?.trim();
    final addr = buyerAddress?.trim();
    return createInvoice(
      CreateInvoiceInput(
        userId: userId,
        userEmail: userEmail,
        type: InvoiceType.subscription,
        amountEur: amountEur,
        description: 'New business · $businessName',
        plan: plan,
        paymentMethod: paymentMethod,
        buyerLegalName: buyer,
        buyerNipt: nipt,
        buyerAddress: addr,
        lineItems: [
          'Business: $businessName',
          if (buyer != null && buyer.isNotEmpty) 'Legal name: $buyer',
          if (nipt != null && nipt.isNotEmpty) 'NIPT: $nipt',
          if (addr != null && addr.isNotEmpty) 'Address: $addr',
          '${plan.registrationPriceLabel} (includes 1st month)',
          'Then ${plan.priceLabel} per business',
          'Up to ${plan.maxProducts} products in catalog',
        ],
      ),
    );
  }

  Future<Invoice> createPlanChangeInvoice({
    required String userId,
    required String userEmail,
    required BusinessPlan plan,
    required double amountEur,
  }) {
    return createInvoice(
      CreateInvoiceInput(
        userId: userId,
        userEmail: userEmail,
        type: InvoiceType.subscription,
        amountEur: amountEur,
        description: 'Plan update · ${plan.title}',
        plan: plan,
        lineItems: [
          'Catalog limit: ${plan.maxProducts} products',
          plan.pricingHeadline,
        ],
      ),
    );
  }

  Future<Invoice> createMonthlyInvoice({
    required String userId,
    required String userEmail,
    required BusinessPlan plan,
    required DateTime period,
  }) {
    return createInvoice(
      CreateInvoiceInput(
        userId: userId,
        userEmail: userEmail,
        type: InvoiceType.monthly,
        amountEur: plan.monthlyEuro,
        description: 'Monthly subscription · ${period.year}-${period.month.toString().padLeft(2, '0')}',
        plan: plan,
        paidAt: period,
        lineItems: [
          '${plan.title} · up to ${plan.maxProducts} products',
          plan.priceLabel,
        ],
      ),
    );
  }
}
