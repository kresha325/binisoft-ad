/// Per-business catalog pricing (EUR): €30 registration + €6/month per 100 products.
class BusinessPricing {
  BusinessPricing._();

  static const double registrationPer100Products = 30;
  static const double monthlyPer100Products = 6;
  static const int productsPerPricingUnit = 100;
  static const int minProducts = 100;
  static const int maxProductsPerBusiness = 1000;
  static const bool registrationIncludesFirstMonth = true;

  static double registrationEuroFor(int maxProducts) =>
      (maxProducts / productsPerPricingUnit) * registrationPer100Products;

  static double monthlyEuroFor(int maxProducts) =>
      (maxProducts / productsPerPricingUnit) * monthlyPer100Products;

  static String _euro(double amount) {
    final rounded = amount == amount.roundToDouble()
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return '€$rounded';
  }

  static String registrationLabelFor(int maxProducts) =>
      '${_euro(registrationEuroFor(maxProducts))} registration';

  static String monthlyLabelFor(int maxProducts) =>
      '${_euro(monthlyEuroFor(maxProducts))} / month';

  static String headlineFor(int maxProducts) =>
      '${registrationLabelFor(maxProducts)} · ${monthlyLabelFor(maxProducts)}';

  static String detailFor(int maxProducts) =>
      '${_euro(registrationEuroFor(maxProducts))} to register (includes the first month), '
      'then ${_euro(monthlyEuroFor(maxProducts))} per month for up to $maxProducts products.';
}

/// Platform operator limits (bootstrap superadmin).
abstract final class PlatformLimits {
  static const int superadminMaxBusinesses = 100;
  static const int superadminMaxProducts = 100000;
}

/// Subscription tier: 1 business, up to [maxProducts] in the catalog.
enum BusinessPlan {
  products100(
    maxProducts: 100,
    title: 'Starter',
    summary: 'Ideal for small shops starting their online catalog.',
  ),
  products200(
    maxProducts: 200,
    title: 'Basic',
    summary: 'More room as your catalog grows.',
  ),
  products300(
    maxProducts: 300,
    title: 'Standard',
    summary: 'Balanced capacity for growing inventories.',
  ),
  products400(
    maxProducts: 400,
    title: 'Plus',
    summary: 'Extra headroom for diverse product lines.',
  ),
  products500(
    maxProducts: 500,
    title: 'Pro',
    summary: 'For established stores with large catalogs.',
  ),
  products600(
    maxProducts: 600,
    title: 'Pro+',
    summary: 'Expanded catalog for multi-category retailers.',
  ),
  products700(
    maxProducts: 700,
    title: 'Advanced',
    summary: 'High-volume product management.',
  ),
  products800(
    maxProducts: 800,
    title: 'Advanced+',
    summary: 'Near-maximum catalog capacity.',
  ),
  products900(
    maxProducts: 900,
    title: 'Premium',
    summary: 'Almost unlimited for most businesses.',
  ),
  products1000(
    maxProducts: 1000,
    title: 'Max',
    summary: 'Maximum catalog size — up to 1,000 products per business.',
  );

  const BusinessPlan({
    required this.maxProducts,
    required this.title,
    required this.summary,
  });

  final int maxProducts;
  final String title;
  final String summary;

  /// Businesses per account (each has its own catalog + public API slug).
  int get maxBusinesses => switch (this) {
        BusinessPlan.products100 || BusinessPlan.products200 => 3,
        BusinessPlan.products300 ||
        BusinessPlan.products400 ||
        BusinessPlan.products500 =>
          10,
        _ => 25,
      };

  String get code => '$maxProducts';

  double get registrationEuro => BusinessPricing.registrationEuroFor(maxProducts);

  double get monthlyEuro => BusinessPricing.monthlyEuroFor(maxProducts);

  String get priceLabel => BusinessPricing.monthlyLabelFor(maxProducts);

  String get registrationPriceLabel => BusinessPricing.registrationLabelFor(maxProducts);

  String get pricingHeadline => BusinessPricing.headlineFor(maxProducts);

  String get pricingDetail => BusinessPricing.detailFor(maxProducts);

  String get description =>
      'Up to $maxBusinesses businesses · $maxProducts products each';

  List<String> get features => [
        'Up to $maxBusinesses businesses on your account',
        'Up to $maxProducts products per business',
        '${BusinessPricing.registrationLabelFor(maxProducts)} (1st month included)',
        'Then ${BusinessPricing.monthlyLabelFor(maxProducts)}',
        'Public API, categories & custom fields',
        'Dashboard & API documentation',
      ];

  static BusinessPlan get defaultPlan => BusinessPlan.products100;

  static BusinessPlan fromMaxProducts(int max) {
    final clamped = max.clamp(
      BusinessPricing.minProducts,
      BusinessPricing.maxProductsPerBusiness,
    );
    BusinessPlan? best;
    for (final plan in BusinessPlan.values) {
      if (plan.maxProducts == clamped) return plan;
      if (plan.maxProducts <= clamped) best = plan;
    }
    return best ?? BusinessPlan.products100;
  }

  /// Legacy accounts stored only [maxBusinesses] (1, 10, 100).
  static BusinessPlan fromMaxBusinesses(int maxBusinesses) {
    if (maxBusinesses >= PlatformLimits.superadminMaxBusinesses) {
      return BusinessPlan.products1000;
    }
    if (maxBusinesses >= 10) return BusinessPlan.products500;
    return BusinessPlan.products100;
  }

  static int migrateMaxProducts({int? maxProducts, int? maxBusinesses}) {
    if (maxProducts != null) {
      final clamped = maxProducts < BusinessPricing.minProducts
          ? BusinessPricing.minProducts
          : maxProducts;
      return clamped.clamp(
        BusinessPricing.minProducts,
        BusinessPricing.maxProductsPerBusiness,
      );
    }
    return fromMaxBusinesses(maxBusinesses ?? 1).maxProducts;
  }
}
