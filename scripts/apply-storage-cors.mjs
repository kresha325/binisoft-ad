#!/usr/bin/env node
/**
 * Apply Storage CORS (run after: gcloud auth application-default login)
 * node scripts/apply-storage-cors.mjs
 */
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { Storage } from '@google-cloud/storage';

const __dirname = dirname(fileURLToPath(import.meta.url));
const cors = JSON.parse(readFileSync(join(__dirname, '../firebase/storage-cors.json'), 'utf8'));
const bucketName = 'jon-sport.firebasestorage.app';

const storage = new Storage({ projectId: 'jon-sport' });
const bucket = storage.bucket(bucketName);

await bucket.setCorsConfiguration(cors);
console.log('CORS applied to gs://' + bucketName);
const current = await bucket.getCorsConfiguration();
console.log(JSON.stringify(current, null, 2));
