#!/usr/bin/env bash
# Gera os ícones e a imagem de compartilhamento em web/ a partir das páginas
# desta pasta, "fotografadas" pelo Google Chrome sem janela.
#
# Uso: tool/web_icons/generate.sh [pasta_de_saida]
# Sem argumento, grava direto em web/. Só precisa rodar de novo se a marca
# (assets/images/logo_simple.png) mudar.
set -euo pipefail

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="${1:-$(cd "$DIR/../.." && pwd)/web}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$OUT/icons"

# foto <pagina?parametros> <largura> <altura> <arquivo> [transparent]
foto() {
  local page="$1" width="$2" height="$3" file="$4" background="${5:-}"
  local extra=()
  if [[ "$background" == "transparent" ]]; then
    extra+=(--default-background-color=00000000)
  fi
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --force-device-scale-factor=1 --allow-file-access-from-files \
    --user-data-dir="$TMP/perfil" --virtual-time-budget=3000 \
    --window-size="$width,$height" ${extra[@]+"${extra[@]}"} \
    --screenshot="$file" "file://$DIR/$page" >/dev/null 2>&1
  local w h
  w=$(sips -g pixelWidth "$file" | awk '/pixelWidth/ {print $2}')
  h=$(sips -g pixelHeight "$file" | awk '/pixelHeight/ {print $2}')
  if [[ "$w" != "$width" || "$h" != "$height" ]]; then
    echo "Tamanho inesperado em $file: ${w}x${h} (esperado ${width}x${height})" >&2
    exit 1
  fi
  echo "ok  $file (${w}x${h})"
}

# Os ícones pequenos saem do de 512 reduzido com o sips, porque o Chrome sem
# janela não abre janelas menores que algumas centenas de pixels.
reduz() {
  local source="$1" size="$2" file="$3"
  cp "$source" "$file"
  sips -z "$size" "$size" "$file" >/dev/null
  echo "ok  $file (${size}x${size})"
}

foto "icon.html" 512 512 "$OUT/icons/Icon-512.png" transparent
reduz "$OUT/icons/Icon-512.png" 192 "$OUT/icons/Icon-192.png"
reduz "$OUT/icons/Icon-512.png" 32 "$OUT/favicon.png"

foto "maskable.html" 512 512 "$OUT/icons/Icon-maskable-512.png"
reduz "$OUT/icons/Icon-maskable-512.png" 192 "$OUT/icons/Icon-maskable-192.png"

foto "icon.html?background=white" 512 512 "$TMP/apple-512.png"
reduz "$TMP/apple-512.png" 180 "$OUT/icons/apple-touch-icon.png"

foto "og.html" 1200 630 "$OUT/og-image.png"
