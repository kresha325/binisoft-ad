/**
 * Deletes Firebase Auth users except bootstrap superadmin.
 * Uses Firebase CLI access token from ~/.config/configstore/firebase-tools.json
 */
import { readFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';

const PROJECT_ID = 'jon-sport';
const BOOTSTRAP_EMAIL = 'kreshnik.sh.gashi@hotmail.com';
const BOOTSTRAP_UID = '2hAZqeLRITVvV5uPOtVmIik6Kk23';

function getAccessToken() {
  const path = join(homedir(), '.config/configstore/firebase-tools.json');
  const config = JSON.parse(readFileSync(path, 'utf8'));
  const { access_token, refresh_token, expires_at } = config.tokens ?? {};
  if (access_token && expires_at && Date.now() < expires_at - 60_000) {
    return access_token;
  }
  if (!refresh_token) throw new Error('Run: firebase login');
  return null;
}

async function refreshAccessToken(refresh_token) {
  const res = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'refresh_token',
      refresh_token,
      client_id: '563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com',
      client_secret: 'j9pVycW6ZwxvMEPGi4s1wuI',
    }),
  });
  const json = await res.json();
  if (!json.access_token) throw new Error(`Refresh failed: ${JSON.stringify(json)}`);
  return json.access_token;
}

async function resolveToken() {
  let token = getAccessToken();
  if (token) return token;
  const path = join(homedir(), '.config/configstore/firebase-tools.json');
  const config = JSON.parse(readFileSync(path, 'utf8'));
  return refreshAccessToken(config.tokens.refresh_token);
}

async function listAuthUsers(token) {
  const res = await fetch(
    `https://identitytoolkit.googleapis.com/v1/projects/${PROJECT_ID}/accounts:query`,
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ returnUserInfo: true }),
    },
  );
  const json = await res.json();
  if (!res.ok) throw new Error(`List users failed: ${JSON.stringify(json)}`);
  return json.userInfo ?? [];
}

async function deleteAuthUser(token, localId) {
  const res = await fetch(
    `https://identitytoolkit.googleapis.com/v1/projects/${PROJECT_ID}/accounts:delete`,
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ localId }),
    },
  );
  if (!res.ok) {
    const json = await res.json();
    throw new Error(`Delete ${localId}: ${JSON.stringify(json)}`);
  }
}

async function main() {
  const token = await resolveToken();
  const users = await listAuthUsers(token);
  let deleted = 0;
  for (const u of users) {
    const uid = u.localId;
    const email = (u.email || '').toLowerCase();
    if (uid === BOOTSTRAP_UID || email === BOOTSTRAP_EMAIL.toLowerCase()) {
      console.log(`Kept Auth: ${email || uid}`);
      continue;
    }
    await deleteAuthUser(token, uid);
    console.log(`Deleted Auth: ${email || uid}`);
    deleted++;
  }
  console.log(`\nAuth users deleted: ${deleted}\n`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
