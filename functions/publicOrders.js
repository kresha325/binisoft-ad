const { HttpsError } = require('firebase-functions/v2/https');
const { getFirestore, FieldValue, Timestamp } = require('firebase-admin/firestore');
const { createHash, randomBytes } = require('crypto');
const pricing = require('./pricing');

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

function formatWhatsAppMessage({ businessName, orderNumber, lines, subtotalEur, customer, notes }) {
  const rows = lines
    .map((l) => `${l.quantity}× ${l.productName} — €${l.lineTotalEur.toFixed(2)}`)
    .join('\n');
  const parts = [
    `Porosi ${orderNumber} — ${businessName}`,
    '─────────────────',
    rows,
    '─────────────────',
    `Total: €${subtotalEur.toFixed(2)}`,
    `Klienti: ${customer.name}, ${customer.phone}`,
  ];
  if (notes && String(notes).trim()) {
    parts.push(`Shënime: ${String(notes).trim()}`);
  }
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

/**
 * Create order from external e-commerce / menu site.
 * @param {{ business: object, businessId: string, body: object }} ctx
 */
async function createPublicOrder({ business, businessId, body }) {
  const customer = body.customer || {};
  const name = String(customer.name || '').trim();
  const phone = String(customer.phone || '').trim();
  const notes = customer.notes != null ? String(customer.notes).trim() : '';

  if (!name || name.length < 2) {
    throw new HttpsError('invalid-argument', 'customer.name is required');
  }
  if (!phone || phone.length < 6) {
    throw new HttpsError('invalid-argument', 'customer.phone is required');
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
    const qty = Number(l.quantity);
    if (!productId) {
      throw new HttpsError('invalid-argument', `lines[${i}].productId is required`);
    }
    if (!Number.isFinite(qty) || qty < 1 || qty > MAX_QTY) {
      throw new HttpsError('invalid-argument', `lines[${i}].quantity must be 1–${MAX_QTY}`);
    }
    return { productId, quantity: Math.floor(qty) };
  });

  const db = getFirestore();
  const productsById = await loadProductsForOrder(businessId, lineInputs);
  const activeOffers = await pricing.loadActiveOffers(db, businessId);
  const lines = [];
  let subtotalEur = 0;

  for (const input of lineInputs) {
    const doc = productsById.get(input.productId);
    if (!doc || doc.data().status !== 'active') {
      throw new HttpsError('not-found', `Product not found: ${input.productId}`);
    }
    const d = doc.data();
    const resolved = pricing.resolveProductPricing(d, input.productId, activeOffers);
    const unitPrice = resolved.unitPrice;
    const lineTotal = roundMoney(unitPrice * input.quantity);
    subtotalEur = roundMoney(subtotalEur + lineTotal);
    const line = {
      productId: doc.id,
      productName: d.name || 'Product',
      quantity: input.quantity,
      unitPriceEur: unitPrice,
      lineTotalEur: lineTotal,
    };
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
    customer: { name, phone, notes: notes || null },
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
    customer: { name, phone },
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
  if (!phonesMatch(phone, data.customer?.phone)) {
    throw new HttpsError('permission-denied', 'Phone number does not match this order');
  }
  return { ref, snap, data };
}

/**
 * GET /api/public/{slug}/orders/{orderId}?phone=...
 */
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
    const apiKey = extractApiKey(req);
    if (!apiKey) {
      throw new HttpsError('unauthenticated', 'Missing API key');
    }
    const phone = String(req.query.phone || '').trim();
    if (!phone || normalizePhone(phone).length < 8) {
      throw new HttpsError('invalid-argument', 'phone query parameter is required');
    }

    const business = await findBusinessBySlug(slug);
    await verifyOrderApiKey(business.id, apiKey);

    const { snap } = await loadOrderForCustomer(business.id, orderId, phone);
    res.status(200).json(serializePublicOrder(snap));
  } catch (err) {
    sendError(res, err);
  }
}

/**
 * POST /api/public/{slug}/orders/{orderId}/cancel
 */
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
    const apiKey = extractApiKey(req);
    if (!apiKey) {
      throw new HttpsError('unauthenticated', 'Missing API key');
    }
    const phone = String(req.body?.phone || req.query?.phone || '').trim();
    if (!phone || normalizePhone(phone).length < 8) {
      throw new HttpsError('invalid-argument', 'phone is required');
    }

    const business = await findBusinessBySlug(slug);
    await verifyOrderApiKey(business.id, apiKey);

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
    sendError(res, err);
  }
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

/**
 * POST /api/public/{slug}/orders
 */
async function handlePublicCreateOrder(req, res, { findBusinessBySlug, sendError }) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const path = (req.path || req.url || '/').split('?')[0];
    const match = path.match(/\/api\/public\/([^/]+)\/orders\/?$/);
    const slug = match
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
    sendError(res, err);
  }
}

function generateApiKeyPlain() {
  return `jsk_${randomBytes(24).toString('hex')}`;
}

module.exports = {
  hashApiKey,
  generateApiKeyPlain,
  handlePublicCreateOrder,
  handlePublicGetOrder,
  handlePublicCancelOrder,
  formatWhatsAppMessage,
};
