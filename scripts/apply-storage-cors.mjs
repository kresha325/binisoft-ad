#!/usr/bin/env node
/**
 * Apply CORS to the Firebase Storage bucket (fallback if Flutter still uses XHR).
 *
 * Requires: gcloud auth application-default login  OR  GOOGLE_APPLICATION_CREDENTIALS
 *
 *   node scripts/apply-storage-cors.mjs
 *   node scripts/apply-storage-cors.mjs --bucket jon-sport.firebasestorage.app
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { Storage } from '@google-cloud/storage';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const corsPath = path.join(__dirname, 'storage-cors.json');
const bucketName =
  process.argv.find((a) => !a.startsWith('-') && a !== process.argv[0] && a !== process.argv[1]) ||
  process.env.FIREBASE_STORAGE_BUCKET ||
  'jon-sport.firebasestorage.app';

const cors = JSON.parse(fs.readFileSync(corsPath, 'utf8'));
const storage = new Storage();
const bucket = storage.bucket(bucketName);

await bucket.setCorsConfiguration(cors);
console.log(`CORS applied to gs://${bucketName}`);
console.log(JSON.stringify(cors, null, 2));
