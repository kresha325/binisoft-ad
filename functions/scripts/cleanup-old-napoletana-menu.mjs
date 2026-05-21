/**
 * Remove demo products/categories on napoletana-nostra that are not from Granit import.
 *
 * Run: cd functions && node scripts/cleanup-old-napoletana-menu.mjs
 */
import { readFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';

const PROJECT_ID = 'jon-sport';
const TARGET_SLUG = 'napoletana-nostra';
const GRANIT_ROOT = join(
  homedir(),
  'Projects/Napoletana/NapoletanaNostra-GranitBllaca',
);
const DATA_TS = join(GRANIT_ROOT, 'src/lib/data.ts');
const MENU_TS = join(GRANIT_ROOT, 'src/lib/product-menu.ts');

const EXPECTED_CATEGORY_SLUGS = new Set([
  'antipasti',
  'pasta',
  'pizza',
  'dolci',
  'bevande',
]);

const OAUTH_CLIENT_ID =
  '563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com';
const OAUTH_CLIENT_SECRET = 'j9pVycW6ZwxvMEPGi4s1wuI';

function loadFirebaseCliConfig() {
  const path = join(homedir(), '.config/configstore/firebase-tools.json');
  return JSON.parse(readFileSync(path, 'utf8'));
}

async function getAccessToken() {
  const { access_token, refresh_token, expires_at } =
    loadFirebaseCliConfig().tokens ?? {};
  if (access_token && expires_at && Date.now() < expires_at - 60_000) {
    return access_token;
  }
  if (!refresh_token) throw new Error('Run: firebase login');
  const res = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      client_id: OAUTH_CLIENT_ID,
      client_secret: OAUTH_CLIENT_SECRET,
      refresh_token,
      grant_type: 'refresh_token',
    }),
  });
  const data = await res.json();
  if (!data.access_token) {
    throw new Error(data.error_description || 'OAuth refresh failed');
  }
  return data.access_token;
}

async function runQuery(accessToken, structuredQuery) {
  const url = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents:runQuery`;
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ structuredQuery }),
  });
  const rows = await res.json();
  if (!res.ok) throw new Error(JSON.stringify(rows));
  return rows;
}

async function listCollection(accessToken, parentPath, collectionId) {
  const url = `https://firestore.googleapis.com/v1/${parentPath}/${collectionId}`;
  const res = await fetch(url, {
    headers: { Authorization: `Bearer ${accessToken}` },
  });
  const data = await res.json();
  if (!res.ok) throw new Error(JSON.stringify(data));
  return data.documents ?? [];
}

async function deleteDoc(accessToken, docPath) {
  const url = `https://firestore.googleapis.com/v1/${docPath}`;
  const res = await fetch(url, {
    method: 'DELETE',
    headers: { Authorization: `Bearer ${accessToken}` },
  });
  if (!res.ok) {
    const data = await res.json();
    throw new Error(JSON.stringify(data));
  }
}

function slugify(text) {
  return String(text || '')
    .trim()
    .toLowerCase()
    .normalize('NFD')
    .replace(/\p{M}/gu, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 80);
}

function parseMenuProducts() {
  const raw = readFileSync(DATA_TS, 'utf8');
  const items = [];
  const re =
    /\{\s*id:\s*"([^"]+)"[\s\S]*?key:\s*"([^"]+)"[\s\S]*?price:\s*([\d.]+)[\s\S]*?category:\s*"([^"]+)"[\s\S]*?image:\s*"([^"]+)"/g;
  let m;
  while ((m = re.exec(raw))) {
    items.push({ key: m[2], category: m[4] });
  }
  return items;
}

function parseProductLabels() {
  const raw = readFileSync(MENU_TS, 'utf8');
  const labels = {};
  const blockRe = /"([^"]+)":\s*\{\s*name:\s*"([^"]*)"(?:,\s*description:\s*"([^"]*)")?/g;
  let m;
  while ((m = blockRe.exec(raw))) {
    labels[m[1]] = { name: m[2] };
  }
  return labels;
}

function buildExpectedProductSlugs() {
  const menuItems = parseMenuProducts();
  const labels = parseProductLabels();
  const slugs = new Set();
  for (const item of menuItems) {
    const label = labels[item.key];
    slugs.add(slugify(label?.name || item.key));
  }
  return slugs;
}

function fieldString(doc, path) {
  return doc?.fields?.[path]?.stringValue ?? '';
}

async function main() {
  const expectedSlugs = buildExpectedProductSlugs();
  const accessToken = await getAccessToken();

  const bizRows = await runQuery(accessToken, {
    from: [{ collectionId: 'businesses' }],
    where: {
      fieldFilter: {
        field: { fieldPath: 'slug' },
        op: 'EQUAL',
        value: { stringValue: TARGET_SLUG },
      },
    },
    limit: 1,
  });
  const bizDoc = bizRows.find((r) => r.document)?.document;
  if (!bizDoc) throw new Error(`Business not found: ${TARGET_SLUG}`);
  const businessId = bizDoc.name.split('/').pop();
  const base = `projects/${PROJECT_ID}/databases/(default)/documents/businesses/${businessId}`;

  const products = await listCollection(accessToken, base, 'products');
  const toDeleteProducts = products.filter((doc) => {
    const slug = fieldString(doc, 'slug');
    return slug && !expectedSlugs.has(slug);
  });

  for (const doc of toDeleteProducts) {
    const slug = fieldString(doc, 'slug');
    const name = fieldString(doc, 'name');
    await deleteDoc(accessToken, doc.name);
    console.log(`  - product: ${name} (${slug})`);
  }

  const categories = await listCollection(accessToken, base, 'categories');
  const toDeleteCategories = categories.filter((doc) => {
    const slug = fieldString(doc, 'slug');
    return slug && !EXPECTED_CATEGORY_SLUGS.has(slug);
  });

  for (const doc of toDeleteCategories) {
    const slug = fieldString(doc, 'slug');
    const name = fieldString(doc, 'name');
    await deleteDoc(accessToken, doc.name);
    console.log(`  - category: ${name} (${slug})`);
  }

  console.log('\nDone.');
  console.log(`  Products removed: ${toDeleteProducts.length}`);
  console.log(`  Categories removed: ${toDeleteCategories.length}`);
  console.log(`  Products kept (Granit menu): ${products.length - toDeleteProducts.length}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
