const IFRAME_SRC_RE = /<iframe[^>]+src\s*=\s*["']([^"']+)["']/i;
const HTTP_URL_RE = /https?:\/\/[^\s"'<>]+/;

/** Extract HTTPS maps URL from share link or legacy iframe HTML. */
function extractGoogleMapsUrl(input) {
  const raw = String(input || '').trim();
  if (!raw) return '';

  const iframe = raw.match(IFRAME_SRC_RE);
  if (iframe) return iframe[1].trim();

  if (/<\s*iframe/i.test(raw) || raw.includes('</iframe>')) {
    return '';
  }

  if (raw.startsWith('http://') || raw.startsWith('https://')) {
    const end = raw.search(/[\s"'<>]/);
    return (end > 0 ? raw.slice(0, end) : raw).trim();
  }

  const http = raw.match(HTTP_URL_RE);
  return http ? http[0].trim() : '';
}

/** @param {string | null | undefined} input */
function googleMapsEmbedUrl(input) {
  const raw = extractGoogleMapsUrl(input);
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

module.exports = { extractGoogleMapsUrl, googleMapsEmbedUrl };
