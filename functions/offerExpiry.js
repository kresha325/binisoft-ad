const { onSchedule } = require('firebase-functions/v2/scheduler');
const { getFirestore, Timestamp } = require('firebase-admin/firestore');

const BATCH_SIZE = 400;

/**
 * Sets active=false on offers past endsAt (storefront/API already hide by date).
 */
async function deactivateExpiredOffers() {
  const db = getFirestore();
  const now = Timestamp.now();
  let total = 0;
  let hasMore = true;

  while (hasMore) {
    const snap = await db
      .collectionGroup('offers')
      .where('active', '==', true)
      .where('endsAt', '<', now)
      .limit(BATCH_SIZE)
      .get();

    if (snap.empty) {
      hasMore = false;
      break;
    }

    const batch = db.batch();
    for (const doc of snap.docs) {
      batch.update(doc.ref, {
        active: false,
        expiredAt: now,
      });
    }
    await batch.commit();
    total += snap.size;
    hasMore = snap.size >= BATCH_SIZE;
  }

  if (total > 0) {
    console.log(`deactivateExpiredOffers: deactivated ${total} offer(s)`);
  }
}

const scheduleOptions = {
  schedule: 'every 1 hours',
  timeZone: 'Europe/Belgrade',
  region: 'us-central1',
};

const deactivateExpiredOffersScheduled = onSchedule(
  scheduleOptions,
  deactivateExpiredOffers,
);

exports.deactivateExpiredOffers = deactivateExpiredOffersScheduled;
module.exports = { deactivateExpiredOffers: deactivateExpiredOffersScheduled };
