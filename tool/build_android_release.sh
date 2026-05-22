#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo "Building Android App Bundle (release)…"
flutter pub get
flutter build appbundle --release

echo ""
echo "Done: build/app/outputs/bundle/release/app-release.aab"
echo "See docs/PLAY_STORE_RELEASE.md for Play Console steps."
