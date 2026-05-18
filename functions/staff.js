const { HttpsError } = require('firebase-functions/v2/https');
const { getAuth } = require('firebase-admin/auth');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { randomBytes } = require('crypto');

const STAFF_ROLES = new Set(['manager', 'employee']);

function normalizeEmail(email) {
  return String(email || '').trim().toLowerCase();
}

function generateInviteCode() {
  return randomBytes(4).toString('hex').toUpperCase();
}

async function getUserProfile(db, uid) {
  const snap = await db.doc(`users/${uid}`).get();
  if (!snap.exists) {
    throw new HttpsError('not-found', 'User profile not found');
  }
  return snap.data();
}

async function assertCanManageTeam(db, uid, businessId) {
  const [userSnap, businessSnap] = await Promise.all([
    db.doc(`users/${uid}`).get(),
    db.doc(`businesses/${businessId}`).get(),
  ]);

  if (!businessSnap.exists) {
    throw new HttpsError('not-found', 'Business not found');
  }

  const business = businessSnap.data();
  if (business.ownerId === uid) return business;

  if (!userSnap.exists) {
    throw new HttpsError('permission-denied', 'Not allowed');
  }

  const role = userSnap.data().role;
  const activeBusiness = userSnap.data().businessId;
  if (activeBusiness === businessId && ['owner', 'admin'].includes(role)) {
    return business;
  }

  throw new HttpsError('permission-denied', 'Only the store owner or admin can manage team');
}

async function writeMember(db, businessId, memberUid, { email, role, displayName }) {
  await db.doc(`businesses/${businessId}/members/${memberUid}`).set(
    {
      email,
      role,
      displayName: displayName || '',
      joinedAt: FieldValue.serverTimestamp(),
    },
    { merge: true },
  );
}

async function assignStaffProfile(db, {
  uid,
  email,
  businessId,
  role,
  ownerUser,
  displayName,
}) {
  if (!STAFF_ROLES.has(role)) {
    throw new HttpsError('invalid-argument', 'Invalid staff role');
  }

  await db.doc(`users/${uid}`).set(
    {
      email: normalizeEmail(email),
      businessId,
      role,
      maxBusinesses: 0,
      maxProducts: ownerUser.maxProducts ?? 100,
      displayName: displayName || ownerUser.displayName || '',
    },
    { merge: true },
  );

  await writeMember(db, businessId, uid, {
    email: normalizeEmail(email),
    role,
    displayName: displayName || '',
  });
}

async function inviteStaff(db, auth, { callerUid, businessId, email, role }) {
  const business = await assertCanManageTeam(db, callerUid, businessId);
  const normalized = normalizeEmail(email);
  if (!normalized) {
    throw new HttpsError('invalid-argument', 'Email is required');
  }
  if (!STAFF_ROLES.has(role)) {
    throw new HttpsError('invalid-argument', 'Role must be manager or employee');
  }

  const ownerSnap = await db.doc(`users/${business.ownerId}`).get();
  const ownerUser = ownerSnap.exists ? ownerSnap.data() : { maxProducts: 100 };

  if (normalized === normalizeEmail(ownerSnap.data()?.email)) {
    throw new HttpsError('invalid-argument', 'Cannot invite the store owner as staff');
  }

  try {
    const existing = await auth.getUserByEmail(normalized);
    if (existing.uid === business.ownerId) {
      throw new HttpsError('invalid-argument', 'This user owns the store');
    }

    const existingProfile = await db.doc(`users/${existing.uid}`).get();
    if (existingProfile.exists) {
      const data = existingProfile.data();
      if (data.role === 'superadmin') {
        throw new HttpsError('invalid-argument', 'Cannot invite a platform admin');
      }
      if (data.businessId && data.businessId !== businessId && data.maxBusinesses > 0) {
        throw new HttpsError(
          'failed-precondition',
          'User already has their own admin account on another store',
        );
      }
    }

    await assignStaffProfile(db, {
      uid: existing.uid,
      email: normalized,
      businessId,
      role,
      ownerUser,
      displayName: existing.displayName || '',
    });

    return {
      status: 'assigned',
      userId: existing.uid,
      message: 'Team member added. They can sign in with their existing account.',
    };
  } catch (err) {
    if (err.code !== 'auth/user-not-found') {
      throw err;
    }
  }

  const code = generateInviteCode();
  const inviteRef = db.collection('invites').doc();
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

  await inviteRef.set({
    email: normalized,
    role,
    code,
    businessId,
    businessName: business.name || '',
    createdBy: callerUid,
    createdAt: FieldValue.serverTimestamp(),
    expiresAt,
    used: false,
  });

  return {
    status: 'invite_created',
    inviteId: inviteRef.id,
    code,
    message: 'No account yet. Share the invite code below — they register at Join team.',
  };
}

async function removeStaff(db, { callerUid, businessId, memberUid }) {
  await assertCanManageTeam(db, callerUid, businessId);

  if (memberUid === callerUid) {
    throw new HttpsError('invalid-argument', 'Cannot remove yourself');
  }

  const businessSnap = await db.doc(`businesses/${businessId}`).get();
  if (businessSnap.data()?.ownerId === memberUid) {
    throw new HttpsError('invalid-argument', 'Cannot remove the store owner');
  }

  const memberSnap = await db.doc(`businesses/${businessId}/members/${memberUid}`).get();
  if (!memberSnap.exists) {
    throw new HttpsError('not-found', 'Team member not found');
  }

  await db.doc(`businesses/${businessId}/members/${memberUid}`).delete();

  const userRef = db.doc(`users/${memberUid}`);
  const userSnap = await userRef.get();
  if (userSnap.exists && userSnap.data().businessId === businessId) {
    await userRef.update({
      businessId: '',
      role: 'employee',
    });
  }

  return { ok: true };
}

async function acceptInvite(db, auth, { uid, code, email }) {
  const normalized = normalizeEmail(email);
  const trimmedCode = String(code || '')
    .trim()
    .toUpperCase();
  if (!trimmedCode || !normalized) {
    throw new HttpsError('invalid-argument', 'Invite code and email are required');
  }

  const invitesSnap = await db
    .collection('invites')
    .where('code', '==', trimmedCode)
    .where('used', '==', false)
    .limit(10)
    .get();

  const inviteDoc = invitesSnap.docs.find(
    (doc) => normalizeEmail(doc.data().email) === normalized,
  );

  if (!inviteDoc) {
    throw new HttpsError('not-found', 'Invalid or expired invite code');
  }

  const invite = inviteDoc.data();
  const expiresAt = invite.expiresAt?.toDate?.() ?? null;
  if (expiresAt && expiresAt.getTime() < Date.now()) {
    throw new HttpsError('failed-precondition', 'Invite code has expired');
  }

  const businessId = invite.businessId;
  const businessSnap = await db.doc(`businesses/${businessId}`).get();
  if (!businessSnap.exists) {
    throw new HttpsError('not-found', 'Store not found');
  }

  const ownerSnap = await db.doc(`users/${businessSnap.data().ownerId}`).get();
  const ownerUser = ownerSnap.exists ? ownerSnap.data() : { maxProducts: 100 };

  let userRecord;
  try {
    userRecord = await auth.getUser(uid);
  } catch (_) {
    throw new HttpsError('unauthenticated', 'Sign in required');
  }

  if (normalizeEmail(userRecord.email) !== normalized) {
    throw new HttpsError('permission-denied', 'Email does not match the invite');
  }

  await assignStaffProfile(db, {
    uid,
    email: normalized,
    businessId,
    role: invite.role,
    ownerUser,
    displayName: userRecord.displayName || '',
  });

  await inviteDoc.ref.update({
    used: true,
    usedBy: uid,
    usedAt: FieldValue.serverTimestamp(),
  });

  return {
    ok: true,
    businessId,
    role: invite.role,
    businessName: invite.businessName || businessSnap.data().name || '',
  };
}

module.exports = {
  inviteStaff,
  removeStaff,
  acceptInvite,
  STAFF_ROLES,
  normalizeEmail,
  generateInviteCode,
};
