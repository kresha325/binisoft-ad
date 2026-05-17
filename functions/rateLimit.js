const { HttpsError } = require('firebase-functions/v2/https');

/** In-memory sliding window per Cloud Function instance (basic abuse protection). */
const buckets = new Map();

function clientIp(req) {
  const forwarded = req.headers['x-forwarded-for'];
  if (typeof forwarded === 'string' && forwarded.length > 0) {
    return forwarded.split(',')[0].trim();
  }
  return req.ip || req.socket?.remoteAddress || 'unknown';
}

/**
 * @param {string} key
 * @param {{ max?: number, windowMs?: number }} [opts]
 */
function checkRateLimit(key, opts = {}) {
  const max = opts.max ?? 120;
  const windowMs = opts.windowMs ?? 60_000;
  const now = Date.now();

  let bucket = buckets.get(key);
  if (!bucket || now >= bucket.resetAt) {
    bucket = { count: 0, resetAt: now + windowMs };
    buckets.set(key, bucket);
  }

  bucket.count += 1;
  if (bucket.count > max) {
    throw new HttpsError(
      'resource-exhausted',
      'Too many requests. Please try again shortly.',
    );
  }
}

module.exports = { clientIp, checkRateLimit };
