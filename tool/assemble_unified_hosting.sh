#!/usr/bin/env bash
# Assemble Flutter admin + Vite marketplace into one static tree:
#   {SITE_PREFIX}/admin/  → Flutter dashboard
#   {SITE_PREFIX}/shop/   → marketplace storefront
#   {SITE_PREFIX}/        → marketing landing (site root of the deploy folder)
#
# Firebase Hosting (default):
#   SITE_PREFIX=  OUT=hosting-unified
#   → https://jon-sport.web.app/admin/  and  /shop/
#
# GitHub Pages project site:
#   SITE_PREFIX=/binisoft-ad  OUT=build/web
#   → https://kresha325.github.io/binisoft-ad/admin/  and  .../shop/
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MARKETPLACE_DIR="${MARKETPLACE_DIR:-$ROOT/../Binisoft-marketplace}"
OUT="${OUT:-$ROOT/hosting-unified}"
# No trailing slash. Empty = site root (Firebase). Project Pages: /binisoft-ad
SITE_PREFIX="${SITE_PREFIX:-}"
SITE_PREFIX="${SITE_PREFIX%/}"

ADMIN_HREF="${SITE_PREFIX}/admin/"
SHOP_BASE="${SITE_PREFIX}/shop/"
# Absolute path links for marketing (work on both hosts)
ADMIN_LOGIN_LINK="${ADMIN_HREF}#/login"
ADMIN_REGISTER_LINK="${ADMIN_HREF}#/register"
SHOP_HOME_LINK="${SHOP_BASE}"

if [[ ! -d "$MARKETPLACE_DIR" ]]; then
  echo "Marketplace repo not found at: $MARKETPLACE_DIR"
  echo "Set MARKETPLACE_DIR=/path/to/Binisoft-marketplace"
  exit 1
fi

echo "==> Cleaning $OUT"
rm -rf "$OUT"
mkdir -p "$OUT/admin" "$OUT/shop"

# Keep Flutter output outside $OUT so `cp` never copies a directory onto itself
# (OUT=build/web on GitHub Pages would collide with --output build/web/admin).
FLUTTER_OUT="$ROOT/build/flutter-admin"
rm -rf "$FLUTTER_OUT"

echo "==> Building Flutter admin (base-href ${ADMIN_HREF})"
cd "$ROOT"
flutter pub get
flutter build web \
  --release \
  --pwa-strategy=offline-first \
  --no-web-resources-cdn \
  --base-href "${ADMIN_HREF}" \
  --output "$FLUTTER_OUT"
dart run tool/patch_web_bootstrap.dart "$FLUTTER_OUT/flutter_bootstrap.js"
# Optional sharp favicon when tool exists
if [[ -f "$ROOT/tool/generate_app_icon_square.dart" ]]; then
  dart run tool/generate_app_icon_square.dart 2>/dev/null || true
fi
cp -R "$FLUTTER_OUT/." "$OUT/admin/"

echo "==> Building marketplace (BASE_PATH=${SHOP_BASE})"
cd "$MARKETPLACE_DIR"
if [[ -f package-lock.json ]]; then
  npm ci --prefer-offline 2>/dev/null || npm install
else
  npm install
fi
# Browser uses cloudfunctions on github.io; same-origin on Firebase when unset.
# Always bake cloud API as fallback via runtime detect in config.js.
BASE_PATH="${SHOP_BASE}" npm run build
BASE_PATH="${SHOP_BASE}" \
  VITE_API_BASE_URL=https://us-central1-jon-sport.cloudfunctions.net/publicApi \
  node tool/generate-store-paths.mjs
cp dist/index.html dist/404.html 2>/dev/null || true
cp -R dist/. "$OUT/shop/"

echo "==> Marketing + privacy at site root"
cp "$ROOT/web/marketing/index.html" "$OUT/index.html"
cp "$ROOT/web/marketing/privacy.html" "$OUT/privacy.html"

python3 - "$OUT/index.html" "$SITE_PREFIX" <<'PY'
import sys
from pathlib import Path
path = Path(sys.argv[1])
prefix = sys.argv[2].rstrip("/")  # "" or "/binisoft-ad"
# Relative to deploy root so both Firebase (/) and GH Pages (/binisoft-ad/) work.
rel_login = "admin/#/login"
rel_register = "admin/#/register"
rel_shop = "shop/"
html = path.read_text(encoding="utf-8")
html = html.replace("app/#/login", rel_login)
html = html.replace("app/#/register", rel_register)
html = html.replace("https://kresha325.github.io/Binisoft-marketplace/", rel_shop)
path.write_text(html, encoding="utf-8")
print(f"Patched marketing (prefix={prefix or '/'}) → {rel_login}, {rel_shop}")
PY

# Legacy /app → /admin (bookmark compatibility)
mkdir -p "$OUT/app"
cat > "$OUT/app/index.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0;url=../admin/#/login">
  <link rel="canonical" href="../admin/#/login">
  <title>Redirecting…</title>
  <script>location.replace('../admin/' + (location.hash || '#/login'));</script>
</head>
<body>
  <p>Moved to <a href="../admin/#/login">admin</a>.</p>
</body>
</html>
EOF

if [[ -d "$OUT/admin/icons" ]]; then
  cp -R "$OUT/admin/icons" "$OUT/icons" 2>/dev/null || true
fi
if [[ -f "$OUT/admin/favicon.png" ]]; then
  cp "$OUT/admin/favicon.png" "$OUT/favicon.png" 2>/dev/null || true
fi

cat > "$OUT/404.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Not found</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>body{font-family:system-ui;padding:2rem;max-width:32rem;margin:auto}</style>
</head>
<body>
  <h1>Not found</h1>
  <p><a href="${SHOP_BASE}">Marketplace</a> · <a href="${ADMIN_HREF}#/login">Admin</a></p>
</body>
</html>
EOF

touch "$OUT/.nojekyll"

echo "==> Done: $OUT"
du -sh "$OUT" "$OUT/admin" "$OUT/shop" 2>/dev/null || true
if [[ -n "$SITE_PREFIX" ]]; then
  echo "    Admin:  https://kresha325.github.io${ADMIN_HREF}#/login"
  echo "    Shop:   https://kresha325.github.io${SHOP_BASE}"
else
  echo "    Admin:  https://jon-sport.web.app/admin/#/login"
  echo "    Shop:   https://jon-sport.web.app/shop/"
  echo "Deploy: firebase deploy --only hosting:admin --project jon-sport"
fi
