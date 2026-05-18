/**
 * Structured logging for public API failures (visible in Cloud Logging).
 */
function logPublicApiError({ slug, resource, method, statusCode, code, message }) {
  console.error(
    JSON.stringify({
      type: 'public_api_error',
      slug: slug || '',
      resource: resource || '',
      method: method || '',
      statusCode: statusCode || 500,
      code: code || 'internal',
      message: message || 'Unknown error',
      at: new Date().toISOString(),
    }),
  );
}

module.exports = { logPublicApiError };
