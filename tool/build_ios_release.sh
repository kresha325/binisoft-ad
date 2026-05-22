#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "iOS IPA build requires macOS with Xcode."
  exit 1
fi

echo "Building iOS IPA (release)…"
flutter pub get
flutter build ipa --release

echo ""
echo "Done. IPA: build/ios/ipa/"
ls -la build/ios/ipa/*.ipa 2>/dev/null || true
echo "See docs/IOS_TESTFLIGHT.md for upload steps."
