const { getFirestore } = require('firebase-admin/firestore');
const siteConfigModule = require('./siteConfig');

/**
 * Platform shop catalog (same data superadmin manages in Firestore).
 * GET /api/shop/businesses
 */
async function listShopBusinesses() {
  const db = getFirestore();
  const snap = await db.collection('businesses').get();
  const businesses = [];

  for (const doc of snap.docs) {
    const data = doc.data();
    if (data.active === false) continue;
    const slug = (data.slug || '').trim();
    if (!slug) continue;
    businesses.push({
      id: doc.id,
      name: data.name || slug,
      slug,
      description: data.description || '',
      logoUrl: data.logoUrl || '',
      coverImageUrl: data.coverImageUrl || '',
      location: data.location || '',
      siteDeployUrl: data.siteDeployUrl || '',
      siteConfig: siteConfigModule.publicSiteConfig(data.siteConfig),
    });
  }

  businesses.sort((a, b) => a.name.localeCompare(b.name, 'sq'));
  return { businesses, count: businesses.length };
}

module.exports = { listShopBusinesses };
