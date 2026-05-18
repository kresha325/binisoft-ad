/** Catalog languages exposed on the public API. */
const SUPPORTED_LOCALES = ['sq', 'en', 'de'];
const DEFAULT_LOCALE = 'sq';

function normalizeLocale(raw) {
  if (!raw || typeof raw !== 'string') return null;
  const code = raw.trim().toLowerCase().split(/[-_]/)[0];
  return SUPPORTED_LOCALES.includes(code) ? code : null;
}

function parseI18nMap(raw) {
  if (!raw || typeof raw !== 'object' || Array.isArray(raw)) return {};
  const out = {};
  for (const [key, value] of Object.entries(raw)) {
    const locale = normalizeLocale(key);
    if (!locale) continue;
    if (typeof value === 'string' && value.trim()) out[locale] = value.trim();
  }
  return out;
}

function readPrimary(raw) {
  if (typeof raw === 'string') return raw.trim();
  if (raw && typeof raw === 'object' && !Array.isArray(raw)) {
    for (const value of Object.values(raw)) {
      if (typeof value === 'string' && value.trim()) return value.trim();
    }
  }
  return '';
}

function resolveLocalized({ primary, i18n, locale, defaultLocale }) {
  const map = parseI18nMap(i18n);
  if (map[locale]) return map[locale];

  const primaryText = readPrimary(primary);
  if (primaryText) return primaryText;

  const fallback = map[defaultLocale];
  if (fallback) return fallback;

  for (const code of SUPPORTED_LOCALES) {
    if (map[code]) return map[code];
  }
  return '';
}

function resolveBusinessLocales(business) {
  const defaultLocale = normalizeLocale(business.defaultLocale) || DEFAULT_LOCALE;
  let locales = Array.isArray(business.locales)
    ? business.locales.map(normalizeLocale).filter(Boolean)
    : [...SUPPORTED_LOCALES];
  if (locales.length === 0) locales = [...SUPPORTED_LOCALES];
  if (!locales.includes(defaultLocale)) locales = [defaultLocale, ...locales];
  return { defaultLocale, locales: [...new Set(locales)] };
}

function pickRequestLocale(req, business) {
  const { defaultLocale, locales } = business
    ? resolveBusinessLocales(business)
    : { defaultLocale: DEFAULT_LOCALE, locales: [...SUPPORTED_LOCALES] };
  const requested = normalizeLocale(req.query.lang || req.query.locale);
  const locale =
    requested && locales.includes(requested) ? requested : defaultLocale;
  return { locale, defaultLocale, locales, requested };
}

function apiMeta(ctx) {
  return {
    locale: ctx.locale,
    defaultLocale: ctx.defaultLocale,
    locales: ctx.locales,
    requestedLocale: ctx.requested || ctx.locale,
  };
}

/** Shop-facing URL slug for the active locale (internal slug stays canonical). */
function resolveUrlSlug(data, locale) {
  const internal = typeof data.slug === 'string' ? data.slug.trim() : '';
  const map = parseI18nMap(data.localizedSlugs);
  const localized = map[locale];
  return localized || internal;
}

module.exports = {
  SUPPORTED_LOCALES,
  DEFAULT_LOCALE,
  normalizeLocale,
  parseI18nMap,
  resolveLocalized,
  resolveBusinessLocales,
  pickRequestLocale,
  apiMeta,
  resolveUrlSlug,
};
