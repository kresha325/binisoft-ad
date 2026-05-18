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
firebase deploy --only functions:publicApi,functions:createInvoiceHttp,functions:onOfferWrittenReleaseLegacyHolds,functions:deactivateExpiredOffers,functions:inviteStaffHttp,functions:removeStaffHttp,functions:acceptInviteHttp
```

### Environment variables (Firebase Console → Functions → Environment)

| Variable | Purpose |
|----------|---------|
### Email

**Disabled** — no SendGrid, no Firebase Trigger Email extension. Team invites use the **invite code** only (Settings → Team → share code → recipient registers at **Join team**).
| `ENABLE_DEMO_BOOTSTRAP` | Set `true` only in dev to enable demo shop bootstrap |
| `DEMO_BOOTSTRAP_SECRET` | Header `x-demo-setup` value when bootstrap enabled |

## 3. Admin web (GitHub Pages)

Push to `main` → **CI** runs (`analyze` + `test`) → **Deploy Web to GitHub Pages** runs on success.

Manual: Actions → **Deploy Web to GitHub Pages** → Run workflow.

Live URL: https://kresha325.github.io/binisoft-ad/

Demo shop (multi-tenant path): https://jon-sport-shop.web.app/{slug} — e.g. https://jon-sport-shop.web.app/napoletana-nostra. Deploy: `cd jon-sport-shop && npm run deploy`.

## 4. Firebase Auth (GitHub Pages)

Authorized domains: `kresha325.github.io`, `localhost`

API key HTTP referrers: `https://kresha325.github.io/*`, `http://localhost:*`

## 5. Orders API (variants)

POST `/api/public/{slug}/orders` line items:

```json
{ "productId": "...", "quantity": 2, "variantId": "optional-variant-doc-id" }
```

`variantId` is **required** when the product has variants. Catalog `products[].variants[]` includes offer pricing per variant.

## 6. Offers behaviour (API)

- Products stay **active** in `/products` during offers.
- Catalog JSON includes `onOffer`, `originalPrice`, sale `price`.
- `/offers` lists offer cards with discounted lines.
- Expired offers: hourly `deactivateExpiredOffers`; legacy draft holds released by `onOfferWrittenReleaseLegacyHolds`.

## 7. Verify after deploy

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
