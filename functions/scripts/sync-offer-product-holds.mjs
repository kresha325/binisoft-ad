/**
 * Apply catalog holds for all currently live offers (one-time / repair).
 * Run: cd functions && node scripts/sync-offer-product-holds.mjs [businessSlug]
 */
import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import offerLifecycle from '../offerLifecycle.js';
import pricing from '../pricing.js';

const slug = process.argv[2] || null;

initializeApp();
const db = getFirestore();

async function main() {
  let bizQuery = db.collection('businesses');
  if (slug) bizQuery = bizQuery.where('slug', '==', slug);
  const bizSnap = await bizQuery.get();
  if (bizSnap.empty) {
    console.log('No businesses found');
    return;
  }

  for (const bizDoc of bizSnap.docs) {
    const businessId = bizDoc.id;
    const offersSnap = await db
      .collection(`businesses/${businessId}/offers`)
      .where('active', '==', true)
      .get();

    for (const offerDoc of offersSnap.docs) {
      const data = { id: offerDoc.id, ...offerDoc.data() };
      if (!pricing.isOfferActive(data)) {
        const released = await offerLifecycle.releaseAllProductsForOffer(
          db,
          businessId,
          offerDoc.id,
        );
        console.log(`${bizDoc.data().slug} offer ${offerDoc.id} expired → released ${released}`);
        continue;
      }
      const held = await offerLifecycle.holdProductsForOffer(
        db,
        businessId,
        offerDoc.id,
        offerLifecycle.collectProductIds(data),
      );
      console.log(`${bizDoc.data().slug} offer ${offerDoc.id} live → held ${held} products`);
    }
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
