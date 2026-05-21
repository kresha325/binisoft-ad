const { HttpsError } = require('firebase-functions/v2/https');
const { FieldValue, Timestamp } = require('firebase-admin/firestore');

async function allocateInvoiceNumber(db, paidAt) {
  const d = paidAt instanceof Date ? paidAt : new Date(paidAt);
  const key = `${d.getUTCFullYear()}${String(d.getUTCMonth() + 1).padStart(2, '0')}`;
  const counterRef = db.collection('invoice_counters').doc(key);

  const seq = await db.runTransaction(async (tx) => {
    const snap = await tx.get(counterRef);
    const current = snap.data()?.seq ?? 0;
    const next = current + 1;
    tx.set(counterRef, { seq: next }, { merge: true });
    return next;
  });

  return `BIN-${key}-${String(seq).padStart(4, '0')}`;
}

/**
 * Creates a user invoice with server-allocated invoice number (counter not client-writable).
 */
async function createUserInvoice(db, payload) {
  const {
    userId,
    userEmail,
    type,
    amountEur,
    currency,
    description,
    planTitle,
    maxProducts,
    paidAt,
    periodYear,
    periodMonth,
    paymentMethod,
    lineItems,
    buyerLegalName,
    buyerNipt,
    buyerAddress,
  } = payload;

  if (!userId || !userEmail || !type || !description) {
    throw new HttpsError('invalid-argument', 'Missing required invoice fields');
  }

  const paidDate = paidAt ? new Date(paidAt) : new Date();
  const invoiceNumber = await allocateInvoiceNumber(db, paidDate);

  const doc = {
    userId,
    userEmail,
    type,
    invoiceNumber,
    amountEur: Number(amountEur) || 0,
    currency: currency || 'EUR',
    description,
    planTitle: planTitle || '',
    maxProducts: Number(maxProducts) || 0,
    paidAt: Timestamp.fromDate(paidDate),
    periodYear: Number(periodYear) || paidDate.getUTCFullYear(),
    periodMonth: Number(periodMonth) || paidDate.getUTCMonth() + 1,
    lineItems: Array.isArray(lineItems) ? lineItems.map(String) : [],
  };
  if (paymentMethod) doc.paymentMethod = paymentMethod;
  if (buyerLegalName) doc.buyerLegalName = String(buyerLegalName).trim();
  if (buyerNipt) doc.buyerNipt = String(buyerNipt).trim();
  if (buyerAddress) doc.buyerAddress = String(buyerAddress).trim();

  const ref = await db.collection(`users/${userId}/invoices`).add(doc);
  return {
    id: ref.id,
    userId,
    userEmail,
    type,
    invoiceNumber,
    amountEur: doc.amountEur,
    currency: doc.currency,
    description,
    planTitle: doc.planTitle,
    maxProducts: doc.maxProducts,
    paidAt: paidDate.toISOString(),
    periodYear: doc.periodYear,
    periodMonth: doc.periodMonth,
    paymentMethod: doc.paymentMethod || null,
    lineItems: doc.lineItems,
    buyerLegalName: doc.buyerLegalName || null,
    buyerNipt: doc.buyerNipt || null,
    buyerAddress: doc.buyerAddress || null,
  };
}

module.exports = {
  allocateInvoiceNumber,
  createUserInvoice,
};
