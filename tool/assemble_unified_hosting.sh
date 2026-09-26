#!/usr/bin/env bash
# Assemble Flutter admin + Vite marketplace into one Firebase Hosting tree:
#   /admin/  → Flutter dashboard
#   /shop/   → marketplace storefront
#   /        → marketing landing
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MARKETPLACE_DIR="${MARKETPLACE_DIR:-$ROOT/../Binisoft-marketplace}"
OUT="$ROOT/hosting-unified"

if [[ ! -d "$MARKETPLACE_DIR" ]]; then
  echo "Marketplace repo not found at: $MARKETPLACE_DIR"
  echo "Set MARKETPLACE_DIR=/path/to/Binisoft-marketplace"
  exit 1
fi

echo "==> Cleaning $OUT"
rm -rf "$OUT"
mkdir -p "$OUT/admin" "$OUT/shop"

echo "==> Building Flutter admin (base-href /admin/)"
cd "$ROOT"
flutter pub get
flutter build web \
  --release \
  --pwa-strategy=offline-first \
  --no-web-resources-cdn \
  --base-href "/admin/" \
  --output build/web/admin
dart run tool/patch_web_bootstrap.dart build/web/admin/flutter_bootstrap.js
cp -R build/web/admin/. "$OUT/admin/"

echo "==> Building marketplace (BASE_PATH=/shop/)"
cd "$MARKETPLACE_DIR"
npm ci --prefer-offline 2>/dev/null || npm install
# Same-origin API via Firebase Hosting rewrites (/api/public → publicApi).
# Leave VITE_API_BASE_URL unset so the browser uses window.location.origin.
BASE_PATH=/shop/ npm run build
BASE_PATH=/shop/ \
  VITE_API_BASE_URL=https://us-central1-jon-sport.cloudfunctions.net/publicApi \
  node tool/generate-store-paths.mjs
# SPA fallback for unknown slugs on Hosting
cp dist/index.html dist/404.html 2>/dev/null || true
cp -R dist/. "$OUT/shop/"

echo "==> Marketing + privacy at site root"
cp "$ROOT/web/marketing/index.html" "$OUT/index.html"
cp "$ROOT/web/marketing/privacy.html" "$OUT/privacy.html"

python3 - "$OUT/index.html" <<'PY'
import sys
from pathlib import Path
path = Path(sys.argv[1])
html = path.read_text(encoding="utf-8")
for a, b in [
    ("app/#/login", "/admin/#/login"),
    ("app/#/register", "/admin/#/register"),
    ("https://kresha325.github.io/Binisoft-marketplace/", "/shop/"),
]:
    html = html.replace(a, b)
path.write_text(html, encoding="utf-8")
print("Patched marketing links → /admin and /shop")
PY

if [[ -d "$OUT/admin/icons" ]]; then
  cp -R "$OUT/admin/icons" "$OUT/icons" 2>/dev/null || true
fi
if [[ -f "$OUT/admin/favicon.png" ]]; then
  cp "$OUT/admin/favicon.png" "$OUT/favicon.png" 2>/dev/null || true
fi

cat > "$OUT/404.html" <<'EOF'
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
  <p><a href="/shop/">Marketplace</a> · <a href="/admin/#/login">Admin</a></p>
</body>
</html>
EOF

echo "==> Done: $OUT"
du -sh "$OUT" "$OUT/admin" "$OUT/shop" 2>/dev/null || true
echo "    Admin:  https://jon-sport.web.app/admin/#/login"
echo "    Shop:   https://jon-sport.web.app/shop/"
echo "Deploy: firebase deploy --only hosting:admin --project jon-sport"
