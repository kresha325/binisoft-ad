const { FieldValue } = require('firebase-admin/firestore');
const pricing = require('./pricing');

/**
 * While an offer is live, catalog products move to draft (hidden from /products API).
 * Fields on product: statusBeforeOffer, hiddenByOfferId.
 */

async function releaseProductHold(docRef, data) {
  const updates = {
    hiddenByOfferId: FieldValue.delete(),
    statusBeforeOffer: FieldValue.delete(),
  };
  if (data.statusBeforeOffer === 'active') {
    updates.status = 'active';
  }
  await docRef.update(updates);
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
    };
    if (data.statusBeforeOffer === 'active') {
      updates.status = 'active';
    }
    batch.update(doc.ref, updates);
  }
  await batch.commit();
  return snap.size;
}

async function applyOfferProductHolds(db, businessId, offerId, productIds) {
  let held = 0;
  for (const productId of productIds) {
    const ref = db.doc(`businesses/${businessId}/products/${productId}`);
    const snap = await ref.get();
    if (!snap.exists) continue;
    const data = snap.data();

    if (data.hiddenByOfferId === offerId) continue;

    if (data.status === 'active') {
      await ref.update({
        status: 'draft',
        statusBeforeOffer: 'active',
        hiddenByOfferId: offerId,
      });
      held += 1;
    } else if (data.status === 'draft' && !data.hiddenByOfferId) {
      await ref.update({
        statusBeforeOffer: 'active',
        hiddenByOfferId: offerId,
      });
      held += 1;
    }
  }
  return held;
}

async function productIdsWithOfferDiscount(db, businessId, offerData) {
  const ids = new Set();
  for (const item of offerData.items || []) {
    if (!item?.productId) continue;
    const snap = await db.doc(`businesses/${businessId}/products/${item.productId}`).get();
    if (!snap.exists) continue;
    const priceInfo = pricing.resolveOfferItemDisplay(snap.data(), item, offerData);
    if (priceInfo.hasDiscount) ids.add(item.productId);
  }
  return [...ids];
}

/**
 * Sync product holds for one offer document.
 */
async function syncOfferProductHolds(db, businessId, offerId, offerData) {
  const shouldHold =
    offerData.active !== false &&
    pricing.isOfferActive({ id: offerId, ...offerData });

  if (!shouldHold) {
    const released = await releaseAllProductsForOffer(db, businessId, offerId);
    return { released, held: 0 };
  }

  const productIds = await productIdsWithOfferDiscount(db, businessId, offerData);
  const held = await applyOfferProductHolds(db, businessId, offerId, productIds);

  const heldSnap = await db
    .collection(`businesses/${businessId}/products`)
    .where('hiddenByOfferId', '==', offerId)
    .get();

  let released = 0;
  const batch = db.batch();
  for (const doc of heldSnap.docs) {
    if (!productIds.includes(doc.id)) {
      const data = doc.data();
      const updates = {
        hiddenByOfferId: FieldValue.delete(),
        statusBeforeOffer: FieldValue.delete(),
      };
      if (data.statusBeforeOffer === 'active') {
        updates.status = 'active';
      }
      batch.update(doc.ref, updates);
      released += 1;
    }
  }
  if (released > 0) await batch.commit();

  return { held, released };
}

/** Re-sync all currently live offers (hourly safety net). */
async function syncAllLiveOfferHolds(db) {
  const snap = await db.collectionGroup('offers').where('active', '==', true).get();
  let totalHeld = 0;
  let totalReleased = 0;

  for (const doc of snap.docs) {
    const businessId = doc.ref.parent.parent.id;
    const offerId = doc.id;
    const offer = doc.data();
    if (!pricing.isOfferActive({ id: offerId, ...offer })) {
      const released = await releaseAllProductsForOffer(db, businessId, offerId);
      totalReleased += released;
      continue;
    }
    const result = await syncOfferProductHolds(db, businessId, offerId, offer);
    totalHeld += result.held;
    totalReleased += result.released;
  }

  return { totalHeld, totalReleased };
}

module.exports = {
  syncOfferProductHolds,
  releaseAllProductsForOffer,
  syncAllLiveOfferHolds,
};
