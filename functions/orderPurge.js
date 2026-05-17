const { onSchedule } = require('firebase-functions/v2/scheduler');
const { getFirestore, Timestamp } = require('firebase-admin/firestore');

const PURGE_AFTER_MS = 24 * 60 * 60 * 1000;
const BATCH_SIZE = 400;

/**
 * Deletes cancelled orders older than 24 hours (all businesses).
 */
async function purgeCancelledOrders() {
  const db = getFirestore();
  const cutoff = Timestamp.fromMillis(Date.now() - PURGE_AFTER_MS);

  let totalDeleted = 0;
  let hasMore = true;

  while (hasMore) {
    const snap = await db
      .collectionGroup('orders')
      .where('status', '==', 'cancelled')
      .where('cancelledAt', '<', cutoff)
      .limit(BATCH_SIZE)
      .get();

    if (snap.empty) {
      hasMore = false;
      break;
    }

    const batch = db.batch();
    for (const doc of snap.docs) {
      batch.delete(doc.ref);
    }
    await batch.commit();
    totalDeleted += snap.size;
    hasMore = snap.size >= BATCH_SIZE;
  }

  if (totalDeleted > 0) {
    console.log(`purgeCancelledOrders: deleted ${totalDeleted} order(s)`);
  }
}

const scheduleOptions = {
  schedule: 'every 1 hours',
  timeZone: 'Europe/Belgrade',
  region: 'us-central1',
};

exports.purgeCancelledOrders = onSchedule(scheduleOptions, purgeCancelledOrders);

module.exports = { purgeCancelledOrders };
