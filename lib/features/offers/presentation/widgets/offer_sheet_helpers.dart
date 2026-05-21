import '../../../../core/utils/slug.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/offer.dart';
import '../../data/repositories/offer_repository.dart';

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
  return 'Ofertë — ${products.first.name}';
}

/// Stable internal slug for a single-product offer.
String offerSlugForProduct(Product product) {
  final fromProductSlug = slugify('oferte-${product.slug}');
  if (fromProductSlug.isNotEmpty) return fromProductSlug;
  return slugify('oferte-${product.id}');
}

Future<String> uniqueOfferSlug({
  required OfferRepository offerRepo,
  required String businessId,
  required String baseSlug,
  String? excludeOfferId,
}) async {
  var candidate = slugify(baseSlug);
  if (candidate.isEmpty) candidate = 'oferte';
  final root = candidate;
  var n = 0;
  while (await offerRepo.isSlugTaken(
    businessId: businessId,
    slug: candidate,
    excludeOfferId: excludeOfferId,
  )) {
    n += 1;
    candidate = '$root-$n';
  }
  return candidate;
}

OfferItem? offerItemFromDraft(ProductDiscountDraft draft) {
  if (draft.mode == OfferDiscountMode.percent) {
    final pct = draft.percent.clamp(0.0, 100.0);
    if (pct <= 0) return null;
    return OfferItem(productId: draft.product.id, discountPercent: pct);
  }
  final price = draft.salePrice;
  final base = draft.product.basePrice ?? 0;
  if (price == null || price < 0 || price >= base) return null;
  return OfferItem(productId: draft.product.id, salePriceEur: price);
}

/// Product IDs in this offer (`items` first, then legacy `productIds`).
List<String> offerProductIds(Offer offer) {
  final seen = <String>{};
  final out = <String>[];
  void add(String? id) {
    if (id == null || id.isEmpty || seen.contains(id)) return;
    seen.add(id);
    out.add(id);
  }
  for (final item in offer.items) {
    add(item.productId);
  }
  for (final id in offer.productIds) {
    add(id);
  }
  return out;
}

Product? findProductById(List<Product> products, String productId) {
  for (final p in products) {
    if (p.id == productId) return p;
  }
  return null;
}

void populateDraftsFromOffer({
  required Offer offer,
  required List<Product> allProducts,
  required Map<String, ProductDiscountDraft> drafts,
}) {
  for (final productId in offerProductIds(offer)) {
    final product = findProductById(allProducts, productId);
    if (product == null) continue;
    OfferItem? matched;
    for (final i in offer.items) {
      if (i.productId == productId) {
        matched = i;
        break;
      }
    }
    drafts[productId] = ProductDiscountDraft(
      product: product,
      mode: matched?.mode ?? OfferDiscountMode.percent,
      percent: matched?.discountPercent ?? offer.discountPercent ?? 10,
      salePrice: matched?.salePriceEur,
    );
  }
}

Offer? activeOfferContaining(List<Offer> offers, String productId) {
  for (final o in offers) {
    if (!o.active || o.isExpired) continue;
    for (final item in o.items) {
      if (item.productId == productId) return o;
    }
    if (o.productIds.contains(productId)) return o;
  }
  return null;
}
