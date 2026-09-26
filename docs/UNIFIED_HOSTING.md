# Unified platform (`/admin` + `/shop`)

## Primary — Firebase Hosting

**https://jon-sport.web.app**

| Path | App |
|------|-----|
| `/` | Marketing |
| `/admin/` | Flutter admin |
| `/shop/` | Marketplace |
| `/shop/{slug}` | Storefront |
| `/api/public/**` | Rewrite → `publicApi` |

```bash
./tool/assemble_unified_hosting.sh
firebase deploy --only hosting:admin --project jon-sport
```

## Mirror — GitHub Pages (`binisoft-ad`)

**https://kresha325.github.io/binisoft-ad/**

| Path | App |
|------|-----|
| `/binisoft-ad/` | Marketing |
| `/binisoft-ad/admin/` | Flutter admin |
| `/binisoft-ad/shop/` | Marketplace |
| `/binisoft-ad/shop/{slug}` | Storefront |
| `/binisoft-ad/app/` | Redirect → `/admin/` (legacy) |

API on Pages still uses Cloud Functions (`…/publicApi`) — Hosting rewrites are Firebase-only.

Deploy: push to `main` (workflow **Deploy Web to GitHub Pages**) or Actions → Run workflow.

Marketplace lives in `kresha325/Binisoft-marketplace`. Pages always checkouts that repo’s `main`, and also rebuilds hourly (`schedule`) plus on `repository_dispatch` (`marketplace-updated`). To force a pin commit locally: `./tool/bump-marketplace-ref.sh --commit && git push`.

Local assemble for Pages:

```bash
SITE_PREFIX=/binisoft-ad OUT=build/web \
  MARKETPLACE_DIR=../Binisoft-marketplace \
  ./tool/assemble_unified_hosting.sh
```

## Custom domain later

Add domain on Firebase Hosting (or GH Pages). Paths stay `/admin` and `/shop` (no `/binisoft-ad` prefix on apex domain). Update `AppConstants.platformOrigin`.
