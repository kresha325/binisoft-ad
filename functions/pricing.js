/**
 * Resolves catalog and checkout prices when active offers apply.
 */

function roundMoney(n) {
  return Math.round(Number(n) * 100) / 100;
}

function toMillis(ts) {
  if (!ts) return 0;
  if (typeof ts.toMillis === 'function') return ts.toMillis();
  if (ts instanceof Date) return ts.getTime();
  if (typeof ts === 'number') return ts;
  return 0;
}

/**
 * @param {object} offer - Firestore offer document data with `id` set
 * @param {number} [nowMs]
 */
function isOfferActive(offer, nowMs = Date.now()) {
  if (offer.active === false) return false;
  const start = toMillis(offer.startsAt);
  const end = toMillis(offer.endsAt);
  if (!start || !end) return false;
  return nowMs >= start && nowMs <= end;
}

/**
 * @param {object} productData
 * @param {string} productId
 * @param {Array<object>} offers - active offers with `id`
 */
function resolveUnitPricing(basePrice, productId, offers) {
  return resolveProductPricing({ basePrice }, productId, offers, []);
}

/**
 * Best active-offer price for a product (catalog + variants use same rules as /offers).
 */
function resolveProductPricing(productData, productId, offers, variants = []) {
  const base = effectiveBasePrice(productData, variants);
  let unitPrice = base;
  let offerId = null;
  let discountPercent = null;

  for (const offer of offers) {
    if (!isOfferActive(offer)) continue;
    const productIds = offer.productIds || [];
    if (!productIds.includes(productId)) continue;

    const items = offer.items || [];
    const item = items.find((i) => i.productId === productId) || { productId };
    const priceInfo = resolveOfferItemDisplay(productData, item, offer, variants);
    if (!priceInfo.hasDiscount) continue;
    if (priceInfo.salePrice < unitPrice || (base <= 0 && priceInfo.salePrice <= unitPrice)) {
      unitPrice = priceInfo.salePrice;
      offerId = offer.id;
      discountPercent = priceInfo.discountPercent;
    }
  }

  const onOffer = offerId != null && priceInfoHasDiscount(base, unitPrice, discountPercent);
  return {
    unitPrice,
    originalPrice: base,
    offerId: onOffer ? offerId : null,
    onOffer,
    discountPercent: onOffer ? discountPercent : null,
  };
}

function priceInfoHasDiscount(base, unitPrice, discountPercent) {
  if (discountPercent != null && discountPercent > 0) return true;
  return base > 0 && unitPrice < base;
}

function resolveVariantPricing(variantPrice, productId, offers) {
  return resolveProductPricing({ basePrice: variantPrice }, productId, offers, []);
}

/**
 * Catalog-style base for offer math: min variant price when variants exist, else basePrice.
 */
function effectiveBasePrice(productData, variants = []) {
  if (Array.isArray(variants) && variants.length > 0) {
    const prices = variants
      .map((v) => (v.price != null ? Number(v.price) : NaN))
      .filter((n) => Number.isFinite(n) && n >= 0);
    if (prices.length) return Math.min(...prices);
  }
  return productData.basePrice != null ? Number(productData.basePrice) : 0;
}

/**
 * Offer line item pricing for storefront / offers API (matches catalog base logic).
 * @param {object} productData
 * @param {object} item
 * @param {object} offer
 * @param {Array<{ price?: number }>} [variants]
 */
function resolveOfferItemDisplay(productData, item, offer, variants = []) {
  const base = effectiveBasePrice(productData, variants);
  let salePrice = base;
  let discountPercent = null;

  if (item && item.salePriceEur != null && Number.isFinite(Number(item.salePriceEur))) {
    salePrice = roundMoney(Number(item.salePriceEur));
  } else {
    const pct =
      item && item.discountPercent != null
        ? Number(item.discountPercent)
        : offer.discountPercent != null
          ? Number(offer.discountPercent)
          : null;
    if (pct != null && Number.isFinite(pct) && pct > 0) {
      discountPercent = Math.min(100, Math.max(0, pct));
      salePrice = roundMoney(base * (1 - discountPercent / 100));
    }
  }

  const hasExplicitSale =
    item &&
    item.salePriceEur != null &&
    Number.isFinite(Number(item.salePriceEur));

  if (base > 0 && salePrice < base && discountPercent == null && !hasExplicitSale) {
    discountPercent = roundMoney((1 - salePrice / base) * 100);
  }

  const hasDiscount =
    (hasExplicitSale && (base <= 0 || salePrice < base)) ||
    (base > 0 && salePrice < base) ||
    (discountPercent != null && discountPercent > 0);

  return {
    originalPrice: base,
    salePrice: hasDiscount ? salePrice : base,
    discountPercent: hasDiscount ? discountPercent : null,
    hasDiscount,
  };
}

/**
 * @param {import('firebase-admin/firestore').Firestore} db
 * @param {string} businessId
 */
async function loadActiveOffers(db, businessId) {
  const snap = await db
    .collection(`businesses/${businessId}/offers`)
    .where('active', '==', true)
    .get();
  const now = Date.now();
  return snap.docs
    .map((doc) => ({ id: doc.id, ...doc.data() }))
    .filter((offer) => isOfferActive(offer, now));
}

module.exports = {
  roundMoney,
  isOfferActive,
  effectiveBasePrice,
  resolveUnitPricing,
  resolveProductPricing,
  resolveVariantPricing,
  resolveOfferItemDisplay,
  loadActiveOffers,
  toMillis,
};
