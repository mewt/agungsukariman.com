#!/usr/bin/env bash
# retro-image.sh — give any image the authentic late-90s "web" look:
# downscale + Floyd-Steinberg dither to the 216-colour Netscape web-safe
# palette, saved as GIF (or PNG8). This is the "distortion" you see on
# 1998 sites like hp.com — it is colour quantisation + error-diffusion
# dithering, not a filter.
#
# Requires ImageMagick 7 (`magick`).
#
# Usage:
#   scripts/retro-image.sh INPUT [OUTPUT] [WIDTH] [STYLE]
#     INPUT   source image (jpg/png/…)
#     OUTPUT  default: <input>-90s.gif
#     WIDTH   downscale target width in px (default 440; 90s images were small)
#     STYLE   fs   = Floyd-Steinberg dither to web-safe   (default, HP look)
#             o8   = ordered 8x8 Bayer dither (crosshatch, chunkier)
#             none = no dither (hard posterised colour bands)
#             jpeg = low-quality JPEG blocky artefacts (q12), keeps colour
#
# Examples:
#   scripts/retro-image.sh photo.jpg
#   scripts/retro-image.sh photo.jpg hero-90s.gif 320 o8
#   scripts/retro-image.sh photo.jpg crunch.jpg 500 jpeg
set -euo pipefail

IN="${1:?usage: retro-image.sh INPUT [OUTPUT] [WIDTH] [STYLE]}"
WIDTH="${3:-440}"
STYLE="${4:-fs}"
OUT="${2:-${IN%.*}-90s.gif}"

command -v magick >/dev/null || { echo "ImageMagick 'magick' not found"; exit 1; }

# Build the 216-colour Netscape web-safe palette once (cached in a tmp file).
PALETTE="$(dirname "$0")/.websafe.png"
[ -f "$PALETTE" ] || magick netscape: "$PALETTE"

case "$STYLE" in
  fs)
    magick "$IN" -resize "${WIDTH}x>" -dither FloydSteinberg -remap "$PALETTE" "$OUT" ;;
  o8)
    magick "$IN" -resize "${WIDTH}x>" -ordered-dither o8x8 -remap "$PALETTE" "$OUT" ;;
  none)
    magick "$IN" -resize "${WIDTH}x>" +dither -remap "$PALETTE" "$OUT" ;;
  jpeg)
    magick "$IN" -resize "${WIDTH}x>" -quality 12 -sampling-factor 4:2:0 "$OUT" ;;
  *)
    echo "Unknown STYLE '$STYLE' (use fs | o8 | none | jpeg)"; exit 1 ;;
esac

magick identify -format "✓ %f  %wx%h  colors=%k  %B bytes\n" "$OUT"
