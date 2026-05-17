const { onRequest, HttpsError } = require('firebase-functions/v2/https');
const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { initializeApp } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { getStorage } = require('firebase-admin/storage');
const { randomUUID } = require('crypto');

initializeApp();

const fnOptions = {
  region: 'us-central1',
  cors: true,
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

async function assertSuperAdmin(uid) {
  const snap = await getFirestore().doc(`users/${uid}`).get();
  if (!snap.exists || snap.data().role !== 'superadmin') {
    throw new HttpsError('permission-denied', 'Superadmin only');
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
    await assertSuperAdmin(decoded.uid);

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
    description: i18n.resolveLocalized({
      primary: d.description,
      i18n: d.descriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
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

function serializeProduct(doc, attributeDefs, ctx, activeOffers = []) {
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

  const priceInfo = pricing.resolveProductPricing(d, doc.id, activeOffers);

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
    price: priceInfo.unitPrice,
    originalPrice: priceInfo.onOffer ? priceInfo.originalPrice : null,
    onOffer: priceInfo.onOffer,
    offerId: priceInfo.offerId,
    discountPercent: priceInfo.discountPercent,
    quantity: d.baseQuantity ?? 0,
    status: d.status || 'draft',
    imageUrls: d.imageUrls || [],
    categoryIds: d.categoryIds || [],
    attributeData,
    attributes,
  };
}

function serializeOffer(offer, productsById, ctx) {
  const items = (offer.items || [])
    .map((item) => {
      const entry = productsById.get(item.productId);
      if (!entry) return null;
      const { doc, data: d } = entry;
      if (d.status !== 'active') return null;
      const priceInfo = pricing.resolveProductPricing(d, item.productId, [offer]);
      return {
        productId: item.productId,
        productName: i18n.resolveLocalized({
          primary: d.name,
          i18n: d.nameI18n,
          locale: ctx.locale,
          defaultLocale: ctx.defaultLocale,
        }),
        originalPrice: priceInfo.originalPrice,
        salePrice: priceInfo.unitPrice,
        discountPercent:
          item.discountPercent != null
            ? Number(item.discountPercent)
            : offer.discountPercent != null
              ? Number(offer.discountPercent)
              : priceInfo.discountPercent,
      };
    })
    .filter(Boolean);

  const startsAt = offer.startsAt;
  const endsAt = offer.endsAt;

  return {
    id: offer.id,
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
    durationDays: offer.durationDays ?? null,
    startsAt: startsAt?.toDate?.()?.toISOString?.() || null,
    endsAt: endsAt?.toDate?.()?.toISOString?.() || null,
    items,
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
    description: i18n.resolveLocalized({
      primary: business.description,
      i18n: business.descriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    logoUrl: business.logoUrl || '',
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

async function handlePublicApi(req, res) {
  const path = requestPath(req);
  const orderDetailMatch = path.match(
    /\/api\/public\/([^/]+)\/orders\/([^/]+)(\/cancel)?\/?$/,
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

  if (/\/orders\/?$/.test(path)) {
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

  try {
    let slug;
    let resource;
    let productId;
    const match = path.match(
      /\/api\/public\/([^/]+)\/(products|categories|offers)(?:\/([^/]+))?$/,
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
            'Not found. Use /api/public/{slug}/products or ?slug=...&resource=products',
        },
      });
      return;
    }

    const business = await findBusinessBySlug(slug);
    const businessId = business.id;
    const db = getFirestore();
    const localeCtx = i18n.pickRequestLocale(req, business);

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

    if (resource === 'offers') {
      const [offersSnap, productsSnap] = await Promise.all([
        db.collection(`businesses/${businessId}/offers`).where('active', '==', true).get(),
        db
          .collection(`businesses/${businessId}/products`)
          .where('status', '==', 'active')
          .limit(500)
          .get(),
      ]);

      const productsById = new Map(
        productsSnap.docs.map((doc) => [doc.id, { doc, data: doc.data() }]),
      );

      const activeOffers = offersSnap.docs
        .map((doc) => ({ id: doc.id, ...doc.data() }))
        .filter((offer) => pricing.isOfferActive(offer));

      res.status(200).json({
        meta: i18n.apiMeta(localeCtx),
        business: businessPayload(business, slug, localeCtx),
        offers: activeOffers.map((offer) => serializeOffer(offer, productsById, localeCtx)),
      });
      return;
    }

    if (resource !== 'products') {
      res.status(404).json({ error: { message: 'Unknown resource' } });
      return;
    }

    const customFields = await loadAttributeDefs(businessId, localeCtx);
    const activeOffers = await pricing.loadActiveOffers(db, businessId);

    if (productId) {
      const doc = await db.doc(`businesses/${businessId}/products/${productId}`).get();
      if (!doc.exists || doc.data().status !== 'active') {
        throw new HttpsError('not-found', 'Product not found');
      }
      res.status(200).json({
        meta: i18n.apiMeta(localeCtx),
        business: businessPayload(business, slug, localeCtx),
        customFields,
        product: serializeProduct(doc, customFields, localeCtx, activeOffers),
      });
      return;
    }

    const [productsSnap, categoriesSnap] = await Promise.all([
      db
        .collection(`businesses/${businessId}/products`)
        .where('status', '==', 'active')
        .orderBy('createdAt', 'desc')
        .limit(200)
        .get(),
      db.collection(`businesses/${businessId}/categories`).orderBy('name').get(),
    ]);

    const categories = categoriesSnap.docs.map((doc) =>
      serializeCategory(doc, localeCtx),
    );
    const categoryNames = Object.fromEntries(categories.map((c) => [c.id, c.name]));

    const products = productsSnap.docs.map((doc) => {
      const p = serializeProduct(doc, customFields, localeCtx, activeOffers);
      p.categories = (p.categoryIds || []).map((id) => categoryNames[id] || id);
      return p;
    });

    res.status(200).json({
      meta: i18n.apiMeta(localeCtx),
      business: businessPayload(business, slug, localeCtx),
      customFields,
      categories,
      products,
    });
  } catch (err) {
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
    await verifyAuth(req);
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

exports.platformNotifyHttp = onRequest(fnOptions, handlePlatformNotify);

const EMAIL_FROM = process.env.EMAIL_FROM || 'noreply@jon-sport.firebaseapp.com';

const EMAIL_TEMPLATES = {
  welcome: (v) => ({
    subject: 'Welcome to Binisoft Admin',
    html: `<p>Hi${v.name ? ` ${escapeHtml(v.name)}` : ''},</p>
<p>Your Binisoft Admin account is ready. Create your first business to start managing your catalog.</p>
<p><a href="https://jon-sport.web.app">Open dashboard</a></p>`,
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

function escapeHtml(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

async function deliverEmail({ to, subject, html }) {
  const apiKey = process.env.SENDGRID_API_KEY;
  if (apiKey) {
    const res = await fetch('https://api.sendgrid.com/v3/mail/send', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        personalizations: [{ to: [{ email: to }] }],
        from: { email: EMAIL_FROM, name: 'Binisoft Admin' },
        subject,
        content: [{ type: 'text/html', value: html }],
      }),
    });
    if (!res.ok) {
      const text = await res.text();
      throw new HttpsError('internal', `SendGrid failed: ${res.status} ${text.slice(0, 200)}`);
    }
    return { channel: 'sendgrid' };
  }

  await getFirestore().collection('mail').add({
    to,
    message: { subject, html },
  });
  return { channel: 'mail_queue' };
}

async function handleSendEmail(req, res) {
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
    const { template, variables = {}, toEmail } = req.body || {};
    const build = EMAIL_TEMPLATES[template];
    if (!build) {
      throw new HttpsError('invalid-argument', 'Unknown email template');
    }

    let recipient;
    if (template === 'platform_new_user') {
      recipient = toEmail || SUPERADMIN_EMAIL;
    } else {
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

exports.sendEmailHttp = onRequest(fnOptions, handleSendEmail);

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
exports.uploadProductImageHttp = onRequest(fnOptions, handleUploadProductImage);
exports.uploadBusinessLogoHttp = onRequest(fnOptions, handleUploadBusinessLogo);
exports.uploadBusinessBackgroundHttp = onRequest(fnOptions, handleUploadBusinessBackground);
exports.publicApi = onRequest(fnOptions, handlePublicApi);
exports.superadminDeleteUserHttp = onRequest(fnOptions, handleSuperadminDeleteUser);

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
  if (req.headers['x-demo-setup'] !== 'jon-sport-demo-2026') {
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

exports.devBootstrapShopHttp = onRequest(fnOptions, handleDevBootstrapShop);

const billingReports = require('./billingReports');
exports.billingReportDaily = billingReports.billingReportDaily;
exports.billingReportWeekly = billingReports.billingReportWeekly;
exports.billingReportMonthly = billingReports.billingReportMonthly;
exports.billingReportYearly = billingReports.billingReportYearly;
exports.onInvoiceCreatedRefreshReports = billingReports.onInvoiceCreatedRefreshReports;

const orderPurge = require('./orderPurge');
exports.purgeCancelledOrders = orderPurge.purgeCancelledOrders;
