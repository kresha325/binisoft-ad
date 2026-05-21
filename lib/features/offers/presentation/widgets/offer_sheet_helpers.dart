import '../../../products/domain/entities/product.dart';
import '../../domain/entities/offer.dart';

class ProductDiscountDraft {
  ProductDiscountDraft({
    required this.product,
    this.mode = OfferDiscountMode.percent,
    this.percent = 10,
    this.salePrice,
  });

  final Product product;
  OfferDiscountMode mode;
  double percent;
  double? salePrice;

  static ProductDiscountDraft fromProduct(Product product) {
    final base = product.basePrice ?? 0;
    return ProductDiscountDraft(
      product: product,
      percent: 10,
      salePrice: base > 0 ? (base * 0.9 * 100).round() / 100 : null,
    );
  }

  double? resolvedSalePrice() {
    final base = product.basePrice ?? 0;
    if (mode == OfferDiscountMode.percent) {
      if (base <= 0) return null;
      return (base * (1 - percent.clamp(0, 100) / 100) * 100).round() / 100;
    }
    return salePrice;
  }
}

String offerTitleFromProducts(List<Product> products) {
  if (products.isEmpty) return 'Ofertë';
  if (products.length == 1) return 'Ofertë — ${products.first.name}';
  if (products.length <= 3) {
    return 'Ofertë — ${products.map((p) => p.name).join(', ')}';
  }
  return 'Ofertë — ${products.first.name} +${products.length - 1}';
}

Offer? activeOfferContaining(List<Offer> offers, String productId) {
  for (final o in offers) {
    if (!o.active || o.isExpired) continue;
    if (o.productIds.contains(productId)) return o;
  }
  return null;
}
