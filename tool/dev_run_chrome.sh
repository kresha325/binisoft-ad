#!/usr/bin/env bash
# Local Chrome on fixed port 8080 + optional dev Firebase API key (no GCP referrer issues).
set -euo pipefail
cd "$(dirname "$0")/.."

if lsof -ti:8080 >/dev/null 2>&1; then
  echo "Port 8080 in use — stopping existing process..."
  lsof -ti:8080 | xargs kill -9 2>/dev/null || true
  sleep 1
fi

ARGS=(run -d chrome --web-port=8080 --web-hostname=localhost)

if [[ -f env/dev.json ]]; then
  ARGS+=(--dart-define-from-file=env/dev.json)
  echo "✓ Using env/dev.json (dev API key with GCP restrictions = None)."
elif [[ -n "${FIREBASE_WEB_API_KEY:-}" ]]; then
  ARGS+=(--dart-define="FIREBASE_WEB_API_KEY=${FIREBASE_WEB_API_KEY}")
  echo "✓ Using FIREBASE_WEB_API_KEY from shell."
else
  echo ""
  echo "⚠️  No dev API key — login will 403 on localhost until you:"
  echo "   1. GCP → Create API key → Application restrictions: None"
  echo "   2. cp env/dev.json.example env/dev.json"
  echo "   3. Paste the new key into env/dev.json"
  echo ""
  echo "   Prod key (github.io) stays restricted; dev key is only for local."
  echo ""
fi

echo "→ http://localhost:8080/#/login"
flutter "${ARGS[@]}"
