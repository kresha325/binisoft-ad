const { getFirestore } = require('firebase-admin/firestore');
const siteConfigModule = require('./siteConfig');
const { googleMapsEmbedUrl } = require('./googleMaps');
const { displayLocation } = require('./businessAddress');
const i18n = require('./i18n');
const pricing = require('./pricing');

function publicShopCheckoutFromData(data) {
  const sc =
    data.shopCheckout && typeof data.shopCheckout === 'object' ? data.shopCheckout : {};
  return {
    cartEnabled: sc.cartEnabled !== false,
    customerName: sc.customerName !== false,
    deliveryAddress: sc.deliveryAddress === true || data.offersDelivery === true,
    orderNotes: sc.orderNotes !== false,
    phone: sc.phone !== false,
  };
}

/**
 * Platform shop catalog (same data superadmin manages in Firestore).
 * GET /api/public/businesses | /api/public/marketplace
 */
async function listShopBusinesses() {
  const db = getFirestore();
  const snap = await db.collection('businesses').get();
  const businesses = [];

  for (const doc of snap.docs) {
    const data = doc.data();
    if (data.active === false) continue;
    const slug = (data.slug || '').trim();
    if (!slug) continue;
    businesses.push({
      id: doc.id,
      name: data.name || slug,
      slug,
      description: data.description || '',
      logoUrl: data.logoUrl || '',
      coverImageUrl: data.coverImageUrl || '',
      location: displayLocation(data),
      city: data.city || '',
      state: data.state || '',
      googleMapsUrl: data.googleMapsUrl || '',
      googleMapsEmbedUrl: googleMapsEmbedUrl(data.googleMapsUrl) || '',
      businessType: data.businessType || '',
      siteDeployUrl: data.siteDeployUrl || '',
      siteConfig: siteConfigModule.publicSiteConfig(
        data.siteConfig,
        data.businessType || '',
      ),
      shopCheckout: publicShopCheckoutFromData(data),
    });
  }

  businesses.sort((a, b) => a.name.localeCompare(b.name, 'sq'));
  return { businesses, count: businesses.length };
}

function productImageUrls(data) {
  if (Array.isArray(data.images) && data.images.length > 0) {
    return data.images
      .filter((img) => img && img.active !== false && img.url)
      .map((img) => String(img.url));
  }
  return Array.isArray(data.imageUrls) ? data.imageUrls : [];
}

function serializeMarketplaceProduct(doc, biz, ctx) {
  const d = doc.data();
  if ((d.status || 'draft') !== 'active') return null;
  const priceInfo = pricing.resolveProductPricing(d, doc.id, []);
  return {
    id: doc.id,
    businessId: biz.id,
    businessSlug: biz.slug,
    businessName: biz.name,
    businessLogoUrl: biz.logoUrl || '',
    name: i18n.resolveLocalized({
      primary: d.name,
      i18n: d.nameI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    slug: d.slug || '',
    price: priceInfo.unitPrice,
    originalPrice: priceInfo.onOffer ? priceInfo.originalPrice : null,
    onOffer: priceInfo.onOffer,
    imageUrls: productImageUrls(d),
    categoryIds: d.categoryIds || [],
  };
}

function serializeMarketplaceCategory(doc, biz, ctx) {
  const d = doc.data();
  return {
    id: doc.id,
    businessId: biz.id,
    businessSlug: biz.slug,
    businessName: biz.name,
    name: i18n.resolveLocalized({
      primary: d.name,
      i18n: d.nameI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    slug: d.slug || doc.id,
    description: i18n.resolveLocalized({
      primary: d.description,
      i18n: d.descriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
  };
}

function offerLineItems(offer) {
  if (Array.isArray(offer.items) && offer.items.length > 0) return offer.items;
  return (offer.productIds || [])
    .filter(Boolean)
    .map((productId) => ({
      productId,
      discountPercent: offer.discountPercent ?? undefined,
    }));
}

async function loadVariantsByProductId(db, businessId) {
  const snap = await db.collection(`businesses/${businessId}/productVariants`).get();
  const byProduct = new Map();
  for (const doc of snap.docs) {
    const d = doc.data();
    const productId = d.productId;
    if (!productId) continue;
    if (!byProduct.has(productId)) byProduct.set(productId, []);
    byProduct.get(productId).push({
      price: d.price != null ? Number(d.price) : 0,
      imageUrl: d.imageUrl || null,
    });
  }
  return byProduct;
}

function marketplaceOfferLineItems(offer, productsById, variantsByProduct, ctx) {
  return offerLineItems(offer)
    .map((item) => {
      const d = productsById.get(item.productId);
      if (!d) return null;
      const onOfferHold = !!d.hiddenByOfferId;
      const variants = variantsByProduct.get(item.productId) || [];
      const priceInfo = pricing.resolveOfferItemDisplay(d, item, offer, variants);
      if (!onOfferHold && !priceInfo.hasDiscount) return null;
      let imageUrl = productImageUrls(d)[0] || null;
      if (!imageUrl && variants.length) {
        const withImg = variants.find((v) => v.imageUrl);
        if (withImg) imageUrl = String(withImg.imageUrl);
      }
      return {
        productId: item.productId,
        productName: i18n.resolveLocalized({
          primary: d.name,
          i18n: d.nameI18n,
          locale: ctx.locale,
          defaultLocale: ctx.defaultLocale,
        }),
        imageUrl,
        originalPrice: priceInfo.originalPrice,
        salePrice: priceInfo.salePrice,
        discountPercent: priceInfo.discountPercent,
        onOfferHold,
      };
    })
    .filter(Boolean);
}

function serializeMarketplaceOffer(offer, biz, ctx, productsById, variantsByProduct) {
  if (!pricing.isOfferActive(offer)) return null;
  const items = marketplaceOfferLineItems(offer, productsById, variantsByProduct, ctx);
  if (!items.length) return null;

  return {
    id: offer.id,
    businessId: biz.id,
    businessSlug: biz.slug,
    businessName: biz.name,
    title: i18n.resolveLocalized({
      primary: offer.title,
      i18n: offer.titleI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    description: i18n.resolveLocalized({
      primary: offer.description,
      i18n: offer.descriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    itemCount: items.length,
    items,
    startsAt: offer.startsAt?.toDate?.()?.toISOString?.() || null,
    endsAt: offer.endsAt?.toDate?.()?.toISOString?.() || null,
  };
}

/**
 * Global marketplace feed: all active businesses + full catalog (same limits as /{slug}/products).
 */
async function getMarketplaceSnapshot(req) {
  const ctx = i18n.pickRequestLocale(req, null);
  const db = getFirestore();
  const { businesses: baseBusinesses } = await listShopBusinesses();
  const bizById = new Map(baseBusinesses.map((b) => [b.id, b]));

  const products = [];
  const categories = [];
  const offers = [];
  const businesses = [];

  for (const b of baseBusinesses) {
    const productsCol = db
      .collection(`businesses/${b.id}/products`)
      .where('status', '==', 'active');

    const [pSnap, productCountSnap, cSnap, oSnap] = await Promise.all([
      productsCol.orderBy('createdAt', 'desc').limit(500).get(),
      productsCol.count().get(),
      db.collection(`businesses/${b.id}/categories`).orderBy('name').get(),
      db.collection(`businesses/${b.id}/offers`).where('active', '==', true).get(),
    ]);

    const activeOfferDocs = oSnap.docs
      .map((doc) => ({ id: doc.id, ...doc.data() }))
      .filter((offer) => pricing.isOfferActive(offer));

    const offerProductIds = new Set();
    for (const offer of activeOfferDocs) {
      for (const item of offerLineItems(offer)) {
        if (item.productId) offerProductIds.add(item.productId);
      }
    }

    const offerProductsById = new Map();
    await Promise.all(
      [...offerProductIds].map(async (pid) => {
        const doc = await db.doc(`businesses/${b.id}/products/${pid}`).get();
        if (doc.exists) offerProductsById.set(pid, doc.data());
      }),
    );

    const variantsByProduct =
      offerProductIds.size > 0
        ? await loadVariantsByProductId(db, b.id)
        : new Map();

    const activeOffers = [];
    for (const offer of activeOfferDocs) {
      const row = serializeMarketplaceOffer(
        offer,
        b,
        ctx,
        offerProductsById,
        variantsByProduct,
      );
      if (row) activeOffers.push(row);
    }

    businesses.push({
      ...b,
      productCount: productCountSnap.data().count || 0,
      categoryCount: cSnap.size,
      offerCount: activeOffers.length,
    });

    for (const doc of pSnap.docs) {
      const row = serializeMarketplaceProduct(doc, b, ctx);
      if (row) products.push(row);
    }
    for (const doc of cSnap.docs) {
      categories.push(serializeMarketplaceCategory(doc, b, ctx));
    }
    offers.push(...activeOffers);
  }

  products.sort((a, b) => a.businessName.localeCompare(b.businessName, 'sq'));
  categories.sort((a, b) => a.name.localeCompare(b.name, 'sq'));

  const stats = {
    businessCount: businesses.length,
    productCount: businesses.reduce((s, b) => s + (b.productCount || 0), 0),
    categoryCount: businesses.reduce((s, b) => s + (b.categoryCount || 0), 0),
    offerCount: businesses.reduce((s, b) => s + (b.offerCount || 0), 0),
  };

  return {
    businesses,
    products,
    categories,
    offers,
    stats,
  };
}

module.exports = { listShopBusinesses, getMarketplaceSnapshot };
