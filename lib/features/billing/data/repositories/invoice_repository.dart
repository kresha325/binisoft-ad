import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/business_plans.dart';
import '../../../../core/constants/payment_config.dart';
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
}

class InvoiceRepository {
  InvoiceRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _userInvoices(String userId) =>
      _firestore.collection('users').doc(userId).collection('invoices');

  Future<String> _nextInvoiceNumber(DateTime paidAt) async {
    final key = '${paidAt.year}${paidAt.month.toString().padLeft(2, '0')}';
    final counterRef = _firestore.collection('invoice_counters').doc(key);
    final next = await _firestore.runTransaction<int>((tx) async {
      final snap = await tx.get(counterRef);
      final current = (snap.data()?['seq'] as num?)?.toInt() ?? 0;
      final seq = current + 1;
      tx.set(counterRef, {'seq': seq}, SetOptions(merge: true));
      return seq;
    });
    return 'BIN-$key-${next.toString().padLeft(4, '0')}';
  }

  Future<Invoice> createInvoice(CreateInvoiceInput input) async {
    final paidAt = input.paidAt ?? DateTime.now();
    final invoiceNumber = await _nextInvoiceNumber(paidAt);
    final model = InvoiceModel(
      id: '',
      userId: input.userId,
      userEmail: input.userEmail,
      type: input.type.value,
      invoiceNumber: invoiceNumber,
      amountEur: input.amountEur,
      currency: PaymentConfig.currencyCode,
      description: input.description,
      planTitle: input.plan.title,
      maxProducts: input.plan.maxProducts,
      paidAt: paidAt,
      periodYear: paidAt.year,
      periodMonth: paidAt.month,
      paymentMethod: input.paymentMethod,
      lineItems: input.lineItems,
    );

    final ref = await _userInvoices(input.userId).add(model.toMap());
    final doc = await ref.get();
    return InvoiceModel.fromFirestore(doc).toEntity();
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
  }) {
    return createInvoice(
      CreateInvoiceInput(
        userId: userId,
        userEmail: userEmail,
        type: InvoiceType.subscription,
        amountEur: amountEur,
        description: 'New business · $businessName',
        plan: plan,
        paymentMethod: paymentMethod,
        lineItems: [
          'Business: $businessName',
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
