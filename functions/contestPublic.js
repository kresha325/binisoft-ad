const pricing = require('./pricing');
const i18n = require('./i18n');

function isContestActive(contest, nowMs = Date.now()) {
  if (contest.active === false) return false;
  return pricing.isOfferActive(contest, nowMs);
}

function serializeContest(doc, ctx) {
  const d = doc.data();
  const startsAt = d.startsAt;
  const endsAt = d.endsAt;
  return {
    id: doc.id,
    title: i18n.resolveLocalized({
      primary: d.title,
      i18n: d.titleI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    description: i18n.resolveLocalized({
      primary: d.description,
      i18n: d.descriptionI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    prize: i18n.resolveLocalized({
      primary: d.prize,
      i18n: d.prizeI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    rules: i18n.resolveLocalized({
      primary: d.rules,
      i18n: d.rulesI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    imageUrl: d.imageUrl || null,
    durationDays: d.durationDays ?? null,
    startsAt: startsAt?.toDate?.()?.toISOString?.() || null,
    endsAt: endsAt?.toDate?.()?.toISOString?.() || null,
    entryCount: d.entryCount ?? 0,
  };
}

/**
 * POST public contest entry (name + phone required).
 * @returns {Promise<{ entryId: string }>}
 */
async function createContestEntry(db, businessId, contestId, body) {
  const name = String(body.name || '').trim();
  const phone = String(body.phone || '').trim();
  const email = String(body.email || '').trim();
  const note = String(body.note || '').trim();

  if (name.length < 2 || phone.length < 6) {
    const err = new Error('Name and phone are required.');
    err.code = 'invalid-argument';
    throw err;
  }

  const contestRef = db.doc(`businesses/${businessId}/contests/${contestId}`);
  const contestSnap = await contestRef.get();
  if (!contestSnap.exists) {
    const err = new Error('Contest not found.');
    err.code = 'not-found';
    throw err;
  }

  const contest = { id: contestSnap.id, ...contestSnap.data() };
  if (!isContestActive(contest)) {
    const err = new Error('Contest is not open for entries.');
    err.code = 'failed-precondition';
    throw err;
  }

  const entryRef = contestRef.collection('entries').doc();
  await entryRef.set({
    contestId,
    name,
    phone,
    ...(email ? { email } : {}),
    ...(note ? { note } : {}),
    createdAt: require('firebase-admin/firestore').FieldValue.serverTimestamp(),
  });

  await contestRef.update({
    entryCount: require('firebase-admin/firestore').FieldValue.increment(1),
  });

  return { entryId: entryRef.id };
}

module.exports = {
  isContestActive,
  serializeContest,
  createContestEntry,
};
