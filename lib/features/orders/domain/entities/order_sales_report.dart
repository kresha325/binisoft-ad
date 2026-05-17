import 'package:equatable/equatable.dart';

import '../../../billing/domain/report_period.dart';
import '../../../../core/l10n/document_l10n.dart';

class OrderReportLineSummary extends Equatable {
  const OrderReportLineSummary({
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.statusLabel,
    required this.totalEur,
    required this.createdAt,
    required this.productsSummary,
  });

  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String statusLabel;
  final double totalEur;
  final DateTime createdAt;
  final String productsSummary;

  @override
  List<Object?> get props => [orderNumber, createdAt];
}

class OrderReportProductSummary extends Equatable {
  const OrderReportProductSummary({
    required this.productName,
    required this.quantitySold,
    required this.revenueEur,
  });

  final String productName;
  final int quantitySold;
  final double revenueEur;

  @override
  List<Object?> get props => [productName, quantitySold, revenueEur];
}

class OrderSalesReport extends Equatable {
  const OrderSalesReport({
    required this.businessName,
    required this.period,
    required this.periodKey,
    required this.periodStart,
    required this.periodEnd,
    required this.orderCount,
    required this.revenueEur,
    required this.activeCount,
    required this.completedCount,
    required this.cancelledCount,
    required this.products,
    required this.orders,
    required this.generatedAt,
  });

  final String businessName;
  final ReportPeriod period;
  final String periodKey;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int orderCount;
  final double revenueEur;
  final int activeCount;
  final int completedCount;
  final int cancelledCount;
  final List<OrderReportProductSummary> products;
  final List<OrderReportLineSummary> orders;
  final DateTime generatedAt;

  String get formattedRevenue {
    final n = revenueEur;
    final s = n == n.roundToDouble() ? n.toInt().toString() : n.toStringAsFixed(2);
    return '€$s';
  }

  String titleLabelFor(String languageCode) {
    final label = DocumentL10n.fromLanguageCode(languageCode).periodLabel(period);
    return '$label · $periodKey';
  }

  @override
  List<Object?> get props => [period, periodKey, revenueEur, orderCount];
}
