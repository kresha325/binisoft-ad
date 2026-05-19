const { getFirestore } = require('firebase-admin/firestore');
const siteConfigModule = require('./siteConfig');
const { googleMapsEmbedUrl } = require('./googleMaps');
const { displayLocation } = require('./businessAddress');
const i18n = require('./i18n');
const pricing = require('./pricing');

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

function serializeMarketplaceOffer(doc, biz, ctx) {
  const od = { id: doc.id, ...doc.data() };
  if (!pricing.isOfferActive(od)) return null;
  const itemCount = (od.items || []).length || (od.productIds || []).length;
  if (itemCount === 0) return null;

  return {
    id: od.id,
    businessId: biz.id,
    businessSlug: biz.slug,
    businessName: biz.name,
    title: i18n.resolveLocalized({
      primary: od.title,
      i18n: od.titleI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    description: i18n.resolveLocalized({
      primary: od.description,
      i18n: od.descriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    itemCount,
    startsAt: od.startsAt?.toDate?.()?.toISOString?.() || null,
    endsAt: od.endsAt?.toDate?.()?.toISOString?.() || null,
  };
}

/**
 * Global marketplace feed: all active businesses + featured catalog slices.
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
    const [pSnap, cSnap, oSnap] = await Promise.all([
      db.collection(`businesses/${b.id}/products`).where('status', '==', 'active').limit(24).get(),
      db.collection(`businesses/${b.id}/categories`).limit(30).get(),
      db.collection(`businesses/${b.id}/offers`).where('active', '==', true).limit(12).get(),
    ]);

    businesses.push({
      ...b,
      productCount: pSnap.size,
      categoryCount: cSnap.size,
      offerCount: oSnap.size,
    });

    for (const doc of pSnap.docs) {
      const row = serializeMarketplaceProduct(doc, b, ctx);
      if (row) products.push(row);
    }
    for (const doc of cSnap.docs) {
      categories.push(serializeMarketplaceCategory(doc, b, ctx));
    }
    for (const doc of oSnap.docs) {
      const row = serializeMarketplaceOffer(doc, b, ctx);
      if (row) offers.push(row);
    }
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
