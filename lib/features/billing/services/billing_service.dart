import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/business_plans.dart';
import '../data/repositories/invoice_repository.dart';
import '../presentation/providers/invoice_providers.dart';

final billingServiceProvider = Provider<BillingService>((ref) {
  return BillingService(ref.watch(invoiceRepositoryProvider));
});

class BillingService {
  BillingService(this._invoices);

  final InvoiceRepository _invoices;

  Future<void> recordRegistrationPayment({
    required String userId,
    required String userEmail,
    required BusinessPlan plan,
    required double amountEur,
    String? paymentMethod,
  }) async {
    await _invoices.createRegistrationInvoice(
      userId: userId,
      userEmail: userEmail,
      plan: plan,
      amountEur: amountEur,
      paymentMethod: paymentMethod,
    );
  }

  Future<void> recordNewBusinessPayment({
    required String userId,
    required String userEmail,
    required BusinessPlan plan,
    required String businessName,
    required double amountEur,
    String? paymentMethod,
  }) async {
    await _invoices.createNewBusinessInvoice(
      userId: userId,
      userEmail: userEmail,
      plan: plan,
      businessName: businessName,
      amountEur: amountEur,
      paymentMethod: paymentMethod,
    );
  }

  Future<void> recordPlanChange({
    required String userId,
    required String userEmail,
    required BusinessPlan plan,
    double amountEur = 0,
  }) async {
    await _invoices.createPlanChangeInvoice(
      userId: userId,
      userEmail: userEmail,
      plan: plan,
      amountEur: amountEur,
    );
  }

  /// Call when monthly billing runs (Cloud Function / cron later).
  Future<void> recordMonthlyPayment({
    required String userId,
    required String userEmail,
    required BusinessPlan plan,
    DateTime? period,
  }) async {
    await _invoices.createMonthlyInvoice(
      userId: userId,
      userEmail: userEmail,
      plan: plan,
      period: period ?? DateTime.now(),
    );
  }
}
