import '../../features/billing/domain/invoice_type.dart';
import '../../features/billing/domain/report_period.dart';
import '../../features/orders/domain/entities/order.dart';
import 'ui_locales.dart';

/// PDF / export copy in en, sq, or de (no [BuildContext]).
class DocumentL10n {
  const DocumentL10n._({
    required this.invoiceTitle,
    required this.billTo,
    required this.issueDate,
    required this.billingPeriod,
    required this.paymentMethod,
    required this.currency,
    required this.plan,
    required this.upToProducts,
    required this.description,
    required this.qty,
    required this.amount,
    required this.totalPaid,
    required this.paid,
    required this.thankYouFooter,
    required this.ordersReportTitle,
    required this.generated,
    required this.revenueExcludesCancelled,
    required this.orders,
    required this.noOrdersInPeriod,
    required this.productsSold,
    required this.product,
    required this.revenue,
    required this.orderStatusPending,
    required this.orderStatusCompleted,
    required this.orderStatusCancelled,
    required this.tableOrder,
    required this.tableCustomer,
    required this.tablePhone,
    required this.tableProducts,
    required this.tableTotal,
    required this.tableStatus,
    required this.tableDate,
    required this.tableQty,
    required this.invoiceTypeSubscription,
    required this.invoiceTypeMonthly,
    required this.periodDaily,
    required this.periodWeekly,
    required this.periodMonthly,
    required this.periodYearly,
    required this.shareInvoiceText,
    required this.shareReportText,
  });

  final String invoiceTitle;
  final String billTo;
  final String issueDate;
  final String billingPeriod;
  final String paymentMethod;
  final String currency;
  final String plan;
  final String upToProducts;
  final String description;
  final String qty;
  final String amount;
  final String totalPaid;
  final String paid;
  final String thankYouFooter;
  final String ordersReportTitle;
  final String generated;
  final String revenueExcludesCancelled;
  final String orders;
  final String noOrdersInPeriod;
  final String productsSold;
  final String product;
  final String revenue;
  final String orderStatusPending;
  final String orderStatusCompleted;
  final String orderStatusCancelled;
  final String tableOrder;
  final String tableCustomer;
  final String tablePhone;
  final String tableProducts;
  final String tableTotal;
  final String tableStatus;
  final String tableDate;
  final String tableQty;
  final String invoiceTypeSubscription;
  final String invoiceTypeMonthly;
  final String periodDaily;
  final String periodWeekly;
  final String periodMonthly;
  final String periodYearly;
  final String shareInvoiceText;
  final String shareReportText;

  static DocumentL10n fromLanguageCode(String? code) {
    final c = UiLocales.fromCode(code)?.languageCode ?? 'en';
    return switch (c) {
      'sq' => _sq,
      'de' => _de,
      _ => _en,
    };
  }

  String periodLabel(ReportPeriod period) => switch (period) {
        ReportPeriod.daily => periodDaily,
        ReportPeriod.weekly => periodWeekly,
        ReportPeriod.monthly => periodMonthly,
        ReportPeriod.yearly => periodYearly,
      };

  String invoiceTypeLabel(InvoiceType type) => switch (type) {
        InvoiceType.subscription => invoiceTypeSubscription,
        InvoiceType.monthly => invoiceTypeMonthly,
      };

  String orderStatusLabel(OrderStatus status) => switch (status) {
        OrderStatus.newOrder => orderStatusPending,
        OrderStatus.confirmed => orderStatusCompleted,
        OrderStatus.cancelled => orderStatusCancelled,
      };

  String upToProductsCount(int max) => upToProducts.replaceAll('{count}', '$max');

  String shareInvoice(String number, String amount) =>
      shareInvoiceText.replaceAll('{number}', number).replaceAll('{amount}', amount);

  String shareReport(String business, String title, String revenue) => shareReportText
      .replaceAll('{business}', business)
      .replaceAll('{title}', title)
      .replaceAll('{revenue}', revenue);

  static const _en = DocumentL10n._(
    invoiceTitle: 'INVOICE',
    billTo: 'BILL TO',
    issueDate: 'Issue date',
    billingPeriod: 'Billing period',
    paymentMethod: 'Payment method',
    currency: 'Currency',
    plan: 'Plan',
    upToProducts: 'Up to {count} products',
    description: 'Description',
    qty: 'Qty',
    amount: 'Amount',
    totalPaid: 'TOTAL PAID',
    paid: 'Paid',
    thankYouFooter:
        'Thank you for your payment. This document serves as your official invoice.',
    ordersReportTitle: 'Orders report',
    generated: 'Generated',
    revenueExcludesCancelled: 'Revenue excludes cancelled orders',
    orders: 'Orders',
    noOrdersInPeriod: 'No orders in this period.',
    productsSold: 'Products sold',
    product: 'Product',
    revenue: 'Revenue',
    orderStatusPending: 'Pending',
    orderStatusCompleted: 'Completed',
    orderStatusCancelled: 'Cancelled',
    tableOrder: 'Order',
    tableCustomer: 'Customer',
    tablePhone: 'Phone',
    tableProducts: 'Products',
    tableTotal: 'Total',
    tableStatus: 'Status',
    tableDate: 'Date',
    tableQty: 'Qty',
    invoiceTypeSubscription: 'Subscription',
    invoiceTypeMonthly: 'Monthly payment',
    periodDaily: 'Daily',
    periodWeekly: 'Weekly',
    periodMonthly: 'Monthly',
    periodYearly: 'Yearly',
    shareInvoiceText: 'Invoice {number} · {amount}',
    shareReportText: '{business} · {title} · {revenue}',
  );

  static const _sq = DocumentL10n._(
    invoiceTitle: 'FATURË',
    billTo: 'FATUROHU NË',
    issueDate: 'Data e lëshimit',
    billingPeriod: 'Periudha e faturimit',
    paymentMethod: 'Metoda e pagesës',
    currency: 'Monedha',
    plan: 'Plani',
    upToProducts: 'Deri në {count} produkte',
    description: 'Përshkrimi',
    qty: 'Sasia',
    amount: 'Shuma',
    totalPaid: 'TOTALI I PAGUAR',
    paid: 'Paguar',
    thankYouFooter:
        'Faleminderit për pagesën. Ky dokument shërben si fatura zyrtare.',
    ordersReportTitle: 'Raporti i porosive',
    generated: 'Gjeneruar',
    revenueExcludesCancelled: 'Të ardhurat pa porositë e anuluara',
    orders: 'Porositë',
    noOrdersInPeriod: 'Nuk ka porosi në këtë periudhë.',
    productsSold: 'Produktet e shitura',
    product: 'Produkti',
    revenue: 'Të ardhurat',
    orderStatusPending: 'Në pritje',
    orderStatusCompleted: 'Përfunduar',
    orderStatusCancelled: 'Anuluar',
    tableOrder: 'Porosia',
    tableCustomer: 'Klienti',
    tablePhone: 'Telefoni',
    tableProducts: 'Produktet',
    tableTotal: 'Totali',
    tableStatus: 'Statusi',
    tableDate: 'Data',
    tableQty: 'Sasia',
    invoiceTypeSubscription: 'Abonim',
    invoiceTypeMonthly: 'Pagesë mujore',
    periodDaily: 'Ditor',
    periodWeekly: 'Javor',
    periodMonthly: 'Mujor',
    periodYearly: 'Vjetor',
    shareInvoiceText: 'Fatura {number} · {amount}',
    shareReportText: '{business} · {title} · {revenue}',
  );

  static const _de = DocumentL10n._(
    invoiceTitle: 'RECHNUNG',
    billTo: 'RECHNUNGSADRESSE',
    issueDate: 'Ausstellungsdatum',
    billingPeriod: 'Abrechnungszeitraum',
    paymentMethod: 'Zahlungsmethode',
    currency: 'Währung',
    plan: 'Tarif',
    upToProducts: 'Bis zu {count} Produkte',
    description: 'Beschreibung',
    qty: 'Menge',
    amount: 'Betrag',
    totalPaid: 'BEZAHLT GESAMT',
    paid: 'Bezahlt',
    thankYouFooter:
        'Vielen Dank für Ihre Zahlung. Dieses Dokument dient als offizielle Rechnung.',
    ordersReportTitle: 'Bestellbericht',
    generated: 'Erstellt',
    revenueExcludesCancelled: 'Umsatz ohne stornierte Bestellungen',
    orders: 'Bestellungen',
    noOrdersInPeriod: 'Keine Bestellungen in diesem Zeitraum.',
    productsSold: 'Verkaufte Produkte',
    product: 'Produkt',
    revenue: 'Umsatz',
    orderStatusPending: 'Ausstehend',
    orderStatusCompleted: 'Abgeschlossen',
    orderStatusCancelled: 'Storniert',
    tableOrder: 'Bestellung',
    tableCustomer: 'Kunde',
    tablePhone: 'Telefon',
    tableProducts: 'Produkte',
    tableTotal: 'Gesamt',
    tableStatus: 'Status',
    tableDate: 'Datum',
    tableQty: 'Menge',
    invoiceTypeSubscription: 'Abonnement',
    invoiceTypeMonthly: 'Monatliche Zahlung',
    periodDaily: 'Täglich',
    periodWeekly: 'Wöchentlich',
    periodMonthly: 'Monatlich',
    periodYearly: 'Jährlich',
    shareInvoiceText: 'Rechnung {number} · {amount}',
    shareReportText: '{business} · {title} · {revenue}',
  );
}
