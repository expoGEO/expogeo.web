#!/usr/bin/env bash
# Gera as versões WebP das ilustrações de temas e subtemas e dos logos de apoio,
# usando o Google Chrome sem janela (to_webp.html). A máquina não tem cwebp nem
# Pillow, e o sips do macOS só lê WebP.
#
# Uso: tool/images/generate_webp.sh [pasta_de_saida]
# Sem argumento, grava em assets/images/. Os PNGs de origem não são alterados.
set -euo pipefail

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$DIR/../.." && pwd)"
SRC="$ROOT/assets/images"
OUT="${1:-$SRC}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$OUT"

# Teto por ilustração; acima dele, tenta qualidades menores na ordem.
LIMITE_ILUSTRACAO=61440
QUALIDADES_ILUSTRACAO="0.8 0.75 0.7"

# PNG de origem -> nome do AppImages em snake_case (sem acento).
ILUSTRACOES="
bacias_hidrograficas.png:bacias_hidrograficas
biomas.png:biomas
censo_demografico.png:censo_demografico
compositor_mapas.png:compositor_mapas
conflitos_terra.png:conflitos_terra
coordenadas_geograficas.png:coordenadas_geograficas
cultura_política.png:cultura_politica
desmatamento.png:desmatamento
espaco_rural_brasleiro.png:espaco_rural_brasleiro
espaco_urbano_brasileiro.png:espaco_urbano_brasileiro
espacos_urbano_rural.png:espacos_urbano_rural
estruturas_formas_relevo.png:estruturas_formas_relevo
fuso_horario.png:fuso_horario
geopolitica.png:geopolitica
geotecnologias.png:geotecnologias
globalizacao_mobilidade.png:globalizacao_mobilidade
historia_cartografia.png:historia_cartografia
identidades_culturais.png:identidades_culturais
industrias_transformacoes.png:industrias_transformacoes
leitura_mapas.png:leitura_mapas
meio_ambiente_natureza.png:meio_ambiente_natureza
mercado_agropecuario.png:mercado_agropecuario
movimentos_terra.png:movimentos_terra
poluicao_agua.png:poluicao_agua
poluicao_ar.png:poluicao_ar
pontos_cardeais.png:pontos_cardeais
populacao.png:populacao
povos_originarios.png:povos_originarios
queimadas.png:queimadas
recursos_minerais.png:recursos_minerais
regioes_brasileiras.png:regioes_brasileiras
representacoes_espaciais.png:representacoes_espaciais
sustentabilidade.png:sustentabilidade
tempo_clima.png:tempo_clima
tipos_climaticos.png:tipos_climaticos
uso_agua.png:uso_agua
"

# Logos ficam na resolução original para não perder nitidez em tela de alta densidade.
LOGOS="ufu faced ppged fapemig capes cnpq"
QUALIDADE_LOGO=0.95

tamanho() { stat -f %z "$1"; }
dimensao() { sips -g "$2" "$1" | awk '/pixel/ {print $2}'; }

# converte <png> <webp> <max> <qualidade>
converte() {
  local png="$1" webp="$2" max="$3" q="$4"
  local dom="$TMP/dom.html"
  "$CHROME" --headless=new --disable-gpu --allow-file-access-from-files \
    --user-data-dir="$TMP/perfil" --virtual-time-budget=5000 --dump-dom \
    "file://$DIR/to_webp.html?src=file://$png&max=$max&q=$q" >"$dom" 2>/dev/null
  local base64_webp
  base64_webp="$(sed -n 's/.*data:image\/webp;base64,\([A-Za-z0-9+/=]*\).*/\1/p' "$dom")"
  if [[ -z "$base64_webp" ]]; then
    echo "Falha ao converter $png" >&2
    exit 1
  fi
  printf '%s' "$base64_webp" | base64 -d >"$webp"
}

# confere <png> <webp> <largura> <altura>
confere() {
  local webp="$2" largura="$3" altura="$4"
  local w h
  w="$(dimensao "$webp" pixelWidth)"
  h="$(dimensao "$webp" pixelHeight)"
  if [[ "$w" != "$largura" || "$h" != "$altura" ]]; then
    echo "Tamanho inesperado em $webp: ${w}x${h} (esperado ${largura}x${altura})" >&2
    exit 1
  fi
}

linha() {
  local nome="$1" png="$2" webp="$3" q="$4"
  local a b
  a="$(tamanho "$png")"
  b="$(tamanho "$webp")"
  printf '%-28s %9d %8d %5s%% %5s %sx%s\n' "$nome" "$a" "$b" "$(( (a - b) * 100 / a ))" "$q" \
    "$(dimensao "$webp" pixelWidth)" "$(dimensao "$webp" pixelHeight)"
}

printf '%-28s %9s %8s %6s %5s %s\n' "arquivo" "png" "webp" "red." "q" "px"

soma_png=0
soma_webp=0
acima=""
for par in $ILUSTRACOES; do
  png="$SRC/${par%%:*}"
  webp="$OUT/${par##*:}.webp"
  lado="$(dimensao "$png" pixelWidth)"
  if (( lado > 512 )); then lado=512; fi
  for q in $QUALIDADES_ILUSTRACAO; do
    converte "$png" "$webp" 512 "$q"
    if (( $(tamanho "$webp") <= LIMITE_ILUSTRACAO )); then break; fi
  done
  confere "$png" "$webp" "$lado" "$lado"
  if (( $(tamanho "$webp") > LIMITE_ILUSTRACAO )); then acima="$acima ${par##*:}"; fi
  linha "${par##*:}" "$png" "$webp" "$q"
  soma_png=$(( soma_png + $(tamanho "$png") ))
  soma_webp=$(( soma_webp + $(tamanho "$webp") ))
done
printf '%-28s %9d %8d %5s%%\n' "ILUSTRACOES (soma)" "$soma_png" "$soma_webp" \
  "$(( (soma_png - soma_webp) * 100 / soma_png ))"
if [[ -n "$acima" ]]; then echo "Acima de 60 KB:$acima"; fi

echo
for nome in $LOGOS; do
  png="$SRC/$nome.png"
  webp="$OUT/$nome.webp"
  converte "$png" "$webp" 0 "$QUALIDADE_LOGO"
  confere "$png" "$webp" "$(dimensao "$png" pixelWidth)" "$(dimensao "$png" pixelHeight)"
  if (( $(tamanho "$webp") >= $(tamanho "$png") )); then
    echo "$webp não ficou menor que o PNG" >&2
    exit 1
  fi
  linha "$nome" "$png" "$webp" "$QUALIDADE_LOGO"
done
