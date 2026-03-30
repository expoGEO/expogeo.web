#!/bin/bash

# 🚀 Script para fazer seed do Firestore em PRODUÇÃO
# Ativa o venv automaticamente e roda o script Python
#
# Execução:
#   chmod +x run_seed_production.sh
#   ./run_seed_production.sh
#

set -e

PROJECT_ID="expogeo-fad33"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"
VENV_DIR="$BIN_DIR/venv"
PYTHON_SCRIPT="$BIN_DIR/seed_firestore_production.py"

echo "🚀 Seed do Firestore em PRODUÇÃO"
echo ""
echo "   Projeto: $PROJECT_ID"
echo "   Local do script: $PYTHON_SCRIPT"
echo ""

# Verificar se o venv existe
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

# Verificar se o script Python existe
if [ ! -f "$PYTHON_SCRIPT" ]; then
    echo "❌ Script não encontrado: $PYTHON_SCRIPT"
    exit 1
fi

echo "✅ Ambiente virtual encontrado"
echo ""

# Ativar venv e rodar script
echo "📤 Ativando ambiente virtual e iniciando seed..."
echo ""

source "$VENV_DIR/bin/activate"
python3 "$PYTHON_SCRIPT"

echo ""
echo "✨ Feito!"
