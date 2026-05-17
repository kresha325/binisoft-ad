/**
 * Wipes test users/businesses from jon-sport. Keeps bootstrap superadmin.
 * Uses Firebase CLI login tokens (~/.config/configstore/firebase-tools.json).
 *
 * Run: cd functions && node scripts/wipe-test-data.mjs
 */
import { readFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';
import { initializeApp, refreshToken } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';

const PROJECT_ID = 'jon-sport';
const BOOTSTRAP_EMAIL = 'kreshnik.sh.gashi@hotmail.com';

function loadFirebaseCliRefreshToken() {
  const path = join(homedir(), '.config/configstore/firebase-tools.json');
  const config = JSON.parse(readFileSync(path, 'utf8'));
  const { refresh_token } = config.tokens ?? {};
  if (!refresh_token) {
    throw new Error('No Firebase CLI refresh token. Run: firebase login');
  }
  return refresh_token;
}

initializeApp({
  projectId: PROJECT_ID,
  credential: refreshToken({
    type: 'authorized_user',
    client_id: '563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com',
    client_secret: 'j9pVycW6ZwxvMEPGi4s1wuI',
    refresh_token: loadFirebaseCliRefreshToken(),
  }),
});

const db = getFirestore();
const auth = getAuth();

async function deleteQueryBatch(query) {
  const snap = await query.limit(400).get();
  if (snap.empty) return 0;
  const batch = db.batch();
  for (const doc of snap.docs) batch.delete(doc.ref);
  await batch.commit();
  return snap.size;
}

async function deleteCollection(collRef) {
  let total = 0;
  while (true) {
    const n = await deleteQueryBatch(collRef);
    if (n === 0) break;
    total += n;
  }
  return total;
}

async function wipeBusiness(businessId) {
  const base = db.collection('businesses').doc(businessId);
  for (const sub of ['products', 'categories', 'attributes']) {
    await deleteCollection(base.collection(sub));
  }
}

async function main() {
  console.log(`\nWiping test data on ${PROJECT_ID} (keeping ${BOOTSTRAP_EMAIL})…\n`);

  const businesses = await db.collection('businesses').get();
  for (const doc of businesses.docs) {
    console.log(`Business: ${doc.data().name || doc.id}`);
    await wipeBusiness(doc.id);
    const slug = doc.data().slug;
    if (slug) await db.collection('slugs').doc(slug).delete().catch(() => {});
    await doc.ref.delete();
  }
  console.log(`Deleted ${businesses.size} business(es)`);

  const users = await db.collection('users').get();
  let kept = 0;
  let removed = 0;
  for (const doc of users.docs) {
    const email = (doc.data().email || '').toLowerCase();
    if (email === BOOTSTRAP_EMAIL.toLowerCase()) {
      await doc.ref.update({
        businessId: '',
        role: 'superadmin',
        maxBusinesses: 100,
        maxProducts: 100000,
      });
      await deleteCollection(doc.ref.collection('notifications'));
      console.log(`Kept Firestore user: ${email}`);
      kept++;
      continue;
    }
    await deleteCollection(doc.ref.collection('notifications'));
    await doc.ref.delete();
    console.log(`Deleted Firestore user: ${email || doc.id}`);
    removed++;
  }

  let authDeleted = 0;
  let nextPageToken;
  do {
    const list = await auth.listUsers(1000, nextPageToken);
    for (const user of list.users) {
      if (user.email?.toLowerCase() === BOOTSTRAP_EMAIL.toLowerCase()) continue;
      await auth.deleteUser(user.uid);
      console.log(`Deleted Auth: ${user.email || user.uid}`);
      authDeleted++;
    }
    nextPageToken = list.pageToken;
  } while (nextPageToken);

  await deleteCollection(db.collection('mail'));
  await deleteCollection(db.collection('slugs'));

  console.log(`\nDone — businesses: ${businesses.size}, users removed: ${removed}, auth removed: ${authDeleted}, superadmin kept: ${kept}\n`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
