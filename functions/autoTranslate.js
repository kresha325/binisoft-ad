const { HttpsError } = require('firebase-functions/v2/https');

const SUPPORTED = new Set(['sq', 'en', 'de']);

/** Simple fallback when Cloud Translation API is unavailable (dev / demo). */
const DEMO_PHRASES = {
  sq: {
    en: {
      Elektronikë: 'Electronics',
      'Pajisje elektronike': 'Electronic devices',
    },
    de: {
      Elektronikë: 'Elektronik',
      'Pajisje elektronike': 'Elektronische Geräte',
    },
  },
  en: {
    sq: {
      Electronics: 'Elektronikë',
      'Electronic devices': 'Pajisje elektronike',
    },
    de: {
      Electronics: 'Elektronik',
      'Electronic devices': 'Elektronische Geräte',
    },
  },
};

async function translateWithGoogle(text, target, source) {
  const apiKey = process.env.GOOGLE_TRANSLATE_API_KEY;
  if (!apiKey) return null;

  const params = new URLSearchParams({
    q: text,
    target,
    format: 'text',
    key: apiKey,
  });
  if (source) params.set('source', source);

  const res = await fetch(
    `https://translation.googleapis.com/language/translate/v2?${params.toString()}`,
  );
  if (!res.ok) return null;
  const body = await res.json();
  return body?.data?.translations?.[0]?.translatedText ?? null;
}

function demoTranslate(text, source, target) {
  const map = DEMO_PHRASES[source]?.[target];
  if (map && map[text]) return map[text];
  return `[${target.toUpperCase()}] ${text}`;
}

async function translateText(text, target, source) {
  const trimmed = (text || '').trim();
  if (!trimmed) return '';

  const google = await translateWithGoogle(trimmed, target, source);
  if (google) return google;

  return demoTranslate(trimmed, source, target);
}

function createAutoTranslateHandlers({ verifyAuth, assertBusinessMember, sendError }) {
  async function handleAutoTranslateCatalog(req, res) {
    if (req.method !== 'POST') {
      res.status(405).json({ error: { message: 'Method not allowed' } });
      return;
    }

    try {
      const decoded = await verifyAuth(req);
      const businessId = req.body?.businessId;
      if (!businessId || typeof businessId !== 'string') {
        throw new HttpsError('invalid-argument', 'businessId is required');
      }
      await assertBusinessMember(decoded.uid, businessId);

      const sourceLocale = (req.body?.sourceLocale || '').toLowerCase();
      const targetLocales = Array.isArray(req.body?.targetLocales)
        ? req.body.targetLocales.map((l) => String(l).toLowerCase())
        : [];
      const fields = req.body?.fields && typeof req.body.fields === 'object'
        ? req.body.fields
        : {};

      if (!SUPPORTED.has(sourceLocale)) {
        throw new HttpsError('invalid-argument', 'Invalid sourceLocale');
      }
      const targets = targetLocales.filter((l) => SUPPORTED.has(l) && l !== sourceLocale);
      if (targets.length === 0) {
        throw new HttpsError('invalid-argument', 'targetLocales required');
      }

      const fieldKeys = ['name', 'title', 'description', 'seoTitle', 'seoDescription'];
      const translations = {};

      for (const target of targets) {
        translations[target] = {};
        for (const key of fieldKeys) {
          const sourceText = fields[key];
          if (typeof sourceText !== 'string' || !sourceText.trim()) continue;
          translations[target][key] = await translateText(
            sourceText,
            target,
            sourceLocale,
          );
        }
      }

      res.status(200).json({
        ok: true,
        translations,
        provider: process.env.GOOGLE_TRANSLATE_API_KEY ? 'google' : 'demo',
      });
    } catch (err) {
      sendError(res, err);
    }
  }

  return { handleAutoTranslateCatalog };
}

module.exports = { createAutoTranslateHandlers, translateText };
