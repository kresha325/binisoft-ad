import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/billing_report.dart';
import '../../domain/report_period.dart';
import '../../domain/report_period_calculator.dart';
import '../models/billing_report_model.dart';
import 'invoice_repository.dart';

class BillingReportRepository {
  BillingReportRepository({
    required FirebaseFirestore firestore,
    required InvoiceRepository invoiceRepository,
  })  : _firestore = firestore,
        _invoices = invoiceRepository;

  final FirebaseFirestore _firestore;
  final InvoiceRepository _invoices;

  CollectionReference<Map<String, dynamic>> get _reports =>
      _firestore.collection('billing_reports');

  Stream<List<BillingReport>> watchReports(ReportPeriod period, {int limit = 48}) {
    return _reports
        .where('periodType', isEqualTo: period.value)
        .orderBy('periodStart', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(BillingReportModel.fromFirestore)
              .map((m) => m.toEntity())
              .toList(),
        );
  }

  Future<BillingReport?> getReport(ReportPeriod period, String periodKey) async {
    final id = ReportPeriodCalculator.docId(period, periodKey);
    final doc = await _reports.doc(id).get();
    if (!doc.exists) return null;
    return BillingReportModel.fromFirestore(doc).toEntity();
  }

  Future<BillingReport> generateAndSave({
    required ReportPeriod period,
    required DateTime anchor,
  }) async {
    final periodKey = ReportPeriodCalculator.periodKey(period, anchor);
    final bounds = ReportPeriodCalculator.bounds(period, anchor);
    final invoices = await _invoices.listInvoicesInRange(bounds.start, bounds.end);

    var subscriptionTotal = 0.0;
    var monthlyTotal = 0.0;
    final rows = <Map<String, dynamic>>[];

    for (final inv in invoices) {
      if (inv.type.value == 'subscription') {
        subscriptionTotal += inv.amountEur;
      } else {
        monthlyTotal += inv.amountEur;
      }
      rows.add({
        'invoiceNumber': inv.invoiceNumber,
        'userEmail': inv.userEmail,
        'type': inv.type.value,
        'amountEur': inv.amountEur,
        'paidAt': Timestamp.fromDate(inv.paidAt),
      });
    }

    final total = subscriptionTotal + monthlyTotal;
    final id = ReportPeriodCalculator.docId(period, periodKey);
    final model = BillingReportModel(
      id: id,
      periodType: period.value,
      periodKey: periodKey,
      periodStart: bounds.start,
      periodEnd: bounds.end,
      invoiceCount: invoices.length,
      totalEur: total,
      subscriptionTotalEur: subscriptionTotal,
      monthlyTotalEur: monthlyTotal,
      invoices: rows,
      generatedAt: DateTime.now(),
    );

    await _reports.doc(id).set(model.toMap(), SetOptions(merge: true));
    return model.toEntity();
  }

  /// Ensures recent reports exist (client fallback when Cloud Functions are idle).
  Future<void> ensureRecentReports() async {
    final now = DateTime.now();
    final tasks = <Future<void>>[];

    for (final period in ReportPeriod.values) {
      final anchor = ReportPeriodCalculator.previousPeriodAnchor(period, now);
      final key = ReportPeriodCalculator.periodKey(period, anchor);
      final existing = await getReport(period, key);
      if (existing == null) {
        tasks.add(generateAndSave(period: period, anchor: anchor));
      }
    }

    // Current partial periods (today, this week, month, year).
    for (final period in ReportPeriod.values) {
      final key = ReportPeriodCalculator.periodKey(period, now);
      final existing = await getReport(period, key);
      final age = existing == null
          ? 999
          : DateTime.now().difference(existing.generatedAt).inHours;
      if (existing == null || age > 6) {
        tasks.add(generateAndSave(period: period, anchor: now));
      }
    }

    if (tasks.isEmpty) return;
    await Future.wait(tasks.map((t) => t.catchError((_) {})));
  }
}
