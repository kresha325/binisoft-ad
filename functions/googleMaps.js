/** @param {string | null | undefined} input */
function googleMapsEmbedUrl(input) {
  const raw = String(input || '').trim();
  if (!raw) return '';
  if (raw.includes('/maps/embed')) return raw;

  const atCoords = raw.match(/@(-?\d+\.?\d*),(-?\d+\.?\d*)/);
  if (atCoords) {
    return `https://www.google.com/maps?q=${atCoords[1]},${atCoords[2]}&z=15&output=embed`;
  }

  const qParam = raw.match(/[?&]q=([^&]+)/);
  if (qParam) {
    return `https://www.google.com/maps?q=${decodeURIComponent(qParam[1])}&output=embed`;
  }

  if (raw.startsWith('http')) {
    return `https://www.google.com/maps?q=${encodeURIComponent(raw)}&output=embed`;
  }

  return `https://www.google.com/maps?q=${encodeURIComponent(raw)}&output=embed`;
}

module.exports = { googleMapsEmbedUrl };
