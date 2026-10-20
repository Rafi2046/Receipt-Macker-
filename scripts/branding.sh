#!/usr/bin/env bash
# Regenerates every icon and splash asset from the SVGs in assets/branding/.
# Renders PNGs with headless Chrome (macOS path; set CHROME to override),
# then runs flutter_launcher_icons and flutter_native_splash.
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
SRC=assets/branding
OUT=$SRC/generated
mkdir -p "$OUT"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# render <svg> <size> <png>: transparent background.
render() {
  local svg size png
  svg="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"; size=$2; png=$3
  cat > "$TMP/page.html" <<HTML
<html><body style="margin:0;background:transparent">
<img src="file://$svg" style="width:${size}px;height:${size}px;display:block">
</body></html>
HTML
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --default-background-color=00000000 --allow-file-access-from-files \
    --window-size="$size,$size" --screenshot="$png" "file://$TMP/page.html" \
    >/dev/null 2>&1
  echo "  $png"
}

echo "Rendering PNGs"
render $SRC/quickbill_icon_square.svg 1024 $OUT/icon_full_1024.png
render $SRC/quickbill_icon_foreground.svg 1024 $OUT/icon_foreground_1024.png
render $SRC/quickbill_icon_monochrome.svg 1024 $OUT/icon_monochrome_1024.png
render $SRC/quickbill_icon_square.svg 512 $OUT/play_store_icon_512.png
# Play Console wants a 32-bit PNG (with alpha).
python3 -c "from PIL import Image; p='$OUT/play_store_icon_512.png'; Image.open(p).convert('RGBA').save(p)" \
  || echo "  warning: could not add an alpha channel (needs Python + Pillow)"
# Android 12+ splash: 1152 px, the system shows the middle 768 px circle;
# the foreground's safe zone (66/108) is 704 px, so nothing is cut.
render $SRC/quickbill_icon_foreground.svg 1152 $OUT/splash_android12_1152.png
# Older Android splash: drawn at xxxhdpi, so 384 px = 96 dp.
render $SRC/quickbill_logo.svg 384 $OUT/splash_logo_384.png
render $SRC/quickbill_logo.svg 512 assets/images/logo.png

echo "Launcher icons"
dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
echo "Native splash"
dart run flutter_native_splash:create --path=flutter_native_splash.yaml
