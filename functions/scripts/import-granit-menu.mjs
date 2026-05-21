/**
 * Copy categories + products from laptop NapoletanaNostra-GranitBllaca → napoletana-nostra.
 * Imports full menu including Bevande (drinks). Does not modify the source project.
 *
 * Run: cd functions && node scripts/import-granit-menu.mjs
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
const IMAGE_BASE = 'https://kresha325.github.io/NapoletanaNostra-GranitBllaca/';

const CATEGORY_ORDER = ['Antipasti', 'Pasta', 'Pizza', 'Dolci', 'Bevande'];

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

async function createDoc(accessToken, collectionPath, fields) {
  const url = `https://firestore.googleapis.com/v1/${collectionPath}`;
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ fields }),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(JSON.stringify(data));
  return data;
}

function str(v) {
  return { stringValue: String(v) };
}
function num(v) {
  return { doubleValue: Number(v) };
}
function int(v) {
  return { integerValue: String(Math.trunc(v)) };
}
function bool(v) {
  return { booleanValue: v };
}
function ts() {
  return { timestampValue: new Date().toISOString() };
}
function map(fields) {
  return { mapValue: { fields } };
}
function arr(values) {
  return { arrayValue: { values } };
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
    items.push({
      key: m[2],
      price: Number(m[3]),
      category: m[4],
      image: m[5],
    });
  }
  return items;
}

function parseProductLabels() {
  const raw = readFileSync(MENU_TS, 'utf8');
  const labels = {};
  const blockRe = /"([^"]+)":\s*\{\s*name:\s*"([^"]*)"(?:,\s*description:\s*"([^"]*)")?/g;
  let m;
  while ((m = blockRe.exec(raw))) {
    labels[m[1]] = { name: m[2], description: m[3] ?? '' };
  }
  return labels;
}

function titleCaseName(name) {
  return String(name || '')
    .trim()
    .toLowerCase()
    .replace(/\b\w/g, (c) => c.toUpperCase());
}

function fieldString(doc, path) {
  return doc?.fields?.[path]?.stringValue ?? '';
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

async function main() {
  const menuItems = parseMenuProducts();
  const labels = parseProductLabels();
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
  console.log(`Target: ${fieldString(bizDoc, 'name')} (${businessId})`);

  const catPath = `projects/${PROJECT_ID}/databases/(default)/documents/businesses/${businessId}/categories`;
  const prodPath = `projects/${PROJECT_ID}/databases/(default)/documents/businesses/${businessId}/products`;

  const existingCats = await listCollection(
    accessToken,
    `projects/${PROJECT_ID}/databases/(default)/documents/businesses/${businessId}`,
    'categories',
  );
  const catBySlug = new Map();
  for (const doc of existingCats) {
    catBySlug.set(fieldString(doc, 'slug'), doc.name.split('/').pop());
  }

  const existingProds = await listCollection(
    accessToken,
    `projects/${PROJECT_ID}/databases/(default)/documents/businesses/${businessId}`,
    'products',
  );
  const prodBySlug = new Set(existingProds.map((d) => fieldString(d, 'slug')));

  const categoryNames = [
    ...new Set(menuItems.map((p) => p.category)),
  ].sort((a, b) => {
    const ia = CATEGORY_ORDER.indexOf(a);
    const ib = CATEGORY_ORDER.indexOf(b);
    return (ia === -1 ? 99 : ia) - (ib === -1 ? 99 : ib);
  });

  const catIdByName = new Map();
  let catCreated = 0;

  for (let i = 0; i < categoryNames.length; i++) {
    const name = categoryNames[i];
    const slug = slugify(name);
    if (catBySlug.has(slug)) {
      catIdByName.set(name, catBySlug.get(slug));
      console.log(`  category exists: ${name}`);
      continue;
    }
    const created = await createDoc(accessToken, catPath, {
      businessId: str(businessId),
      name: str(name),
      slug: str(slug),
      order: int(i),
      nameI18n: map({ sq: str(name) }),
    });
    const id = created.name.split('/').pop();
    catBySlug.set(slug, id);
    catIdByName.set(name, id);
    catCreated++;
    console.log(`  + category: ${name}`);
  }

  let prodCreated = 0;
  let prodSkipped = 0;

  for (const item of menuItems) {
    const label = labels[item.key];
    const name = label?.name
      ? titleCaseName(label.name)
      : titleCaseName(item.key.replace(/-/g, ' '));
    const slug = slugify(label?.name || item.key);
    if (prodBySlug.has(slug)) {
      prodSkipped++;
      continue;
    }
    const categoryId = catIdByName.get(item.category);
    if (!categoryId) continue;

    const imageUrl = item.image.startsWith('http')
      ? item.image
      : `${IMAGE_BASE}${item.image.replace(/^\//, '')}`;

    const now = ts();
    await createDoc(accessToken, prodPath, {
      businessId: str(businessId),
      name: str(name),
      slug: str(slug),
      status: str('active'),
      description: str(label?.description ?? ''),
      categoryIds: arr([str(categoryId)]),
      basePrice: num(item.price),
      baseQuantity: int(0),
      attributeData: map({}),
      images: arr([
        map({
          url: str(imageUrl),
          active: bool(true),
        }),
      ]),
      imageUrls: arr([str(imageUrl)]),
      nameI18n: map({ sq: str(name) }),
      createdAt: now,
      updatedAt: now,
    });
    prodBySlug.add(slug);
    prodCreated++;
  }

  console.log('\nDone (Granit Bllaca project untouched).');
  console.log(`  Categories created: ${catCreated}`);
  console.log(`  Products created: ${prodCreated}`);
  console.log(`  Products skipped (already exist): ${prodSkipped}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
