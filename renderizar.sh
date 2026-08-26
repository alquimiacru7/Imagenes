#!/usr/bin/env bash
# Re-renderiza las 3 historias a PNG 1080x1920 desde los HTML de src/.
set -euo pipefail
cd "$(dirname "$0")"
CHROME="${CHROME:-/opt/pw-browsers/chromium-1194/chrome-linux/chrome}"
mkdir -p out
for f in v1-confianza v2-impacto v3-premium; do
  "$CHROME" --headless=new --no-sandbox --disable-gpu --hide-scrollbars \
    --force-device-scale-factor=1 --window-size=1080,1920 \
    --virtual-time-budget=4000 --allow-file-access-from-files \
    --screenshot="out/$f.png" "file://$PWD/src/$f.html"
  echo "out/$f.png"
done
