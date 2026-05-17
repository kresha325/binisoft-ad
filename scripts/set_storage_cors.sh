#!/usr/bin/env bash
# Required once for Flutter WEB image uploads (fixes Storage 403).
# Run from Google Cloud Shell OR locally after: gcloud auth login
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUCKET="gs://jon-sport.firebasestorage.app"

if ! command -v gsutil >/dev/null 2>&1; then
  echo "Install Google Cloud SDK: https://cloud.google.com/sdk/docs/install"
  echo "Then: gcloud auth login"
  exit 1
fi

gsutil cors set "$ROOT/firebase/storage-cors.json" "$BUCKET"
echo "CORS applied to $BUCKET"
gsutil cors get "$BUCKET"
