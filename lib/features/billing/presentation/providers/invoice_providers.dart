import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../data/repositories/billing_report_repository.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../domain/entities/billing_report.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/invoice_type.dart';
import '../../domain/report_period.dart';
import '../../services/billing_report_export_service.dart';
import '../../services/invoice_export_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(firestore: ref.watch(firestoreProvider));
});

final billingReportRepositoryProvider = Provider<BillingReportRepository>((ref) {
  return BillingReportRepository(
    firestore: ref.watch(firestoreProvider),
    invoiceRepository: ref.watch(invoiceRepositoryProvider),
  );
});

final invoiceExportServiceProvider = Provider((ref) => const InvoiceExportService());

final billingReportExportServiceProvider =
    Provider((ref) => const BillingReportExportService());

/// Syncs reports on superadmin entry (also runs via Cloud Functions schedule).
final billingReportsSyncProvider = FutureProvider<void>((ref) async {
  try {
    await ref.watch(billingReportRepositoryProvider).ensureRecentReports();
  } on FirebaseException catch (e) {
    if (e.code == 'permission-denied') {
      debugPrint(
        'Billing report sync skipped (deploy firestore.rules with invoices collectionGroup): ${e.message}',
      );
      return;
    }
    rethrow;
  }
});

final myInvoicesProvider = StreamProvider<List<Invoice>>((ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.id;
  if (uid == null) return const Stream.empty();
  return ref.watch(invoiceRepositoryProvider).watchUserInvoices(uid);
});

final platformSubscriptionInvoicesProvider = StreamProvider<List<Invoice>>((ref) {
  return ref.watch(invoiceRepositoryProvider).watchAllInvoices(type: InvoiceType.subscription);
});

final platformMonthlyInvoicesProvider = StreamProvider<List<Invoice>>((ref) {
  return ref.watch(invoiceRepositoryProvider).watchAllInvoices(type: InvoiceType.monthly);
});

final billingReportsProvider = StreamProvider.family<List<BillingReport>, ReportPeriod>(
  (ref, period) => ref.watch(billingReportRepositoryProvider).watchReports(period),
);

/// Groups invoices by period key (YYYY-MM), newest periods first.
Map<String, List<Invoice>> groupInvoicesByPeriod(List<Invoice> invoices) {
  final map = <String, List<Invoice>>{};
  for (final inv in invoices) {
    map.putIfAbsent(inv.periodKey, () => []).add(inv);
  }
  final keys = map.keys.toList()..sort((a, b) => b.compareTo(a));
  return {for (final k in keys) k: map[k]!};
}
