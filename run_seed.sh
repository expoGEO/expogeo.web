#!/bin/bash

# Grava os objetos de bin/content_seed_data.json no Firestore: ./run_seed.sh dev|prod (prod pede
# confirmação).

set -e

case "$1" in
    dev)  PROJECT_ID="expogeo-dev" ;;
    prod) PROJECT_ID="expogeo-fad33" ;;
    *)
        echo "Uso: $0 <dev|prod>"
        exit 1
        ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"
VENV_DIR="$BIN_DIR/venv"
PYTHON_SCRIPT="$BIN_DIR/seed_firestore.py"

echo "🚀 Seed do Firestore ($1)"
echo ""
echo "   Projeto: $PROJECT_ID"
echo "   Local do script: $PYTHON_SCRIPT"
echo ""

if [ "$1" = "prod" ]; then
    echo "⚠️  Isso grava em PRODUÇÃO e sobrescreve os objetos com o mesmo id."
    read -r -p "   Digite o id do projeto ($PROJECT_ID) para confirmar: " CONFIRM
    if [ "$CONFIRM" != "$PROJECT_ID" ]; then
        echo "❌ Cancelado."
        exit 1
    fi
    echo ""
fi

if [ ! -d "$VENV_DIR" ]; then
    echo "❌ Ambiente virtual não encontrado em: $VENV_DIR"
    echo ""
    echo "Crie com:"
    echo "  cd $BIN_DIR"
    echo "  python3 -m venv venv"
    echo "  source venv/bin/activate"
    echo "  pip install firebase-admin"
    exit 1
fi

if [ ! -f "$PYTHON_SCRIPT" ]; then
    echo "❌ Script não encontrado: $PYTHON_SCRIPT"
    exit 1
fi

echo "✅ Ambiente virtual encontrado"
echo ""

echo "📤 Iniciando seed..."
echo ""

# Chama o Python do venv direto: o activate guarda o caminho de onde o venv foi criado
# e, com o repositório em outra pasta, cairia no Python do sistema.
cd "$SCRIPT_DIR"
"$VENV_DIR/bin/python3" "$PYTHON_SCRIPT" --project "$PROJECT_ID"

echo ""
echo "✨ Feito!"
