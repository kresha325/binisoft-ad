import '../../../core/l10n/document_l10n.dart';
import '../../billing/domain/report_period.dart';
import '../../billing/domain/report_period_calculator.dart';
import 'entities/order.dart';
import 'entities/order_sales_report.dart';

abstract final class OrderSalesReportBuilder {
  static OrderSalesReport build({
    required List<BusinessOrder> orders,
    required ReportPeriod period,
    required DateTime anchor,
    required String businessName,
    String languageCode = 'en',
  }) {
    final docL10n = DocumentL10n.fromLanguageCode(languageCode);
    final bounds = ReportPeriodCalculator.bounds(period, anchor);
    final periodKey = ReportPeriodCalculator.periodKey(period, anchor);

    final inPeriod = orders.where((o) {
      if (o.createdAt.isBefore(bounds.start)) return false;
      if (o.createdAt.isAfter(bounds.end)) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    var revenue = 0.0;
    var active = 0;
    var completed = 0;
    var cancelled = 0;
    final productMap = <String, OrderReportProductSummary>{};

    for (final order in inPeriod) {
      switch (order.status) {
        case OrderStatus.newOrder:
          active++;
        case OrderStatus.confirmed:
          completed++;
        case OrderStatus.cancelled:
          cancelled++;
      }

      if (order.status.countsTowardRevenue) {
        revenue += order.subtotalEur;
        for (final line in order.lines) {
          final key = line.productId.isNotEmpty ? line.productId : line.productName;
          final existing = productMap[key];
          if (existing == null) {
            productMap[key] = OrderReportProductSummary(
              productName: line.productName,
              quantitySold: line.quantity,
              revenueEur: line.lineTotalEur,
            );
          } else {
            productMap[key] = OrderReportProductSummary(
              productName: existing.productName,
              quantitySold: existing.quantitySold + line.quantity,
              revenueEur: existing.revenueEur + line.lineTotalEur,
            );
          }
        }
      }
    }

    final products = productMap.values.toList()
      ..sort((a, b) => b.quantitySold.compareTo(a.quantitySold));

    final summaries = inPeriod
        .map(
          (o) => OrderReportLineSummary(
            orderNumber: o.orderNumber,
            customerName: o.customer.name,
            customerPhone: o.customer.displayPhone,
            statusLabel: docL10n.orderStatusLabel(o.status),
            totalEur: o.subtotalEur,
            createdAt: o.createdAt,
            productsSummary: o.productsSummary,
          ),
        )
        .toList();

    return OrderSalesReport(
      businessName: businessName,
      period: period,
      periodKey: periodKey,
      periodStart: bounds.start,
      periodEnd: bounds.end,
      orderCount: inPeriod.length,
      revenueEur: revenue,
      activeCount: active,
      completedCount: completed,
      cancelledCount: cancelled,
      products: products,
      orders: summaries,
      generatedAt: DateTime.now(),
    );
  }
}
