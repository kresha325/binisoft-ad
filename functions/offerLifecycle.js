const { FieldValue } = require('firebase-admin/firestore');
const pricing = require('./pricing');

/**
 * Products on a live offer are held as draft (hidden from catalog, visible in /offers).
 * When the offer ends or is deactivated, status is restored from statusBeforeOffer.
 */

function collectProductIds(offerData) {
  if (!offerData) return [];
  const set = new Set();
  for (const id of offerData.productIds || []) {
    if (id) set.add(String(id));
  }
  for (const item of offerData.items || []) {
    if (item?.productId) set.add(String(item.productId));
  }
  return [...set];
}

function isOfferLive(offerId, data) {
  return data && data.active !== false && pricing.isOfferActive({ id: offerId, ...data });
}

async function holdProductsForOffer(db, businessId, offerId, productIds) {
  let held = 0;
  for (const productId of productIds) {
    const ref = db.doc(`businesses/${businessId}/products/${productId}`);
    const snap = await ref.get();
    if (!snap.exists) continue;
    const d = snap.data();
    if (d.hiddenByOfferId && d.hiddenByOfferId !== offerId) continue;

    const updates = {
      hiddenByOfferId: offerId,
      status: 'draft',
      updatedAt: FieldValue.serverTimestamp(),
    };
    if (d.hiddenByOfferId !== offerId) {
      if (String(d.status || '').toLowerCase() === 'active') {
        updates.statusBeforeOffer = 'active';
      } else if (!d.statusBeforeOffer) {
        updates.statusBeforeOffer = d.status || 'draft';
      }
    }
    await ref.update(updates);
    held += 1;
  }
  return held;
}

async function releaseProductIfHeldBy(db, businessId, productId, offerId) {
  const ref = db.doc(`businesses/${businessId}/products/${productId}`);
  const snap = await ref.get();
  if (!snap.exists) return false;
  const d = snap.data();
  if (d.hiddenByOfferId !== offerId) return false;

  const updates = {
    hiddenByOfferId: FieldValue.delete(),
    statusBeforeOffer: FieldValue.delete(),
    updatedAt: FieldValue.serverTimestamp(),
  };
  if (d.statusBeforeOffer === 'active') {
    updates.status = 'active';
  }
  await ref.update(updates);
  return true;
}

async function releaseAllProductsForOffer(db, businessId, offerId) {
  const snap = await db
    .collection(`businesses/${businessId}/products`)
    .where('hiddenByOfferId', '==', offerId)
    .get();

  if (snap.empty) return 0;

  const batch = db.batch();
  for (const doc of snap.docs) {
    const data = doc.data();
    const updates = {
      hiddenByOfferId: FieldValue.delete(),
      statusBeforeOffer: FieldValue.delete(),
      updatedAt: FieldValue.serverTimestamp(),
    };
    if (data.statusBeforeOffer === 'active') {
      updates.status = 'active';
    }
    batch.update(doc.ref, updates);
  }
  await batch.commit();
  return snap.size;
}

/**
 * Apply or release catalog holds when an offer document changes.
 */
async function syncOfferProductHolds(db, businessId, offerId, afterData, beforeData) {
  const afterIds = collectProductIds(afterData);
  const beforeIds = collectProductIds(beforeData);
  const live = isOfferLive(offerId, afterData);

  if (!live) {
    const released = await releaseAllProductsForOffer(db, businessId, offerId);
    return { released, held: 0 };
  }

  const removed = beforeIds.filter((id) => !afterIds.includes(id));
  for (const productId of removed) {
    await releaseProductIfHeldBy(db, businessId, productId, offerId);
  }

  const held = await holdProductsForOffer(db, businessId, offerId, afterIds);
  return { released: removed.length, held };
}

module.exports = {
  collectProductIds,
  isOfferLive,
  holdProductsForOffer,
  releaseProductIfHeldBy,
  releaseAllProductsForOffer,
  syncOfferProductHolds,
};
