const { HttpsError } = require('firebase-functions/v2/https');
const { getFirestore, FieldValue, Timestamp } = require('firebase-admin/firestore');
const { createHash, randomBytes } = require('crypto');
const pricing = require('./pricing');
const rateLimit = require('./rateLimit');
const { logPublicApiError } = require('./apiMonitor');

const MAX_LINES = 50;
const MAX_QTY = 999;

function hashApiKey(plain) {
  return createHash('sha256').update(plain, 'utf8').digest('hex');
}

function generateOrderNumber(seq, date = new Date()) {
  const y = date.getUTCFullYear();
  const m = String(date.getUTCMonth() + 1).padStart(2, '0');
  const d = String(date.getUTCDate()).padStart(2, '0');
  return `ORD-${y}${m}${d}-${String(seq).padStart(4, '0')}`;
}

function roundMoney(n) {
  return Math.round(n * 100) / 100;
}

function variantLabel(attributes) {
  const parts = Object.values(attributes || {}).filter(Boolean);
  return parts.join(' / ');
}

function formatWhatsAppMessage({
  businessName,
  orderNumber,
  lines,
  subtotalEur,
  customer,
  address,
  notes,
}) {
  const rows = lines
    .map((l) => `• ${l.quantity}× ${l.productName} — €${l.lineTotalEur.toFixed(2)}`)
    .join('\n');
  const addr = String(address || customer?.address || '').trim();
  const phone = String(customer?.phone || '').trim();
  const orderNotes = String(notes || '').trim();
  const parts = [
    'Përshëndetje!',
    '',
    `Porosi online — ${businessName}`,
    `Referenca: ${orderNumber}`,
    '',
    '▸ POROSIA',
    rows,
    '',
    `▸ TOTALI: €${subtotalEur.toFixed(2)}`,
    '',
    '▸ KLIENTI',
    `Emri: ${customer.name}`,
  ];
  if (addr) parts.push(`Adresa: ${addr}`);
  if (phone) parts.push(`Telefoni: ${phone}`);
  else parts.push('Telefoni: (kontakt përmes WhatsApp)');
  if (orderNotes) {
    parts.push('', '▸ KËRKESA PËR POROSINË', orderNotes);
  }
  parts.push('', 'Faleminderit!');
  return parts.join('\n');
}

function whatsAppUrl(phone, text) {
  const digits = String(phone || '').replace(/\D/g, '');
  if (!digits) return null;
  return `https://wa.me/${digits}?text=${encodeURIComponent(text)}`;
}

function smsUrl(phone, text) {
  const digits = String(phone || '').replace(/\D/g, '');
  if (!digits) return null;
  return `sms:+${digits}?body=${encodeURIComponent(text)}`;
}

async function verifyOrderApiKey(businessId, plainKey) {
  if (!plainKey || typeof plainKey !== 'string' || plainKey.length < 16) {
    throw new HttpsError('unauthenticated', 'Invalid API key');
  }
  const hash = hashApiKey(plainKey.trim());
  const db = getFirestore();
  const snap = await db
    .collection(`businesses/${businessId}/apiKeys`)
    .where('secretHash', '==', hash)
    .where('active', '==', true)
    .limit(1)
    .get();

  if (snap.empty) {
    throw new HttpsError('unauthenticated', 'Invalid API key');
  }

  const keyDoc = snap.docs[0];
  await keyDoc.ref.update({ lastUsedAt: FieldValue.serverTimestamp() }).catch(() => {});
  return keyDoc.id;
}

async function nextOrderSequence(businessId) {
  const db = getFirestore();
  const counterRef = db.doc(`businesses/${businessId}/settings/order_counter`);
  const seq = await db.runTransaction(async (tx) => {
    const snap = await tx.get(counterRef);
    const current = snap.exists ? (snap.data().seq || 0) : 0;
    const next = current + 1;
    tx.set(counterRef, { seq: next }, { merge: true });
    return next;
  });
  return seq;
}

async function loadProductsForOrder(businessId, lineInputs) {
  const db = getFirestore();
  const productIds = [...new Set(lineInputs.map((l) => l.productId))];
  const docs = await Promise.all(
    productIds.map((id) => db.doc(`businesses/${businessId}/products/${id}`).get()),
  );
  const byId = new Map();
  for (const doc of docs) {
    if (doc.exists) byId.set(doc.id, doc);
  }
  return byId;
}

async function loadVariantsForOrder(businessId, productIds) {
  const db = getFirestore();
  const byProductId = new Map();
  const byVariantId = new Map();
  if (productIds.length === 0) return { byProductId, byVariantId };

  const chunks = [];
  for (let i = 0; i < productIds.length; i += 30) {
    chunks.push(productIds.slice(i, i + 30));
  }

  for (const chunk of chunks) {
    const snap = await db
      .collection(`businesses/${businessId}/productVariants`)
      .where('productId', 'in', chunk)
      .get();
    for (const doc of snap.docs) {
      byVariantId.set(doc.id, doc);
      const pid = doc.data().productId;
      if (!byProductId.has(pid)) byProductId.set(pid, []);
      byProductId.get(pid).push(doc);
    }
  }

  return { byProductId, byVariantId };
}

/**
 * Create order from external e-commerce / menu site.
 * @param {{ business: object, businessId: string, body: object }} ctx
 */
async function createPublicOrder({ business, businessId, body }) {
  const customer = body.customer || {};
  const name = String(customer.name || '').trim();
  const phone = String(customer.phone || '').trim();
  const address = customer.address != null ? String(customer.address).trim() : '';
  const notes = customer.notes != null ? String(customer.notes).trim() : '';

  if (!name || name.length < 2) {
    throw new HttpsError('invalid-argument', 'customer.name is required');
  }
  const phoneDigits = normalizePhone(phone);
  if (phone && phoneDigits.length > 0 && phoneDigits.length < 8) {
    throw new HttpsError('invalid-argument', 'customer.phone is invalid');
  }

  const rawLines = body.lines;
  if (!Array.isArray(rawLines) || rawLines.length === 0) {
    throw new HttpsError('invalid-argument', 'lines must be a non-empty array');
  }
  if (rawLines.length > MAX_LINES) {
    throw new HttpsError('invalid-argument', `Maximum ${MAX_LINES} line items`);
  }

  const lineInputs = rawLines.map((l, i) => {
    const productId = String(l.productId || '').trim();
    const variantId = l.variantId != null ? String(l.variantId).trim() : '';
    const qty = Number(l.quantity);
    if (!productId) {
      throw new HttpsError('invalid-argument', `lines[${i}].productId is required`);
    }
    if (!Number.isFinite(qty) || qty < 1 || qty > MAX_QTY) {
      throw new HttpsError('invalid-argument', `lines[${i}].quantity must be 1–${MAX_QTY}`);
    }
    return { productId, variantId: variantId || null, quantity: Math.floor(qty) };
  });

  const db = getFirestore();
  const [productsById, activeOffers, variantMaps] = await Promise.all([
    loadProductsForOrder(businessId, lineInputs),
    pricing.loadActiveOffers(db, businessId),
    loadVariantsForOrder(
      businessId,
      [...new Set(lineInputs.map((l) => l.productId))],
    ),
  ]);

  const lines = [];
  let subtotalEur = 0;

  for (const input of lineInputs) {
    const doc = productsById.get(input.productId);
    if (!doc || doc.data().status !== 'active') {
      throw new HttpsError('not-found', `Product not found: ${input.productId}`);
    }
    const d = doc.data();
    const productVariants = variantMaps.byProductId.get(input.productId) || [];

    if (productVariants.length > 0 && !input.variantId) {
      throw new HttpsError(
        'invalid-argument',
        `lines[].variantId is required for product ${input.productId} (has variants)`,
      );
    }

    let unitPrice;
    let resolved;
    let variantId = null;
    let variantSku = null;
    let variantAttributes = null;
    let productName = d.name || 'Product';

    if (input.variantId) {
      const vDoc = variantMaps.byVariantId.get(input.variantId);
      if (!vDoc || vDoc.data().productId !== input.productId) {
        throw new HttpsError('not-found', `Variant not found: ${input.variantId}`);
      }
      const vd = vDoc.data();
      const available = vd.quantity != null ? Number(vd.quantity) : 0;
      if (available < input.quantity) {
        throw new HttpsError(
          'failed-precondition',
          `Insufficient stock for variant ${input.variantId}`,
        );
      }
      const baseVariantPrice = vd.price != null ? Number(vd.price) : 0;
      resolved = pricing.resolveVariantPricing(baseVariantPrice, input.productId, activeOffers);
      unitPrice = resolved.unitPrice;
      variantId = vDoc.id;
      variantSku = vd.sku || '';
      variantAttributes = vd.attributes || {};
      const label = variantLabel(variantAttributes) || variantSku;
      if (label) productName = `${productName} (${label})`;
    } else {
      resolved = pricing.resolveProductPricing(d, input.productId, activeOffers);
      unitPrice = resolved.unitPrice;
    }

    const lineTotal = roundMoney(unitPrice * input.quantity);
    subtotalEur = roundMoney(subtotalEur + lineTotal);
    const line = {
      productId: doc.id,
      productName,
      quantity: input.quantity,
      unitPriceEur: unitPrice,
      lineTotalEur: lineTotal,
    };
    if (variantId) {
      line.variantId = variantId;
      line.variantSku = variantSku;
      line.variantAttributes = variantAttributes;
    }
    if (resolved.onOffer) {
      line.originalUnitPriceEur = resolved.originalPrice;
      line.offerId = resolved.offerId;
    }
    lines.push(line);
  }

  const seq = await nextOrderSequence(businessId);
  const orderNumber = generateOrderNumber(seq);
  const notifyChannel = body.channel === 'sms' ? 'sms' : 'whatsapp';
  const orderPhone =
    business.orderPhone ||
    business.settings?.orderPhone ||
    business.phone ||
    '';

  const orderData = {
    orderNumber,
    status: 'pending',
    createdAt: FieldValue.serverTimestamp(),
    customer: {
      name,
      phone: phone || null,
      address: address || null,
      notes: notes || null,
    },
    lines,
    subtotalEur,
    currency: 'EUR',
    source: 'api',
    notifyChannel,
    businessSlug: business.slug || '',
  };

  if (body.externalId && typeof body.externalId === 'string') {
    orderData.externalId = body.externalId.slice(0, 128);
  }

  const orderRef = await db.collection(`businesses/${businessId}/orders`).add(orderData);

  const messageText = formatWhatsAppMessage({
    businessName: business.name || 'Business',
    orderNumber,
    lines,
    subtotalEur,
    customer: { name, phone: phone || null },
    address,
    notes,
  });

  const notify =
    notifyChannel === 'sms'
      ? { smsUrl: smsUrl(orderPhone, messageText) }
      : { whatsAppUrl: whatsAppUrl(orderPhone, messageText) };

  return {
    orderId: orderRef.id,
    orderNumber,
    subtotalEur,
    status: 'pending',
    messageText,
    notify,
  };
}

function normalizePhone(phone) {
  return String(phone || '').replace(/\D/g, '');
}

function phonesMatch(a, b) {
  const da = normalizePhone(a);
  const db = normalizePhone(b);
  if (!da || !db) return false;
  if (da === db) return true;
  if (da.length >= 8 && db.length >= 8) {
    return da.endsWith(db.slice(-8)) || db.endsWith(da.slice(-8));
  }
  return false;
}

function isPendingStatus(status) {
  return status === 'pending' || status === 'new';
}

function serializePublicOrder(doc) {
  const d = doc.data();
  const createdAt = d.createdAt?.toDate?.() || new Date();
  const cancelledAt = d.cancelledAt?.toDate?.() || null;
  const confirmedAt = d.confirmedAt?.toDate?.() || null;
  return {
    orderId: doc.id,
    orderNumber: d.orderNumber,
    status: d.status,
    subtotalEur: d.subtotalEur,
    currency: d.currency || 'EUR',
    createdAt: createdAt.toISOString(),
    cancelledAt: cancelledAt ? cancelledAt.toISOString() : null,
    confirmedAt: confirmedAt ? confirmedAt.toISOString() : null,
    customer: {
      name: d.customer?.name || '',
      phone: d.customer?.phone || '',
    },
    lines: (d.lines || []).map((l) => ({
      productName: l.productName,
      quantity: l.quantity,
      lineTotalEur: l.lineTotalEur,
      variantId: l.variantId || null,
    })),
  };
}

async function loadOrderForCustomer(businessId, orderId, phone) {
  const db = getFirestore();
  const ref = db.doc(`businesses/${businessId}/orders/${orderId}`);
  const snap = await ref.get();
  if (!snap.exists) {
    throw new HttpsError('not-found', 'Order not found');
  }
  const data = snap.data();
  const storedPhone = String(data.customer?.phone || '').trim();
  const requestPhone = String(phone || '').trim();
  if (!storedPhone && !requestPhone) {
    return { ref, snap, data };
  }
  if (!phonesMatch(phone, data.customer?.phone)) {
    throw new HttpsError('permission-denied', 'Phone number does not match this order');
  }
  return { ref, snap, data };
}

function extractApiKey(req) {
  const header = req.headers.authorization || req.headers['x-api-key'] || '';
  if (typeof header === 'string' && header.startsWith('Bearer ')) {
    return header.slice('Bearer '.length).trim();
  }
  if (typeof header === 'string' && header.length > 0) {
    return header.trim();
  }
  const bodyKey = req.body?.apiKey;
  if (typeof bodyKey === 'string') return bodyKey.trim();
  return null;
}

async function handlePublicGetOrder(req, res, { slug, orderId, findBusinessBySlug, sendError }) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'GET') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const ip = rateLimit.clientIp(req);
    const apiKey = extractApiKey(req);
    const phone = String(req.query.phone || '').trim();
    if (!phone || normalizePhone(phone).length < 8) {
      throw new HttpsError('invalid-argument', 'phone query parameter is required');
    }

    const business = await findBusinessBySlug(slug);
    if (apiKey) {
      await verifyOrderApiKey(business.id, apiKey);
    } else {
      rateLimit.checkRateLimit(`public-order-status:${ip}`, { max: 60, windowMs: 60_000 });
    }

    const { snap } = await loadOrderForCustomer(business.id, orderId, phone);
    res.status(200).json(serializePublicOrder(snap));
  } catch (err) {
    logPublicApiError({
      slug,
      resource: 'orders',
      method: req.method,
      statusCode: err instanceof HttpsError ? 400 : 500,
      code: err.code || 'internal',
      message: err.message,
    });
    sendError(res, err);
  }
}

async function handlePublicCancelOrder(req, res, { slug, orderId, findBusinessBySlug, sendError }) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const ip = rateLimit.clientIp(req);
    const apiKey = extractApiKey(req);
    const phone = String(req.body?.phone || req.query?.phone || '').trim();
    if (!phone || normalizePhone(phone).length < 8) {
      throw new HttpsError('invalid-argument', 'phone is required');
    }

    const business = await findBusinessBySlug(slug);
    if (apiKey) {
      await verifyOrderApiKey(business.id, apiKey);
    } else {
      rateLimit.checkRateLimit(`public-order-cancel:${ip}`, { max: 15, windowMs: 60_000 });
    }

    const { ref, data } = await loadOrderForCustomer(business.id, orderId, phone);

    if (!isPendingStatus(data.status)) {
      throw new HttpsError('failed-precondition', 'Only pending orders can be cancelled');
    }

    await ref.update({
      status: 'cancelled',
      cancelledAt: FieldValue.serverTimestamp(),
      cancelledBy: 'customer',
      updatedAt: FieldValue.serverTimestamp(),
    });

    const updated = await ref.get();
    res.status(200).json(serializePublicOrder(updated));
  } catch (err) {
    logPublicApiError({
      slug,
      resource: 'orders/cancel',
      method: req.method,
      statusCode: 500,
      code: err.code || 'internal',
      message: err.message,
    });
    sendError(res, err);
  }
}

async function handlePublicCreateOrder(req, res, { findBusinessBySlug, sendError }) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  let slug = '';
  try {
    const ip = rateLimit.clientIp(req);
    rateLimit.checkRateLimit(`public-orders:${ip}`, { max: 40, windowMs: 60_000 });

    const path = (req.path || req.url || '/').split('?')[0];
    const match = path.match(/\/api\/public\/([^/]+)\/orders\/?$/);
    slug = match
      ? decodeURIComponent(match[1])
      : req.query.slug || req.body?.slug;

    if (!slug) {
      res.status(404).json({
        error: { message: 'Use POST /api/public/{slug}/orders' },
      });
      return;
    }

    const apiKey = extractApiKey(req);
    if (!apiKey) {
      throw new HttpsError(
        'unauthenticated',
        'Missing API key (Authorization: Bearer <key> or X-Api-Key)',
      );
    }

    const business = await findBusinessBySlug(slug);
    await verifyOrderApiKey(business.id, apiKey);

    const result = await createPublicOrder({
      business,
      businessId: business.id,
      body: req.body || {},
    });

    res.status(201).json(result);
  } catch (err) {
    logPublicApiError({
      slug,
      resource: 'orders/create',
      method: req.method,
      statusCode: err instanceof HttpsError ? 400 : 500,
      code: err.code || 'internal',
      message: err.message,
    });
    sendError(res, err);
  }
}

function generateApiKeyPlain() {
  return `jsk_${randomBytes(24).toString('hex')}`;
}

async function handlePublicCheckoutBatch(req, res, { findBusinessBySlug, sendError }) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const ip = rateLimit.clientIp(req);
    rateLimit.checkRateLimit(`public-checkout:${ip}`, { max: 20, windowMs: 60_000 });

    const body = req.body || {};
    const customer = body.customer || {};
    const name = String(customer.name || '').trim();
    const phone = String(customer.phone || '').trim();
    const address = customer.address != null ? String(customer.address).trim() : '';
    const notes = customer.notes != null ? String(customer.notes).trim() : '';
    const channel = body.channel === 'sms' ? 'sms' : 'whatsapp';

    if (!name || name.length < 2) {
      throw new HttpsError('invalid-argument', 'customer.name is required');
    }

    const groups = Array.isArray(body.groups) ? body.groups : [];
    if (groups.length === 0) {
      throw new HttpsError('invalid-argument', 'groups array is required');
    }
    if (groups.length > 10) {
      throw new HttpsError('invalid-argument', 'Too many businesses in one checkout');
    }

    const orders = [];
    for (const group of groups) {
      const slug = String(group.slug || '').trim();
      if (!slug) {
        throw new HttpsError('invalid-argument', 'Each group needs a slug');
      }
      const lines = Array.isArray(group.lines) ? group.lines : [];
      if (lines.length === 0) continue;

      const business = await findBusinessBySlug(slug);
      const result = await createPublicOrder({
        business,
        businessId: business.id,
        body: { customer: { name, phone, address, notes }, lines, channel },
      });
      orders.push({
        slug,
        businessName: business.name || slug,
        orderId: result.orderId,
        orderNumber: result.orderNumber,
        subtotalEur: result.subtotalEur,
        status: result.status,
        messageText: result.messageText,
        notify: result.notify,
      });
    }

    if (orders.length === 0) {
      throw new HttpsError('invalid-argument', 'No order lines');
    }

    res.status(201).json({ orders });
  } catch (err) {
    logPublicApiError({
      slug: 'checkout',
      resource: 'checkout',
      method: req.method,
      statusCode: err instanceof HttpsError ? 400 : 500,
      code: err.code || 'internal',
      message: err.message,
    });
    sendError(res, err);
  }
}

module.exports = {
  hashApiKey,
  generateApiKeyPlain,
  createPublicOrder,
  handlePublicGetOrder,
  handlePublicCancelOrder,
  handlePublicCreateOrder,
  handlePublicCheckoutBatch,
  formatWhatsAppMessage,
  variantLabel,
};
