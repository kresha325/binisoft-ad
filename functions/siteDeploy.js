const { HttpsError } = require('firebase-functions/v2/https');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');

const TEMPLATE_ID = 'market-v1';
const DEFAULT_SHOP_BASE =
  process.env.PUBLIC_SHOP_BASE || 'https://kresha325.github.io/Binisoft-marketplace';

function defaultSiteUrl(slug) {
  return `${DEFAULT_SHOP_BASE.replace(/\/$/, '')}/${slug}`;
}

function dnsInstructionsForDomain(customDomain, deployUrl) {
  if (!customDomain) return null;
  return {
    domain: customDomain,
    records: [
      {
        type: 'CNAME',
        name: customDomain.startsWith('www.') ? 'www' : '@',
        value: 'kresha325.github.io',
        note:
          'Te GoDaddy (DNS Management): shto këtë CNAME. Propagimi 5 min – 48 orë. Pastaj aktivizo SSL te Netlify/Firebase.',
      },
    ],
    deployUrl,
  };
}

async function netlifyAddCustomDomain({ siteId, domain, token }) {
  const res = await fetch(`https://api.netlify.com/api/v1/sites/${siteId}/domains`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ domain }),
  });
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Netlify domain failed (${res.status}): ${text}`);
  }
  return res.json();
}

async function triggerNetlifyBuildHook(hookUrl) {
  const res = await fetch(hookUrl, { method: 'POST' });
  if (!res.ok) {
    throw new Error(`Build hook failed (${res.status})`);
  }
}

/**
 * POST { businessId, customDomain? }
 * Publishes / refreshes the business storefront URL and optional custom domain.
 */
async function handleDeployBusinessSite(req, res, { verifyAuth, assertBusinessMember, sendError }) {
  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: { message: 'Method not allowed' } });
    return;
  }

  try {
    const decoded = await verifyAuth(req);
    const { businessId, customDomain: rawDomain } = req.body || {};
    if (!businessId) {
      throw new HttpsError('invalid-argument', 'businessId is required');
    }

    await assertBusinessMember(decoded.uid, businessId);

    const db = getFirestore();
    const ref = db.doc(`businesses/${businessId}`);
    const snap = await ref.get();
    if (!snap.exists) {
      throw new HttpsError('not-found', 'Business not found');
    }

    const data = snap.data();
    const slug = String(data.slug || '').trim();
    if (!slug) {
      throw new HttpsError('failed-precondition', 'Business needs a URL slug first');
    }

    const customDomain = String(rawDomain || data.siteCustomDomain || '')
      .trim()
      .toLowerCase()
      .replace(/^https?:\/\//, '')
      .replace(/\/$/, '');

    const siteDeployUrl = defaultSiteUrl(slug);
    let deployStatus = 'live';
    let deployError = null;

    const netlifyToken = process.env.NETLIFY_AUTH_TOKEN || '';
    const netlifySiteId = data.netlifySiteId || process.env.NETLIFY_SITE_ID || '';
    const buildHookUrl = process.env.NETLIFY_BUILD_HOOK_URL || '';

    if (buildHookUrl) {
      try {
        await triggerNetlifyBuildHook(buildHookUrl);
        deployStatus = 'pending';
      } catch (err) {
        deployError = err.message;
        deployStatus = 'failed';
      }
    }

    if (customDomain && netlifyToken && netlifySiteId) {
      try {
        await netlifyAddCustomDomain({
          siteId: netlifySiteId,
          domain: customDomain,
          token: netlifyToken,
        });
      } catch (err) {
        deployError = deployError ? `${deployError}; ${err.message}` : err.message;
      }
    }

    await ref.update({
      siteTemplateId: TEMPLATE_ID,
      siteDeployUrl,
      siteCustomDomain: customDomain,
      siteDeployStatus: deployStatus,
      siteLastDeployAt: FieldValue.serverTimestamp(),
      ...(deployError ? { siteDeployError: deployError } : { siteDeployError: '' }),
    });

    const dns = dnsInstructionsForDomain(customDomain, siteDeployUrl);

    res.status(200).json({
      ok: deployStatus !== 'failed',
      templateId: TEMPLATE_ID,
      slug,
      siteUrl: siteDeployUrl,
      customDomain,
      deployStatus,
      deployError,
      dns,
      sections: ['hero', 'offers', 'products', 'services', 'about', 'contact'],
    });
  } catch (err) {
    sendError(res, err);
  }
}

module.exports = {
  handleDeployBusinessSite,
  defaultSiteUrl,
  TEMPLATE_ID,
};
