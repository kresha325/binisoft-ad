const pricing = require('./pricing');
const i18n = require('./i18n');

function isJobOpeningActive(opening, nowMs = Date.now()) {
  if (opening.active === false) return false;
  return pricing.isOfferActive(opening, nowMs);
}

function serializeJobOpening(doc, ctx) {
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
    requirements: i18n.resolveLocalized({
      primary: d.requirements,
      i18n: d.requirementsI18n,
      locale: ctx.locale,
      defaultLocale: ctx.defaultLocale,
    }),
    location: d.location || null,
    employmentType: d.employmentType || null,
    salaryHint: d.salaryHint || null,
    applyEmail: d.applyEmail || null,
    applyUrl: d.applyUrl || null,
    imageUrl: d.imageUrl || null,
    durationDays: d.durationDays ?? null,
    startsAt: startsAt?.toDate?.()?.toISOString?.() || null,
    endsAt: endsAt?.toDate?.()?.toISOString?.() || null,
    applicationCount: d.applicationCount ?? 0,
  };
}

/**
 * POST public job application (name + phone required).
 * @returns {Promise<{ applicationId: string }>}
 */
async function createJobApplication(db, businessId, jobOpeningId, body) {
  const name = String(body.name || '').trim();
  const phone = String(body.phone || '').trim();
  const email = String(body.email || '').trim();
  const note = String(body.note || '').trim();

  if (name.length < 2 || phone.length < 6) {
    const err = new Error('Name and phone are required.');
    err.code = 'invalid-argument';
    throw err;
  }

  const openingRef = db.doc(`businesses/${businessId}/jobOpenings/${jobOpeningId}`);
  const openingSnap = await openingRef.get();
  if (!openingSnap.exists) {
    const err = new Error('Job opening not found.');
    err.code = 'not-found';
    throw err;
  }

  const opening = { id: openingSnap.id, ...openingSnap.data() };
  if (!isJobOpeningActive(opening)) {
    const err = new Error('Job opening is not accepting applications.');
    err.code = 'failed-precondition';
    throw err;
  }

  const appRef = openingRef.collection('applications').doc();
  await appRef.set({
    jobOpeningId,
    name,
    phone,
    ...(email ? { email } : {}),
    ...(note ? { note } : {}),
    createdAt: require('firebase-admin/firestore').FieldValue.serverTimestamp(),
  });

  await openingRef.update({
    applicationCount: require('firebase-admin/firestore').FieldValue.increment(1),
  });

  return { applicationId: appRef.id };
}

module.exports = {
  isJobOpeningActive,
  serializeJobOpening,
  createJobApplication,
};
