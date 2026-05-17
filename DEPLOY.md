# Deploy runbook — Binisoft Admin (`jon-sport`)

## Prerequisites

```bash
npm i -g firebase-tools
firebase login
firebase use jon-sport
flutter pub get
cd functions && npm ci
```

## 1. Firestore rules & indexes

```bash
firebase deploy --only firestore:rules,firestore:indexes
```

**Important:** `invoice_counters` is server-only. Invoices must use `createInvoiceHttp` (app already does).

## 2. Cloud Functions

```bash
firebase deploy --only functions
```

Or targeted:

```bash
firebase deploy --only functions:publicApi,functions:createInvoiceHttp,functions:onOfferWrittenReleaseLegacyHolds,functions:deactivateExpiredOffers
```

### Environment variables (Firebase Console → Functions → Environment)

| Variable | Purpose |
|----------|---------|
| `SENDGRID_API_KEY` | Transactional email (optional) |
| `EMAIL_FROM` | From address for SendGrid |
| `ENABLE_DEMO_BOOTSTRAP` | Set `true` only in dev to enable demo shop bootstrap |
| `DEMO_BOOTSTRAP_SECRET` | Header `x-demo-setup` value when bootstrap enabled |

## 3. Admin web (GitHub Pages)

Push to `main` → **CI** runs (`analyze` + `test`) → **Deploy Web to GitHub Pages** runs on success.

Manual: Actions → **Deploy Web to GitHub Pages** → Run workflow.

Live URL: https://kresha325.github.io/binisoft-ad/

## 4. Firebase Auth (GitHub Pages)

Authorized domains: `kresha325.github.io`, `localhost`

API key HTTP referrers: `https://kresha325.github.io/*`, `http://localhost:*`

## 5. Offers behaviour (API)

- Products stay **active** in `/products` during offers.
- Catalog JSON includes `onOffer`, `originalPrice`, sale `price`.
- `/offers` lists offer cards with discounted lines.
- Expired offers: hourly `deactivateExpiredOffers`; legacy draft holds released by `onOfferWrittenReleaseLegacyHolds`.

## 6. Verify after deploy

```bash
# Public catalog (replace slug + API key)
curl -sS -H "X-API-Key: YOUR_KEY" \
  "https://us-central1-jon-sport.cloudfunctions.net/publicApi/api/public/napoletana-nostra/products" | head -c 500

curl -sS -H "X-API-Key: YOUR_KEY" \
  "https://us-central1-jon-sport.cloudfunctions.net/publicApi/api/public/napoletana-nostra/offers" | head -c 500
```

Functions tests locally:

```bash
cd functions && npm test
```

Flutter:

```bash
flutter analyze && flutter test
```
