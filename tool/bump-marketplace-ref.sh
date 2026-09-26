#!/usr/bin/env bash
# Bump tool/marketplace.ref to sibling marketplace HEAD and optionally commit.
# Usage:
#   ./tool/bump-marketplace-ref.sh           # write pin only
#   ./tool/bump-marketplace-ref.sh --commit  # write + commit (no push)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MARKETPLACE_DIR="${MARKETPLACE_DIR:-$ROOT/../Binisoft-marketplace}"
PIN="$ROOT/tool/marketplace.ref"

if [[ ! -d "$MARKETPLACE_DIR/.git" ]]; then
  echo "Marketplace repo not found at: $MARKETPLACE_DIR"
  exit 1
fi

SHA="$(git -C "$MARKETPLACE_DIR" rev-parse HEAD)"
MSG="$(git -C "$MARKETPLACE_DIR" log -1 --oneline)"
echo "$SHA" > "$PIN"
echo "Pinned $MSG"

if [[ "${1:-}" == "--commit" ]]; then
  cd "$ROOT"
  git add tool/marketplace.ref
  if git diff --cached --quiet; then
    echo "Pin already up to date."
    exit 0
  fi
  git commit -m "$(cat <<EOF
Bump marketplace pin to ${SHA:0:7}.

EOF
)"
fi
