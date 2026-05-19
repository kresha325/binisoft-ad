/** @param {{ city?: string, state?: string, location?: string }} business */
function displayLocation(business) {
  const c = String(business.city || '').trim();
  const s = String(business.state || '').trim();
  if (c && s) return `${c}, ${s}`;
  if (c) return c;
  if (s) return s;
  return String(business.location || '').trim();
}

module.exports = { displayLocation };
