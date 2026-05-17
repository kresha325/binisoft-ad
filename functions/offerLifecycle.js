const { FieldValue } = require('firebase-admin/firestore');

/**
 * Legacy cleanup: products were briefly moved to draft while on offer.
 * Offers no longer change product status — only pricing/display changes.
 */

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

module.exports = {
  releaseAllProductsForOffer,
};
