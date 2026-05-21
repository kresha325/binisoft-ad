const { onRequest, HttpsError } = require('firebase-functions/v2/https');
const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { initializeApp } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { getStorage } = require('firebase-admin/storage');
const { randomUUID } = require('crypto');
const rateLimit = require('./rateLimit');
const { withCors } = require('./httpCors');
const invoices = require('./invoices');
const { deliverEmail, escapeHtml } = require('./email');
const { logPublicApiError } = require('./apiMonitor');
const { googleMapsEmbedUrl } = require('./googleMaps');
const { displayLocation } = require('./businessAddress');

initializeApp();

const fnOptions = {
  region: 'us-central1',
  // Custom CORS in httpCors.js (GitHub Pages + localhost). Platform cors:true can
  // conflict and omit Access-Control-Allow-Origin on preflight.
  cors: false,
  invoker: 'public',
  maxInstances: 10,
};

async function verifyAuth(req) {
  const header = req.headers.authorization || '';
  if (!header.startsWith('Bearer ')) {
    throw new HttpsError('unauthenticated', 'Missing Authorization header');
  }
  const token = header.slice('Bearer '.length);
  return getAuth().verifyIdToken(token);
}

async function assertBusinessMember(uid, businessId) {
  const db = getFirestore();
  const [userSnap, businessSnap] = await Promise.all([
    db.doc(`users/${uid}`).get(),
    db.doc(`businesses/${businessId}`).get(),
  ]);

  if (!businessSnap.exists) {
    throw new HttpsError('not-found', 'Business not found');
  }

  const isOwner = businessSnap.data().ownerId === uid;
  const isMember = userSnap.exists && userSnap.data().businessId === businessId;

  if (!isOwner && !isMember) {
    throw new HttpsError('permission-denied', 'Not allowed for this business');
  }
}

async function uploadToStorage({ storagePath, fileName, contentType, base64 }) {
  const buffer = Buffer.from(base64, 'base64');
  if (buffer.length === 0) {
    throw new HttpsError('invalid-argument', 'Empty file');
  }
  if (buffer.length > 9 * 1024 * 1024) {
    throw new HttpsError('invalid-argument', 'File too large (max 9MB)');
  }

  const bucket = getStorage().bucket();
  const file = bucket.file(storagePath);
  const token = randomUUID();

  await file.save(buffer, {
    metadata: {
      contentType: contentType || 'image/jpeg',
      metadata: {
        firebaseStorageDownloadTokens: token,
        originalFileName: fileName,
      },
    },
  });

  const encodedPath = encodeURIComponent(storagePath);
  const downloadUrl =
    `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodedPath}?alt=media&token=${token}`;

  return { downloadUrl };
}

function sendError(res, err) {
  const code = err instanceof HttpsError ? err.code : 'internal';
  const status =
    code === 'unauthenticated'
      ? 401
      : code === 'permission-denied'
        ? 403
        : code === 'invalid-argument'
          ? 400
          : code === 'not-found'
            ? 404
            : code === 'resource-exhausted'
              ? 429
              : 500;
  res.status(status).json({
    error: { message: err.message || 'Upload failed', code },
  });
}

async function handleUploadProductImage(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const decoded = await verifyAuth(req);
    const { businessId, productId, fileName, contentType, base64 } = req.body || {};

    if (!businessId || !productId || !fileName || !base64) {
      throw new HttpsError('invalid-argument', 'Missing upload fields');
    }

    await assertBusinessMember(decoded.uid, businessId);

    const storagePath =
      `businesses/${businessId}/products/${productId}/${Date.now()}_${fileName}`;

    const result = await uploadToStorage({ storagePath, fileName, contentType, base64 });
    res.status(200).json(result);
  } catch (err) {
    sendError(res, err);
  }
}

async function handleUploadBusinessLogo(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const decoded = await verifyAuth(req);
    const { businessId, fileName, contentType, base64 } = req.body || {};

    if (!businessId || !fileName || !base64) {
      throw new HttpsError('invalid-argument', 'Missing upload fields');
    }

    await assertBusinessMember(decoded.uid, businessId);

    const storagePath = `businesses/${businessId}/logo/${Date.now()}_${fileName}`;

    const result = await uploadToStorage({ storagePath, fileName, contentType, base64 });
    res.status(200).json(result);
  } catch (err) {
    sendError(res, err);
  }
}

async function handleUploadSiteAsset(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const decoded = await verifyAuth(req);
    const { businessId, fileName, contentType, base64 } = req.body || {};

    if (!businessId || !fileName || !base64) {
      throw new HttpsError('invalid-argument', 'Missing upload fields');
    }

    await assertBusinessMember(decoded.uid, businessId);

    const storagePath = `businesses/${businessId}/site/${Date.now()}_${fileName}`;

    const result = await uploadToStorage({ storagePath, fileName, contentType, base64 });
    res.status(200).json(result);
  } catch (err) {
    sendError(res, err);
  }
}

async function handleUploadBusinessCover(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const decoded = await verifyAuth(req);
    const { businessId, fileName, contentType, base64 } = req.body || {};

    if (!businessId || !fileName || !base64) {
      throw new HttpsError('invalid-argument', 'Missing upload fields');
    }

    await assertBusinessMember(decoded.uid, businessId);

    const storagePath = `businesses/${businessId}/cover/${Date.now()}_${fileName}`;

    const result = await uploadToStorage({ storagePath, fileName, contentType, base64 });
    res.status(200).json(result);
  } catch (err) {
    sendError(res, err);
  }
}

async function handleUploadBusinessBackground(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const decoded = await verifyAuth(req);
    const { businessId, fileName, contentType, base64 } = req.body || {};

    if (!businessId || !fileName || !base64) {
      throw new HttpsError('invalid-argument', 'Missing upload fields');
    }

    await assertBusinessMember(decoded.uid, businessId);

    const storagePath = `businesses/${businessId}/background/${Date.now()}_${fileName}`;

    const result = await uploadToStorage({ storagePath, fileName, contentType, base64 });
    res.status(200).json(result);
  } catch (err) {
    sendError(res, err);
  }
}

// --- Public catalog API (no auth) ---

function requestPath(req) {
  const raw = req.path || req.url || '/';
  return raw.split('?')[0];
}

async function findBusinessBySlug(slug) {
  const db = getFirestore();
  const snap = await db
    .collection('businesses')
    .where('slug', '==', slug)
    .limit(1)
    .get();

  if (snap.empty) {
    throw new HttpsError('not-found', 'Business not found');
  }

  const doc = snap.docs[0];
  const data = doc.data();
  if (data.active === false) {
    throw new HttpsError('not-found', 'Business not found');
  }
  return { id: doc.id, ...data };
}

const superadminDelete = require('./superadminDelete');
const { assertPlatformAdmin } = superadminDelete;
const { handleSuperadminDeleteContent } = superadminDelete.createSuperadminDeleteHandlers({
  verifyAuth,
  sendError,
});
const autoTranslate = require('./autoTranslate');
const { handleAutoTranslateCatalog } = autoTranslate.createAutoTranslateHandlers({
  verifyAuth,
  assertBusinessMember,
  sendError,
});

/** Mirrors lib/core/constants/business_plans.dart — only these limits may be set via API. */
const SUBSCRIPTION_PLANS_BY_MAX_PRODUCTS = {
  100: { maxProducts: 100, maxBusinesses: 3 },
  200: { maxProducts: 200, maxBusinesses: 3 },
  300: { maxProducts: 300, maxBusinesses: 10 },
  400: { maxProducts: 400, maxBusinesses: 10 },
  500: { maxProducts: 500, maxBusinesses: 10 },
  600: { maxProducts: 600, maxBusinesses: 25 },
  700: { maxProducts: 700, maxBusinesses: 25 },
  800: { maxProducts: 800, maxBusinesses: 25 },
  900: { maxProducts: 900, maxBusinesses: 25 },
  1000: { maxProducts: 1000, maxBusinesses: 25 },
};

async function handleUpdateSubscriptionPlan(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const decoded = await verifyAuth(req);
    const maxProducts = Number(req.body?.maxProducts);
    const plan = SUBSCRIPTION_PLANS_BY_MAX_PRODUCTS[maxProducts];
    if (!plan) {
      throw new HttpsError('invalid-argument', 'Invalid subscription plan');
    }

    const db = getFirestore();
    const uid = decoded.uid;
    const userRef = db.doc(`users/${uid}`);
    const userSnap = await userRef.get();
    if (!userSnap.exists) {
      throw new HttpsError('not-found', 'User profile not found');
    }

    const businessId = userSnap.data().businessId || '';
    if (businessId) {
      const productsCol = db.collection(`businesses/${businessId}/products`);
      const countSnap = await productsCol.count().get();
      const productCount = countSnap.data().count || 0;
      if (productCount > plan.maxProducts) {
        throw new HttpsError(
          'failed-precondition',
          `This business has ${productCount} products. Remove ${productCount - plan.maxProducts} or choose a higher plan.`,
        );
      }
    }

    await userRef.update({
      maxProducts: plan.maxProducts,
      maxBusinesses: plan.maxBusinesses,
    });

    res.status(200).json({ ok: true, ...plan });
  } catch (err) {
    sendError(res, err);
  }
}

async function handleSuperadminDeleteUser(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const decoded = await verifyAuth(req);
    await assertPlatformAdmin(decoded);

    const targetUid = req.body?.targetUid;
    if (!targetUid || typeof targetUid !== 'string') {
      throw new HttpsError('invalid-argument', 'targetUid is required');
    }
    if (targetUid === decoded.uid) {
      throw new HttpsError('failed-precondition', 'Cannot delete your own account here');
    }

    await getAuth().deleteUser(targetUid);
    await getFirestore().doc(`users/${targetUid}`).delete().catch(() => {});

    res.status(200).json({ ok: true });
  } catch (err) {
    sendError(res, err);
  }
}

function serializeCategory(doc, ctx) {
  const d = doc.data();
  return {
    id: doc.id,
    name: i18n.resolveLocalized({
      primary: d.name,
      i18n: d.nameI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    slug: d.slug || '',
    urlSlug: i18n.resolveUrlSlug(d, ctx.locale),
    localizedSlugs: i18n.parseI18nMap(d.localizedSlugs),
    description: i18n.resolveLocalized({
      primary: d.description,
      i18n: d.descriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    seoTitle: i18n.resolveLocalized({
      primary: d.seoTitle,
      i18n: d.seoTitleI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    seoDescription: i18n.resolveLocalized({
      primary: d.seoDescription,
      i18n: d.seoDescriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
  };
}

function serializeService(doc, ctx) {
  const d = doc.data();
  if (d.active === false) return null;
  return {
    id: doc.id,
    name: i18n.resolveLocalized({
      primary: d.name,
      i18n: d.nameI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    slug: d.slug || '',
    description: i18n.resolveLocalized({
      primary: d.description,
      i18n: d.descriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    durationMinutes:
      d.durationMinutes != null ? Number(d.durationMinutes) : null,
    priceEur: d.priceEur != null ? Number(d.priceEur) : null,
    active: true,
    order: d.order != null ? Number(d.order) : 0,
  };
}

function serializeAttribute(doc, ctx) {
  const d = doc.data();
  const name = i18n.resolveLocalized({
    primary: d.name,
    i18n: d.nameI18n,
    locale: ctx.locale,
    defaultLocale: ctx.defaultLocale,
  });
  return {
    id: doc.id,
    name,
    key: d.key || name,
    type: d.type || 'text',
    required: d.required === true,
    options: d.options || [],
    active: d.active !== false,
  };
}

function formatAttributeDisplay(value, type) {
  if (value == null) return '';
  if (type === 'boolean') return value === true ? 'Yes' : 'No';
  if (Array.isArray(value)) return value.join(', ');
  if (type === 'color' && typeof value === 'object' && value !== null) {
    const name = value.name || '';
    const hex = value.hex || value.color || '';
    if (name && hex) return `${name} (${hex})`;
    return name || hex || '';
  }
  return String(value);
}

const pricing = require('./pricing');

function serializeVariant(doc) {
  const d = doc.data();
  return {
    id: doc.id,
    sku: d.sku || '',
    price: d.price != null ? Number(d.price) : 0,
    quantity: d.quantity != null ? Number(d.quantity) : 0,
    imageUrl: d.imageUrl || null,
    attributes: d.attributes || {},
  };
}

function activeProductImageUrls(data) {
  if (Array.isArray(data.images) && data.images.length > 0) {
    return data.images
      .filter((img) => img && img.active !== false && img.url)
      .map((img) => String(img.url));
  }
  return Array.isArray(data.imageUrls) ? data.imageUrls : [];
}

function enrichVariantsWithOffers(variants, productId, activeOffers) {
  return variants.map((v) => {
    const priceInfo = pricing.resolveVariantPricing(v.price, productId, activeOffers);
    return {
      ...v,
      price: priceInfo.unitPrice,
      originalPrice: priceInfo.onOffer ? priceInfo.originalPrice : null,
      onOffer: priceInfo.onOffer,
      offerId: priceInfo.offerId,
      discountPercent: priceInfo.discountPercent,
    };
  });
}

async function loadVariantsByProductId(db, businessId) {
  const snap = await db.collection(`businesses/${businessId}/productVariants`).get();
  const byProduct = new Map();
  for (const doc of snap.docs) {
    const productId = doc.data().productId;
    if (!productId) continue;
    if (!byProduct.has(productId)) byProduct.set(productId, []);
    byProduct.get(productId).push(serializeVariant(doc));
  }
  for (const list of byProduct.values()) {
    list.sort((a, b) => String(a.sku).localeCompare(String(b.sku)));
  }
  return byProduct;
}

function serializeProduct(doc, attributeDefs, ctx, activeOffers = [], variants = []) {
  const d = doc.data();
  const attributeData = d.attributeData || {};
  const attributes = {};

  for (const def of attributeDefs) {
    if (!Object.prototype.hasOwnProperty.call(attributeData, def.key)) continue;
    const value = attributeData[def.key];
    attributes[def.key] = {
      label: def.name,
      type: def.type,
      value,
      display: formatAttributeDisplay(value, def.type),
    };
  }

  for (const key of Object.keys(attributeData)) {
    if (attributes[key]) continue;
    attributes[key] = {
      label: key,
      type: 'text',
      value: attributeData[key],
      display: formatAttributeDisplay(attributeData[key], 'text'),
    };
  }

  const rawVariants = Array.isArray(variants) ? variants : [];
  const variantList = enrichVariantsWithOffers(rawVariants, doc.id, activeOffers);
  const priceInfo =
    variantList.length > 0
      ? (() => {
          const minVariant = variantList.reduce((best, v) =>
            v.price < best.price ? v : best,
          );
          return {
            unitPrice: minVariant.price,
            originalPrice: minVariant.onOffer ? minVariant.originalPrice : null,
            onOffer: minVariant.onOffer,
            offerId: minVariant.offerId,
            discountPercent: minVariant.discountPercent,
          };
        })()
      : pricing.resolveProductPricing(d, doc.id, activeOffers);
  const totalVariantQty = variantList.reduce((sum, v) => sum + (v.quantity || 0), 0);
  const quantity =
    variantList.length > 0 ? totalVariantQty : d.baseQuantity ?? 0;

  return {
    id: doc.id,
    name: i18n.resolveLocalized({
      primary: d.name,
      i18n: d.nameI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    slug: d.slug || '',
    urlSlug: i18n.resolveUrlSlug(d, ctx.locale),
    localizedSlugs: i18n.parseI18nMap(d.localizedSlugs),
    description: i18n.resolveLocalized({
      primary: d.description,
      i18n: d.descriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    seoTitle: i18n.resolveLocalized({
      primary: d.seoTitle,
      i18n: d.seoTitleI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    seoDescription: i18n.resolveLocalized({
      primary: d.seoDescription,
      i18n: d.seoDescriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    price: priceInfo.unitPrice,
    originalPrice: priceInfo.onOffer ? priceInfo.originalPrice : null,
    onOffer: priceInfo.onOffer,
    offerId: priceInfo.offerId,
    discountPercent: priceInfo.discountPercent,
    quantity,
    status: d.status || 'draft',
    imageUrls: activeProductImageUrls(d),
    categoryIds: d.categoryIds || [],
    attributeData,
    attributes,
    variants: variantList,
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

function serializeOffer(offer, productsById, ctx, variantsByProduct = new Map()) {
  const items = offerLineItems(offer)
    .map((item) => {
      const entry = productsById.get(item.productId);
      if (!entry) return null;
      const { data: d } = entry;
      if (d.status !== 'active') return null;
      const variants = variantsByProduct.get(item.productId) || [];
      const priceInfo = pricing.resolveOfferItemDisplay(d, item, offer, variants);
      if (!priceInfo.hasDiscount) return null;
      return {
        productId: item.productId,
        productName: i18n.resolveLocalized({
          primary: d.name,
          i18n: d.nameI18n,
          locale: ctx.locale,
          defaultLocale: ctx.defaultLocale,
        }),
        originalPrice: priceInfo.originalPrice,
        salePrice: priceInfo.salePrice,
        discountPercent: priceInfo.discountPercent,
      };
    })
    .filter(Boolean);

  const od = offer;
  const startsAt = od.startsAt;
  const endsAt = od.endsAt;
  return {
    id: od.id,
    slug: od.slug || '',
    urlSlug: i18n.resolveUrlSlug(od, ctx.locale),
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
    seoTitle: i18n.resolveLocalized({
      primary: od.seoTitle,
      i18n: od.seoTitleI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    seoDescription: i18n.resolveLocalized({
      primary: od.seoDescription,
      i18n: od.seoDescriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    durationDays: od.durationDays ?? null,
    startsAt: startsAt?.toDate?.()?.toISOString?.() || null,
    endsAt: endsAt?.toDate?.()?.toISOString?.() || null,
    items,
  };
}

const siteConfigModule = require('./siteConfig');

function publicShopCheckout(business) {
  const sc = business.shopCheckout && typeof business.shopCheckout === 'object'
    ? business.shopCheckout
    : {};
  const deliveryAddress =
    sc.deliveryAddress === true || business.offersDelivery === true;
  return {
    cartEnabled: sc.cartEnabled !== false,
    customerName: sc.customerName !== false,
    deliveryAddress,
    orderNotes: sc.orderNotes !== false,
    phone: sc.phone !== false,
  };
}

function businessPayload(business, slug, ctx) {
  return {
    name: i18n.resolveLocalized({
      primary: business.name,
      i18n: business.nameI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    slug: business.slug || slug,
    urlSlug: i18n.resolveUrlSlug({ slug: business.slug || slug, localizedSlugs: business.localizedSlugs }, ctx.locale),
    localizedSlugs: i18n.parseI18nMap(business.localizedSlugs),
    description: i18n.resolveLocalized({
      primary: business.description,
      i18n: business.descriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    seoTitle: i18n.resolveLocalized({
      primary: business.seoTitle,
      i18n: business.seoTitleI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    seoDescription: i18n.resolveLocalized({
      primary: business.seoDescription,
      i18n: business.seoDescriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    logoUrl: business.logoUrl || '',
    coverImageUrl: business.coverImageUrl || '',
    location: displayLocation(business),
    city: business.city || '',
    state: business.state || '',
    postalCode: business.postalCode || '',
    googleMapsUrl: business.googleMapsUrl || '',
    googleMapsEmbedUrl: googleMapsEmbedUrl(business.googleMapsUrl) || '',
    businessType: business.businessType || '',
    website: business.website || '',
    orderPhone: business.orderPhone || business.settings?.orderPhone || '',
    contactEmail: business.contactEmail || '',
    aboutBio: business.aboutBio || '',
    openingHours: business.openingHours || '',
    shopCheckout: publicShopCheckout(business),
    siteConfig: siteConfigModule.publicSiteConfig(
      business.siteConfig,
      business.businessType || '',
    ),
  };
}

async function loadAttributeDefs(businessId, ctx) {
  const db = getFirestore();
  const snap = await db
    .collection(`businesses/${businessId}/attributes`)
    .where('active', '==', true)
    .get();
  return snap.docs.map((doc) => serializeAttribute(doc, ctx));
}

const publicOrders = require('./publicOrders');
const i18n = require('./i18n');
const shopCatalog = require('./shopCatalog');

async function handlePublicApi(req, res) {
  const ip = rateLimit.clientIp(req);
  const path = requestPath(req);
  const orderDetailMatch = path.match(
    /\/api\/(?:public|shop)\/([^/]+)\/orders\/([^/]+)(\/cancel)?\/?$/,
  );
  if (orderDetailMatch) {
    const slug = decodeURIComponent(orderDetailMatch[1]);
    const orderId = decodeURIComponent(orderDetailMatch[2]);
    const isCancel = orderDetailMatch[3] === '/cancel';
    const ctx = { slug, orderId, findBusinessBySlug, sendError };
    if (isCancel) {
      return publicOrders.handlePublicCancelOrder(req, res, ctx);
    }
    return publicOrders.handlePublicGetOrder(req, res, ctx);
  }

  if (/\/api\/(?:public|shop)\/checkout\/?$/.test(path)) {
    return publicOrders.handlePublicCheckoutBatch(req, res, {
      findBusinessBySlug,
      sendError,
    });
  }

  if (/\/api\/public\/[^/]+\/orders\/?$/.test(path)) {
    return publicOrders.handlePublicCreateOrder(req, res, {
      findBusinessBySlug,
      sendError,
    });
  }

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'GET') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  if (/\/api\/(?:public|shop)\/businesses\/?$/.test(path)) {
    try {
      rateLimit.checkRateLimit(`shop-businesses:${ip}`, { max: 120, windowMs: 60_000 });
      const payload = await shopCatalog.listShopBusinesses();
      res.status(200).json({
        meta: i18n.apiMeta(i18n.pickRequestLocale(req, null)),
        ...payload,
      });
    } catch (err) {
      sendError(res, err);
    }
    return;
  }

  if (/\/api\/(?:public|shop)\/marketplace\/?$/.test(path)) {
    try {
      rateLimit.checkRateLimit(`shop-marketplace:${ip}`, { max: 60, windowMs: 60_000 });
      const payload = await shopCatalog.getMarketplaceSnapshot(req);
      res.status(200).json({
        meta: i18n.apiMeta(i18n.pickRequestLocale(req, null)),
        ...payload,
      });
    } catch (err) {
      sendError(res, err);
    }
    return;
  }

  let slug;
  let resource;
  let productId;
  try {
    const match = path.match(
      /\/api\/(?:public|shop)\/([^/]+)\/(products|categories|offers|services|business)(?:\/([^/]+))?$/,
    );

    if (match) {
      slug = decodeURIComponent(match[1]);
      resource = match[2];
      productId = match[3] ? decodeURIComponent(match[3]) : null;
    } else {
      slug = req.query.slug;
      resource = req.query.resource;
      productId = req.query.productId || null;
    }

    if (!slug || !resource) {
      res.status(404).json({
        error: {
          message:
            'Not found. Use /api/shop/{slug}/products or /api/shop/businesses',
        },
      });
      return;
    }

    const business = await findBusinessBySlug(slug);
    const businessId = business.id;
    const db = getFirestore();
    const localeCtx = i18n.pickRequestLocale(req, business);

    if (resource === 'business') {
      res.status(200).json({
        meta: i18n.apiMeta(localeCtx),
        business: businessPayload(business, slug, localeCtx),
      });
      return;
    }

    if (resource === 'categories') {
      const catSnap = await db
        .collection(`businesses/${businessId}/categories`)
        .orderBy('name')
        .get();
      res.status(200).json({
        meta: i18n.apiMeta(localeCtx),
        business: businessPayload(business, slug, localeCtx),
        categories: catSnap.docs.map((doc) => serializeCategory(doc, localeCtx)),
      });
      return;
    }

    if (resource === 'services') {
      const svcSnap = await db
        .collection(`businesses/${businessId}/services`)
        .orderBy('order')
        .get();
      const services = svcSnap.docs
        .map((doc) => serializeService(doc, localeCtx))
        .filter(Boolean);
      res.status(200).json({
        meta: i18n.apiMeta(localeCtx),
        business: businessPayload(business, slug, localeCtx),
        services,
        serviceCount: services.length,
      });
      return;
    }

    if (resource === 'offers') {
      const offersSnap = await db
        .collection(`businesses/${businessId}/offers`)
        .where('active', '==', true)
        .get();

      const activeOffers = offersSnap.docs
        .map((doc) => ({ id: doc.id, ...doc.data() }))
        .filter((offer) => pricing.isOfferActive(offer));

      const productIdSet = new Set();
      for (const offer of activeOffers) {
        for (const id of offer.productIds || []) productIdSet.add(id);
        for (const item of offer.items || []) {
          if (item.productId) productIdSet.add(item.productId);
        }
      }

      const productsById = new Map();
      await Promise.all(
        [...productIdSet].map(async (pid) => {
          const doc = await db.doc(`businesses/${businessId}/products/${pid}`).get();
          if (doc.exists) {
            productsById.set(pid, { doc, data: doc.data() });
          }
        }),
      );

      const variantsByProduct = await loadVariantsByProductId(db, businessId);

      res.status(200).json({
        meta: i18n.apiMeta(localeCtx),
        business: businessPayload(business, slug, localeCtx),
        offers: activeOffers
          .map((offer) => serializeOffer(offer, productsById, localeCtx, variantsByProduct))
          .filter((o) => o.items.length > 0),
      });
      return;
    }

    if (resource !== 'products') {
      res.status(404).json({ error: { message: 'Unknown resource' } });
      return;
    }

    const customFields = await loadAttributeDefs(businessId, localeCtx);
    const activeOffers = await pricing.loadActiveOffers(db, businessId);
    const variantsByProduct = await loadVariantsByProductId(db, businessId);

    if (productId) {
      const doc = await db.doc(`businesses/${businessId}/products/${productId}`).get();
      if (!doc.exists || doc.data().status !== 'active') {
        throw new HttpsError('not-found', 'Product not found');
      }
      res.status(200).json({
        meta: i18n.apiMeta(localeCtx),
        business: businessPayload(business, slug, localeCtx),
        customFields,
        product: serializeProduct(
          doc,
          customFields,
          localeCtx,
          activeOffers,
          variantsByProduct.get(doc.id) || [],
        ),
      });
      return;
    }

    const [productsSnap, categoriesSnap] = await Promise.all([
      db
        .collection(`businesses/${businessId}/products`)
        .where('status', '==', 'active')
        .orderBy('createdAt', 'desc')
        .limit(500)
        .get(),
      db.collection(`businesses/${businessId}/categories`).orderBy('name').get(),
    ]);

    const categories = categoriesSnap.docs.map((doc) =>
      serializeCategory(doc, localeCtx),
    );
    const categoryNames = Object.fromEntries(categories.map((c) => [c.id, c.name]));

    const products = productsSnap.docs.map((doc) => {
      const p = serializeProduct(
        doc,
        customFields,
        localeCtx,
        activeOffers,
        variantsByProduct.get(doc.id) || [],
      );
      p.categories = (p.categoryIds || []).map((id) => categoryNames[id] || id);
      return p;
    });

    res.status(200).json({
      meta: i18n.apiMeta(localeCtx),
      business: businessPayload(business, slug, localeCtx),
      customFields,
      categories,
      products,
      productCount: products.length,
    });
  } catch (err) {
    const code = err instanceof HttpsError ? err.code : 'internal';
    const status =
      code === 'unauthenticated'
        ? 401
        : code === 'permission-denied'
          ? 403
          : code === 'invalid-argument'
            ? 400
            : code === 'not-found'
              ? 404
              : code === 'resource-exhausted'
                ? 429
                : 500;
    logPublicApiError({
      slug: slug || '',
      resource: resource || '',
      method: req.method,
      statusCode: status,
      code,
      message: err.message,
    });
    sendError(res, err);
  }
}

const SUPERADMIN_EMAIL = 'kreshnik.sh.gashi@hotmail.com';

async function listSuperAdminUids() {
  const db = getFirestore();
  const byRole = await db.collection('users').where('role', '==', 'superadmin').get();
  if (!byRole.empty) {
    return byRole.docs.map((d) => d.id);
  }
  const byEmail = await db.collection('users').where('email', '==', SUPERADMIN_EMAIL).get();
  return byEmail.docs.map((d) => d.id);
}

async function pushNotification(userId, payload) {
  const data = {
    type: payload.type,
    title: payload.title,
    body: payload.body,
    read: false,
    createdAt: FieldValue.serverTimestamp(),
  };
  if (payload.businessId) data.businessId = payload.businessId;
  if (payload.actionRoute) data.actionRoute = payload.actionRoute;
  await getFirestore().collection(`users/${userId}/notifications`).add(data);
}

async function notifyAllSuperadmins(payload) {
  const uids = await listSuperAdminUids();
  await Promise.all(uids.map((uid) => pushNotification(uid, payload)));
}

const firestoreTriggerOptions = { region: 'us-central1' };

async function handlePlatformNotify(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  const allowedTypes = new Set([
    'platform.user.registered',
    'platform.business.created',
  ]);

  try {
    const decoded = await verifyAuth(req);
    await assertPlatformAdmin(decoded);
    const { type, title, body, businessId, actionRoute } = req.body || {};
    if (!type || !title || !body || !allowedTypes.has(type)) {
      throw new HttpsError('invalid-argument', 'Invalid platform notification payload');
    }
    await notifyAllSuperadmins({
      type,
      title,
      body,
      businessId: businessId || undefined,
      actionRoute: actionRoute || '/superadmin',
    });
    res.status(200).json({ ok: true });
  } catch (err) {
    sendError(res, err);
  }
}

exports.platformNotifyHttp = onRequest(fnOptions, withCors(handlePlatformNotify));

const EMAIL_FROM = process.env.EMAIL_FROM || 'noreply@jon-sport.firebaseapp.com';

const EMAIL_TEMPLATES = {
  welcome: (v) => ({
    subject: 'Welcome to Binisoft Admin',
    html: `<p>Hi${v.name ? ` ${escapeHtml(v.name)}` : ''},</p>
<p>Your Binisoft Admin account is ready. Create your first business to start managing your catalog.</p>
<p><a href="https://kresha325.github.io/binisoft-ad/app/#/login">Open dashboard</a></p>`,
  }),
  plan_updated: (v) => ({
    subject: 'Plan updated — Binisoft Admin',
    html: `<p>Your subscription is now on the <strong>${escapeHtml(v.planLabel || 'updated')}</strong> plan.</p>
<p>Manage billing in Settings.</p>`,
  }),
  business_created: (v) => ({
    subject: 'Business created — Binisoft Admin',
    html: `<p>Your business <strong>${escapeHtml(v.businessName || 'New business')}</strong> is ready.</p>
<p>Add products and categories from the dashboard.</p>`,
  }),
  platform_new_user: (v) => ({
    subject: 'New user registered — Binisoft Admin',
    html: `<p><strong>${escapeHtml(v.email || 'unknown')}</strong> created an admin account on the platform.</p>
<p>Review users in the superadmin panel.</p>`,
  }),
};

const EMAIL_PREF_BY_TEMPLATE = {
  welcome: 'accountAlerts',
  plan_updated: 'planUpdates',
  business_created: 'businessUpdates',
};

async function handleSendEmail(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  res.status(200).json({ ok: true, skipped: 'email_disabled' });
  return;

  try {
    const decoded = await verifyAuth(req);
    const { template, variables = {}, toEmail } = req.body || {};
    const build = EMAIL_TEMPLATES[template];
    if (!build) {
      throw new HttpsError('invalid-argument', 'Unknown email template');
    }

    let recipient;
    if (template === 'platform_new_user') {
      // Always platform inbox; ignore client toEmail (prevents abuse).
      recipient = SUPERADMIN_EMAIL;
    } else {
      if (toEmail != null && toEmail !== '' && toEmail !== decoded.email) {
        throw new HttpsError('invalid-argument', 'Custom recipient not allowed');
      }
      const prefKey = EMAIL_PREF_BY_TEMPLATE[template];
      const userSnap = await getFirestore().doc(`users/${decoded.uid}`).get();
      const userData = userSnap.exists ? userSnap.data() : {};
      const prefs = userData.emailPrefs || {};
      if (prefKey && prefs[prefKey] === false) {
        res.status(200).json({ ok: true, skipped: 'prefs' });
        return;
      }
      recipient = decoded.email || userData.email;
      if (!recipient) {
        throw new HttpsError('failed-precondition', 'No email on account');
      }
    }

    const { subject, html } = build(variables);
    const result = await deliverEmail({ to: recipient, subject, html });
    res.status(200).json({ ok: true, ...result });
  } catch (err) {
    sendError(res, err);
  }
}

exports.sendEmailHttp = onRequest(fnOptions, withCors(handleSendEmail));

exports.onUserCreatedNotifySuperadmins = onDocumentCreated(
  { document: 'users/{userId}', ...firestoreTriggerOptions },
  async (event) => {
    const data = event.data?.data();
    if (!data || data.role === 'superadmin') return;

    const email = data.email || 'unknown';
    await notifyAllSuperadmins({
      type: 'platform.user.registered',
      title: 'New user registered',
      body: `${email} created an admin account.`,
      actionRoute: '/superadmin',
    });
  },
);

exports.onBusinessCreatedNotifySuperadmins = onDocumentCreated(
  { document: 'businesses/{businessId}', ...firestoreTriggerOptions },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;

    const businessId = event.params.businessId;
    const name = data.name || 'Business';
    await notifyAllSuperadmins({
      type: 'platform.business.created',
      title: 'New business',
      body: `"${name}" was created on the platform.`,
      businessId,
      actionRoute: '/superadmin',
    });
  },
);

// New HTTP endpoints (CORS + localhost). Old callable names must be deleted in Firebase first.
exports.uploadProductImageHttp = onRequest(fnOptions, withCors(handleUploadProductImage));
exports.uploadBusinessLogoHttp = onRequest(fnOptions, withCors(handleUploadBusinessLogo));
exports.uploadBusinessCoverHttp = onRequest(fnOptions, withCors(handleUploadBusinessCover));
exports.uploadSiteAssetHttp = onRequest(fnOptions, withCors(handleUploadSiteAsset));
exports.uploadBusinessBackgroundHttp = onRequest(
  fnOptions,
  withCors(handleUploadBusinessBackground),
);

const siteDeploy = require('./siteDeploy');
exports.deployBusinessSiteHttp = onRequest(
  fnOptions,
  withCors((req, res) =>
    siteDeploy.handleDeployBusinessSite(req, res, {
      verifyAuth,
      assertBusinessMember,
      sendError,
    }),
  ),
);
exports.publicApi = onRequest(fnOptions, withCors(handlePublicApi));
/** Same handler — shop app uses /api/shop/* routes (platform catalog). */
exports.shopApi = onRequest(fnOptions, withCors(handlePublicApi));
exports.superadminDeleteUserHttp = onRequest(fnOptions, withCors(handleSuperadminDeleteUser));
exports.superadminDeleteContentHttp = onRequest(
  fnOptions,
  withCors(handleSuperadminDeleteContent),
);
exports.autoTranslateCatalogHttp = onRequest(fnOptions, withCors(handleAutoTranslateCatalog));
exports.updateSubscriptionPlanHttp = onRequest(fnOptions, withCors(handleUpdateSubscriptionPlan));

/** Dev/demo: create API key + set orderPhone. Header: x-demo-setup: jon-sport-demo-2026 */
async function handleDevBootstrapShop(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }
  if (process.env.ENABLE_DEMO_BOOTSTRAP !== 'true') {
    res.status(404).json({ error: { message: 'Not found' } });
    return;
  }
  const setupSecret = process.env.DEMO_BOOTSTRAP_SECRET || '';
  if (!setupSecret || req.headers['x-demo-setup'] !== setupSecret) {
    res.status(403).json({ error: { message: 'Forbidden' } });
    return;
  }
  try {
    const slug = req.body?.slug || 'napoletana-nostra';
    const orderPhone = req.body?.orderPhone || '+38344416502';
    const business = await findBusinessBySlug(slug);
    const db = getFirestore();

    await db.doc(`businesses/${business.id}`).set({ orderPhone }, { merge: true });

    const plainKey = publicOrders.generateApiKeyPlain();
    const keyRef = db.collection(`businesses/${business.id}/apiKeys`).doc();
    await keyRef.set({
      name: 'jon-sport-shop demo',
      keyPrefix: `${plainKey.substring(0, 12)}…`,
      secretHash: publicOrders.hashApiKey(plainKey),
      scopes: ['orders:create'],
      active: true,
      createdAt: FieldValue.serverTimestamp(),
    });

    res.status(200).json({
      businessId: business.id,
      slug,
      orderPhone,
      apiKey: plainKey,
    });
  } catch (err) {
    sendError(res, err);
  }
}

exports.devBootstrapShopHttp = onRequest(fnOptions, withCors(handleDevBootstrapShop));

async function handleCreateInvoice(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const decoded = await verifyAuth(req);
    const body = req.body || {};
    const userId = body.userId || decoded.uid;

    if (userId !== decoded.uid) {
      await assertPlatformAdmin(decoded);
    }

    const db = getFirestore();
    const invoice = await invoices.createUserInvoice(db, {
      userId,
      userEmail: body.userEmail || decoded.email || '',
      type: body.type,
      amountEur: body.amountEur,
      currency: body.currency,
      description: body.description,
      planTitle: body.planTitle,
      maxProducts: body.maxProducts,
      paidAt: body.paidAt,
      periodYear: body.periodYear,
      periodMonth: body.periodMonth,
      paymentMethod: body.paymentMethod,
      lineItems: body.lineItems,
    });

    res.status(200).json({ ok: true, invoice });
  } catch (err) {
    sendError(res, err);
  }
}

exports.createInvoiceHttp = onRequest(fnOptions, withCors(handleCreateInvoice));

const staff = require('./staff');

async function handleInviteStaff(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }
  try {
    const decoded = await verifyAuth(req);
    const body = req.body || {};
    const businessId = body.businessId;
    const email = body.email;
    const role = body.role;
    if (!businessId || !email || !role) {
      throw new HttpsError('invalid-argument', 'businessId, email, and role are required');
    }
    const db = getFirestore();
    const result = await staff.inviteStaff(db, getAuth(), {
      callerUid: decoded.uid,
      businessId,
      email,
      role,
    });
    res.status(200).json(result);
  } catch (err) {
    sendError(res, err);
  }
}

async function handleRemoveStaff(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }
  try {
    const decoded = await verifyAuth(req);
    const body = req.body || {};
    const businessId = body.businessId;
    const memberUid = body.memberUid;
    if (!businessId || !memberUid) {
      throw new HttpsError('invalid-argument', 'businessId and memberUid are required');
    }
    const db = getFirestore();
    const result = await staff.removeStaff(db, {
      callerUid: decoded.uid,
      businessId,
      memberUid,
    });
    res.status(200).json(result);
  } catch (err) {
    sendError(res, err);
  }
}

async function handleAcceptInvite(req, res) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }
  try {
    const decoded = await verifyAuth(req);
    const body = req.body || {};
    const code = body.code;
    const email = body.email || decoded.email;
    const db = getFirestore();
    const result = await staff.acceptInvite(db, getAuth(), {
      uid: decoded.uid,
      code,
      email,
    });
    res.status(200).json(result);
  } catch (err) {
    sendError(res, err);
  }
}

exports.inviteStaffHttp = onRequest(fnOptions, withCors(handleInviteStaff));
exports.removeStaffHttp = onRequest(fnOptions, withCors(handleRemoveStaff));
exports.acceptInviteHttp = onRequest(fnOptions, withCors(handleAcceptInvite));

const billingReports = require('./billingReports');
exports.billingReportDaily = billingReports.billingReportDaily;
exports.billingReportWeekly = billingReports.billingReportWeekly;
exports.billingReportMonthly = billingReports.billingReportMonthly;
exports.billingReportYearly = billingReports.billingReportYearly;
exports.onInvoiceCreatedRefreshReports = billingReports.onInvoiceCreatedRefreshReports;

const orderPurge = require('./orderPurge');
exports.purgeCancelledOrders = orderPurge.purgeCancelledOrders;

const offerExpiry = require('./offerExpiry');
exports.deactivateExpiredOffers = offerExpiry.deactivateExpiredOffers;

const offerLifecycle = require('./offerLifecycle');
const { onDocumentWritten } = require('firebase-functions/v2/firestore');

/** Restore any legacy draft holds when an offer is removed or no longer live. */
exports.onOfferWrittenReleaseLegacyHolds = onDocumentWritten(
  { document: 'businesses/{businessId}/offers/{offerId}', ...firestoreTriggerOptions },
  async (event) => {
    const businessId = event.params.businessId;
    const offerId = event.params.offerId;
    const after = event.data?.after;
    const before = event.data?.before;

    if (after?.exists) {
      const data = after.data();
      const stillLive =
        data.active !== false && pricing.isOfferActive({ id: offerId, ...data });
      if (stillLive) return;
    }

    if (before?.exists || !after?.exists) {
      await offerLifecycle.releaseAllProductsForOffer(
        getFirestore(),
        businessId,
        offerId,
      );
    }
  },
);
