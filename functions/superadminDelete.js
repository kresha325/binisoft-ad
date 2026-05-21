const { HttpsError } = require('firebase-functions/v2/https');
const { getFirestore } = require('firebase-admin/firestore');

const BOOTSTRAP_SUPERADMIN_EMAILS = new Set(['kreshnik.sh.gashi@hotmail.com']);

const BUSINESS_SUBCOLLECTIONS = [
  'products',
  'categories',
  'services',
  'offers',
  'contests',
  'jobOpenings',
  'appointments',
  'productVariants',
  'attributes',
  'attributeValues',
  'media',
  'apiKeys',
  'settings',
  'orders',
  'members',
];

async function assertPlatformAdmin(decoded) {
  const email = (decoded.email || '').toLowerCase();
  if (BOOTSTRAP_SUPERADMIN_EMAILS.has(email)) return;

  const snap = await getFirestore().doc(`users/${decoded.uid}`).get();
  if (!snap.exists || snap.data().role !== 'superadmin') {
    throw new HttpsError('permission-denied', 'Superadmin only');
  }
}

async function deleteCollectionDocs(colRef, batchSize = 400) {
  const db = getFirestore();
  let deleted = 0;
  // eslint-disable-next-line no-constant-condition
  while (true) {
    const snap = await colRef.limit(batchSize).get();
    if (snap.empty) break;
    const batch = db.batch();
    for (const doc of snap.docs) {
      batch.delete(doc.ref);
    }
    await batch.commit();
    deleted += snap.size;
    if (snap.size < batchSize) break;
  }
  return deleted;
}

async function deleteBusinessDeep(db, businessId) {
  const businessRef = db.doc(`businesses/${businessId}`);
  const businessSnap = await businessRef.get();
  if (!businessSnap.exists) {
    return { ok: true, deleted: false };
  }

  const slug = businessSnap.data().slug;
  let subdocsRemoved = 0;

  for (const sub of BUSINESS_SUBCOLLECTIONS) {
    subdocsRemoved += await deleteCollectionDocs(businessRef.collection(sub));
  }

  const batch = db.batch();
  batch.delete(businessRef);
  if (slug && typeof slug === 'string' && slug.trim()) {
    batch.delete(db.doc(`slugs/${slug.trim()}`));
  }
  await batch.commit();

  return { ok: true, deleted: true, subdocsRemoved };
}

function createSuperadminDeleteHandlers({ verifyAuth, sendError }) {
  async function handleSuperadminDeleteContent(req, res) {
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
      await assertPlatformAdmin(decoded);

      const kind = req.body?.kind;
      const businessId = req.body?.businessId;
      const docId = req.body?.docId;

      if (!kind || typeof kind !== 'string') {
        throw new HttpsError('invalid-argument', 'kind is required');
      }
      if (!businessId || typeof businessId !== 'string') {
        throw new HttpsError('invalid-argument', 'businessId is required');
      }

      const db = getFirestore();

      if (kind === 'business') {
        const result = await deleteBusinessDeep(db, businessId);
        res.status(200).json(result);
        return;
      }

      if (!docId || typeof docId !== 'string') {
        throw new HttpsError('invalid-argument', 'docId is required');
      }

      const collectionByKind = {
        product: 'products',
        category: 'categories',
        offer: 'offers',
        contest: 'contests',
        jobOpening: 'jobOpenings',
      };
      const collection = collectionByKind[kind];
      if (!collection) {
        throw new HttpsError('invalid-argument', 'Invalid kind');
      }

      const ref = db.doc(`businesses/${businessId}/${collection}/${docId}`);
      const snap = await ref.get();
      if (!snap.exists) {
        res.status(200).json({ ok: true, deleted: false });
        return;
      }
      await ref.delete();
      res.status(200).json({ ok: true, deleted: true });
    } catch (err) {
      sendError(res, err);
    }
  }

  return {
    assertPlatformAdmin,
    handleSuperadminDeleteContent,
  };
}

module.exports = { createSuperadminDeleteHandlers, assertPlatformAdmin, BOOTSTRAP_SUPERADMIN_EMAILS };
