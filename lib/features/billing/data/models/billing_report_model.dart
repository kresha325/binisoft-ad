import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/billing_report.dart';
import '../../domain/report_period.dart';

class BillingReportModel {
  BillingReportModel({
    required this.id,
    required this.periodType,
    required this.periodKey,
    required this.periodStart,
    required this.periodEnd,
    required this.invoiceCount,
    required this.totalEur,
    required this.subscriptionTotalEur,
    required this.monthlyTotalEur,
    required this.invoices,
    required this.generatedAt,
  });

  final String id;
  final String periodType;
  final String periodKey;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int invoiceCount;
  final double totalEur;
  final double subscriptionTotalEur;
  final double monthlyTotalEur;
  final List<Map<String, dynamic>> invoices;
  final DateTime generatedAt;

  static BillingReportModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return BillingReportModel(
      id: doc.id,
      periodType: d['periodType'] as String? ?? 'daily',
      periodKey: d['periodKey'] as String? ?? '',
      periodStart: _toDate(d['periodStart']),
      periodEnd: _toDate(d['periodEnd']),
      invoiceCount: (d['invoiceCount'] as num?)?.toInt() ?? 0,
      totalEur: (d['totalEur'] as num?)?.toDouble() ?? 0,
      subscriptionTotalEur: (d['subscriptionTotalEur'] as num?)?.toDouble() ?? 0,
      monthlyTotalEur: (d['monthlyTotalEur'] as num?)?.toDouble() ?? 0,
      invoices: List<Map<String, dynamic>>.from(d['invoices'] as List? ?? []),
      generatedAt: _toDate(d['generatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'periodType': periodType,
        'periodKey': periodKey,
        'periodStart': Timestamp.fromDate(periodStart),
        'periodEnd': Timestamp.fromDate(periodEnd),
        'invoiceCount': invoiceCount,
        'totalEur': totalEur,
        'subscriptionTotalEur': subscriptionTotalEur,
        'monthlyTotalEur': monthlyTotalEur,
        'invoices': invoices,
        'generatedAt': Timestamp.fromDate(generatedAt),
      };

  BillingReport toEntity() {
    return BillingReport(
      id: id,
      period: ReportPeriod.fromString(periodType),
      periodKey: periodKey,
      periodStart: periodStart,
      periodEnd: periodEnd,
      invoiceCount: invoiceCount,
      totalEur: totalEur,
      subscriptionTotalEur: subscriptionTotalEur,
      monthlyTotalEur: monthlyTotalEur,
      invoices: invoices.map((row) {
        return ReportInvoiceSummary(
          invoiceNumber: row['invoiceNumber'] as String? ?? '',
          userEmail: row['userEmail'] as String? ?? '',
          type: row['type'] as String? ?? '',
          amountEur: (row['amountEur'] as num?)?.toDouble() ?? 0,
          paidAt: _toDate(row['paidAt']),
        );
      }).toList(),
      generatedAt: generatedAt,
    );
  }

  static DateTime _toDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
