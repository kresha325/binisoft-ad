const ALLOWED_SECTION_IDS = new Set([
  'hero',
  'offers',
  'contests',
  'jobOpenings',
  'products',
  'services',
  'about',
  'gallery',
  'contact',
]);

const ALLOWED_CTA_TARGETS = new Set([
  'products',
  'services',
  'contact',
  'offers',
  'contests',
  'jobOpenings',
  'whatsapp',
]);

const ctaPresets = require('./siteCtaPresets');

const ALLOWED_SOCIAL = new Set([
  'facebook',
  'instagram',
  'tiktok',
  'youtube',
  'linkedin',
  'x',
  'whatsapp',
]);

const HEX_COLOR = /^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/;

const MAX_GALLERY_ITEMS = 8;

function clip(str, max) {
  if (str == null) return '';
  return String(str).trim().slice(0, max);
}

function sanitizeColor(value, fallback) {
  const v = clip(value, 9);
  return HEX_COLOR.test(v) ? v : fallback;
}

function sanitizeText(value, max = 500) {
  return clip(value, max).replace(/<[^>]*>/g, '');
}

function sanitizeUrl(value, max = 500) {
  const u = clip(value, max);
  if (!u) return '';
  if (/^https?:\/\//i.test(u)) return u;
  if (/^www\./i.test(u)) return `https://${u}`;
  return u;
}

function sanitizeYoutube(value) {
  const u = clip(value, 200);
  if (!u) return '';
  if (/^https?:\/\//i.test(u) || u.includes('youtube.com') || u.includes('youtu.be')) {
    return u;
  }
  const id = u.replace(/[^a-zA-Z0-9_-]/g, '').slice(0, 20);
  if (!id) return '';
  return `https://www.youtube.com/embed/${id}`;
}

function defaultSiteConfig() {
  return {
    theme: {
      primary: '#1c1917',
      accent: '#ff6b35',
      background: '#ffffff',
      text: '#1c1917',
    },
    layout: 'default',
    sections: [
      { id: 'hero', enabled: true, useProfileCover: true },
      { id: 'offers', enabled: true, title: 'Ofertat' },
      { id: 'contests', enabled: true, title: 'Konkurset' },
      { id: 'jobOpenings', enabled: true, title: 'Konkurse pune' },
      { id: 'products', enabled: true, title: 'Produktet' },
      { id: 'services', enabled: true, title: 'Shërbimet' },
      { id: 'about', enabled: true, title: 'Rreth nesh' },
      { id: 'gallery', enabled: true, title: 'Galeria', galleryItems: [] },
      { id: 'contact', enabled: true, title: 'Kontakt' },
    ],
    socials: [],
    footerShowLocation: true,
    footerShowPhone: true,
    footerShowWhatsApp: true,
  };
}

function mergeSections(saved) {
  const defaults = defaultSiteConfig().sections;
  const byId = new Map();
  if (Array.isArray(saved)) {
    for (const s of saved) {
      if (s && s.id && ALLOWED_SECTION_IDS.has(s.id)) byId.set(s.id, s);
    }
  }
  return defaults.map((d) => ({ ...d, ...(byId.get(d.id) || {}) }));
}

/**
 * Sanitize siteConfig from Firestore for public API.
 */
function sanitizeCtaTarget(value) {
  const v = clip(value, 20);
  return ALLOWED_CTA_TARGETS.has(v) ? v : '';
}

function publicSiteConfig(raw, businessType = '') {
  if (!raw || typeof raw !== 'object') {
    const base = defaultSiteConfig();
    return {
      ...base,
      sections: ctaPresets.enrichSections(base.sections, businessType),
    };
  }

  const themeIn = raw.theme && typeof raw.theme === 'object' ? raw.theme : {};
  const mergedSections = mergeSections(raw.sections);

  const sections = mergedSections.map((s) => {
    const out = {
      id: s.id,
      enabled: s.enabled !== false,
      useProfileCover: s.useProfileCover !== false,
    };
    const title = sanitizeText(s.title, 120);
    const description = sanitizeText(s.description, 800);
    const navLabel = sanitizeText(s.navLabel, 40);
    const ctaLabel = sanitizeText(s.ctaLabel, 60);
    const secondaryCtaLabel = sanitizeText(s.secondaryCtaLabel, 60);
    if (title) out.title = title;
    if (description) out.description = description;
    if (navLabel) out.navLabel = navLabel;
    if (ctaLabel) out.ctaLabel = ctaLabel;
    if (secondaryCtaLabel) out.secondaryCtaLabel = secondaryCtaLabel;
    const ctaTarget = sanitizeCtaTarget(s.ctaTarget);
    const secondaryCtaTarget = sanitizeCtaTarget(s.secondaryCtaTarget);
    if (ctaTarget) out.ctaTarget = ctaTarget;
    if (secondaryCtaTarget) out.secondaryCtaTarget = secondaryCtaTarget;
    if (s.id === 'hero' && Array.isArray(s.trustBullets)) {
      out.trustBullets = s.trustBullets
        .map((t) => sanitizeText(t, 80))
        .filter(Boolean)
        .slice(0, 5);
    }
    if (s.id === 'hero') {
      const imageUrl = sanitizeUrl(s.imageUrl);
      if (imageUrl) out.imageUrl = imageUrl;
    }
    if (s.id === 'gallery' && Array.isArray(s.galleryItems)) {
      out.galleryItems = s.galleryItems.slice(0, MAX_GALLERY_ITEMS).map((g) => {
        const item = {};
        const img = sanitizeUrl(g?.imageUrl);
        const yt = sanitizeYoutube(g?.youtubeUrl);
        const cap = sanitizeText(g?.caption, 120);
        if (img) item.imageUrl = img;
        if (yt) item.youtubeUrl = yt;
        if (cap) item.caption = cap;
        return item;
      }).filter((g) => g.imageUrl || g.youtubeUrl);
    }
    return out;
  });

  const socials = [];
  if (Array.isArray(raw.socials)) {
    for (const s of raw.socials) {
      const platform = clip(s?.platform, 20).toLowerCase();
      const url = sanitizeUrl(s?.url);
      if (!ALLOWED_SOCIAL.has(platform) || !url) continue;
      socials.push({ platform, url });
    }
  }

  const enrichedSections = ctaPresets.enrichSections(sections, businessType);

  return {
    theme: {
      primary: sanitizeColor(themeIn.primary, '#0a1628'),
      accent: sanitizeColor(themeIn.accent, '#f5c518'),
      background: sanitizeColor(themeIn.background, '#ffffff'),
      text: sanitizeColor(themeIn.text, '#111827'),
    },
    layout: raw.layout === 'wide' ? 'wide' : 'default',
    sections: enrichedSections,
    socials,
    footerShowLocation: raw.footerShowLocation !== false,
    footerShowPhone: raw.footerShowPhone !== false,
    footerShowWhatsApp: raw.footerShowWhatsApp !== false,
  };
}

module.exports = {
  publicSiteConfig,
  defaultSiteConfig,
};
