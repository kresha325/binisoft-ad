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
  const base = basePrice != null ? Number(basePrice) : 0;
  let unitPrice = base;
  let offerId = null;
  let discountPercent = null;

  for (const offer of offers) {
    if (!isOfferActive(offer)) continue;
    const productIds = offer.productIds || [];
    if (!productIds.includes(productId)) continue;

    const items = offer.items || [];
    const item = items.find((i) => i.productId === productId);
    let candidate = base;

    if (item && item.salePriceEur != null && Number.isFinite(Number(item.salePriceEur))) {
      candidate = roundMoney(Number(item.salePriceEur));
    } else {
      const pct =
        item && item.discountPercent != null
          ? Number(item.discountPercent)
          : offer.discountPercent != null
            ? Number(offer.discountPercent)
            : null;
      if (pct != null && Number.isFinite(pct) && pct > 0) {
        candidate = roundMoney(base * (1 - Math.min(100, Math.max(0, pct)) / 100));
        discountPercent = pct;
      }
    }

    if (candidate < unitPrice) {
      unitPrice = candidate;
      offerId = offer.id;
      if (base > 0 && unitPrice < base) {
        discountPercent = discountPercent ?? roundMoney((1 - unitPrice / base) * 100);
      }
    }
  }

  const onOffer = unitPrice < base && offerId != null;
  return {
    unitPrice,
    originalPrice: base,
    offerId: onOffer ? offerId : null,
    onOffer,
    discountPercent: onOffer ? discountPercent : null,
  };
}

function resolveProductPricing(productData, productId, offers) {
  const base = productData.basePrice != null ? Number(productData.basePrice) : 0;
  return resolveUnitPricing(base, productId, offers);
}

function resolveVariantPricing(variantPrice, productId, offers) {
  return resolveUnitPricing(variantPrice, productId, offers);
}

/**
 * Offer line item pricing for storefront / offers API (always vs catalog base price).
 */
function resolveOfferItemDisplay(productData, item, offer) {
  const base = productData.basePrice != null ? Number(productData.basePrice) : 0;
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

  if (salePrice < base && base > 0) {
    if (discountPercent == null) {
      discountPercent = roundMoney((1 - salePrice / base) * 100);
    }
  } else {
    discountPercent = null;
  }

  const hasDiscount = base > 0 && salePrice < base;
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
  resolveUnitPricing,
  resolveProductPricing,
  resolveVariantPricing,
  resolveOfferItemDisplay,
  loadActiveOffers,
  toMillis,
};
