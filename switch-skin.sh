#!/usr/bin/env bash
# Swap the active site skin. Skins live in skins/*.css; the active one is
# copied over assets/css/extended/custom.css (what PaperMod bundles).
#
#   ./switch-skin.sh hp-1998      # HP corporate 1998
#   ./switch-skin.sh geocities-90s
#   ./switch-skin.sh clean
#   ./switch-skin.sh              # list available skins + show current
set -euo pipefail
cd "$(dirname "$0")"

SKIN_DIR="skins"
ACTIVE="assets/css/extended/custom.css"

list() {
  echo "Available skins:"
  for f in "$SKIN_DIR"/*.css; do
    printf "  - %s\n" "$(basename "${f%.css}")"
  done
  if [ -f "$ACTIVE" ]; then
    for f in "$SKIN_DIR"/*.css; do
      if cmp -s "$f" "$ACTIVE"; then
        echo "Current: $(basename "${f%.css}")"; return
      fi
    done
    echo "Current: (custom / unsaved edits in $ACTIVE)"
  fi
}

if [ $# -eq 0 ]; then list; exit 0; fi

NAME="$1"
SRC="$SKIN_DIR/$NAME.css"
if [ ! -f "$SRC" ]; then
  echo "No skin named '$NAME'."; echo; list; exit 1
fi

cp "$SRC" "$ACTIVE"
echo "✓ Activated skin: $NAME"
echo "  Preview: hugo server -D   Deploy: ./deploy.sh"
