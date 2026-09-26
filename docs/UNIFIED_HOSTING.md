# Unified platform domain (`/admin` + `/shop`)

Primary site: **https://jon-sport.web.app**

| Path | App |
|------|-----|
| `/` | Marketing landing |
| `/admin/` | Flutter admin (`/#/login`, `/#/dashboard`, …) |
| `/shop/` | Marketplace home |
| `/shop/{slug}` | Storefront for one business |
| `/api/public/**` | Same-origin rewrite → `publicApi` |
| `/privacy.html` | Privacy policy |

## Build & deploy

Requires sibling checkout of `Binisoft-marketplace` (or set `MARKETPLACE_DIR`).

```bash
chmod +x tool/assemble_unified_hosting.sh
./tool/assemble_unified_hosting.sh
firebase deploy --only hosting:admin --project jon-sport
```

## Custom domain later

Firebase Console → Hosting → Add custom domain (e.g. `binisoft.com`).
Paths stay `/admin` and `/shop` on that domain. Then update `AppConstants.platformOrigin`.

## Auth / API keys

Authorized domains must include `jon-sport.web.app` (and your custom domain).
Browser API key HTTP referrers: `https://jon-sport.web.app/*`
