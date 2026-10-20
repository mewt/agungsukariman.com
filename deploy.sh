#!/usr/bin/env bash
# Build the Hugo site locally and push the static output to monarki,
# where an isolated nginx container serves it behind Cloudflare Tunnel
# as https://agungsukariman.com
set -euo pipefail
cd "$(dirname "$0")"

REMOTE="monarki:agungsukariman-stack/site/"

echo "▶ building  (hugo --gc --minify)…"
hugo --gc --minify

echo "▶ pushing   (rsync → ${REMOTE})…"
# --delete mirrors exactly (removes files deleted locally)
# --checksum avoids re-sending unchanged files after a full rebuild
rsync -az --delete --checksum --human-readable \
  --exclude '.DS_Store' \
  public/ "${REMOTE}"

echo "✓ deployed → https://agungsukariman.com"
