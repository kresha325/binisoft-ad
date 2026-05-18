/** Explicit CORS for Flutter web (GitHub Pages) and local dev. */

const ALLOWED_ORIGIN_PATTERNS = [
  /^https:\/\/kresha325\.github\.io$/,
  /^http:\/\/localhost(:\d+)?$/,
  /^http:\/\/127\.0\.0\.1(:\d+)?$/,
  /^https:\/\/jon-sport[a-z0-9-]*\.web\.app$/,
  /^https:\/\/jon-sport[a-z0-9-]*\.firebaseapp\.com$/,
];

function isAllowedOrigin(origin) {
  if (!origin || typeof origin !== 'string') return false;
  return ALLOWED_ORIGIN_PATTERNS.some((re) => re.test(origin));
}

function applyCors(req, res) {
  const origin = req.headers.origin;
  if (isAllowedOrigin(origin)) {
    res.set('Access-Control-Allow-Origin', origin);
    res.set('Vary', 'Origin');
    res.set('Access-Control-Allow-Credentials', 'true');
  }
  res.set('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS');
  res.set(
    'Access-Control-Allow-Headers',
    'Authorization, Content-Type, Accept, X-Demo-Setup, x-demo-setup, X-Requested-With',
  );
  res.set('Access-Control-Max-Age', '3600');
}

/** Wrap Cloud Function handlers so preflight and responses include CORS headers. */
function withCors(handler) {
  return async (req, res) => {
    applyCors(req, res);
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }
    return handler(req, res);
  };
}

module.exports = { applyCors, withCors, isAllowedOrigin };
