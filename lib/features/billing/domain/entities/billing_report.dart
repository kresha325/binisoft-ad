import 'package:equatable/equatable.dart';

import '../report_period.dart';

class ReportInvoiceSummary extends Equatable {
  const ReportInvoiceSummary({
    required this.invoiceNumber,
    required this.userEmail,
    required this.type,
    required this.amountEur,
    required this.paidAt,
  });

  final String invoiceNumber;
  final String userEmail;
  final String type;
  final double amountEur;
  final DateTime paidAt;

  @override
  List<Object?> get props => [invoiceNumber, userEmail, amountEur, paidAt];
}

class BillingReport extends Equatable {
  const BillingReport({
    required this.id,
    required this.period,
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
  final ReportPeriod period;
  final String periodKey;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int invoiceCount;
  final double totalEur;
  final double subscriptionTotalEur;
  final double monthlyTotalEur;
  final List<ReportInvoiceSummary> invoices;
  final DateTime generatedAt;

  String get formattedTotal {
    final n = totalEur;
    final s = n == n.roundToDouble() ? n.toInt().toString() : n.toStringAsFixed(2);
    return '€$s';
  }

  String get titleLabel => '${period.labelSq} · $periodKey';

  @override
  List<Object?> get props => [id, period, periodKey, totalEur, invoiceCount];
}
