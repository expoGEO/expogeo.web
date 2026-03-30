#!/bin/bash

# 🚀 Upload para Firestore em PRODUÇÃO - Versão CLI
# Use este script para fazer seed diretamente via Firebase CLI (mais seguro)
#
# Execução:
#   chmod +x bin/seed_firestore_cli.sh
#   ./bin/seed_firestore_cli.sh
#

set -e  # Exit se qualquer comando falhar

PROJECT_ID="expogeo-fad33"
JSON_FILE="bin/content_seed_data.json"

echo "🚀 Upload para Firestore em PRODUÇÃO via Firebase CLI"
echo ""
echo "   Projeto: $PROJECT_ID"
echo ""

# Verificar se arquivo de dados existe
if [ ! -f "$JSON_FILE" ]; then
    echo "❌ Arquivo $JSON_FILE não encontrado!"
    echo "   Execute primeiro: python3 bin/extract_content_to_json_v2.py"
    exit 1
fi

# Verificar se firebase CLI está instalado
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI não encontrado!"
    echo "   Instale: npm install -g firebase-tools"
    exit 1
fi

# Verificar autenticação
echo "🔐 Verificando autenticação Firebase..."
if ! firebase auth:list 2>/dev/null; then
    echo "   Você não está autenticado. Executando login..."
    firebase login
fi

echo ""
echo "📂 Carregando dados..."
TOTAL=$(python3 -c "import json; print(len(json.load(open('$JSON_FILE'))['contents']))")
echo "   ✅ $TOTAL conteúdos a fazer upload"

echo ""
echo "📤 Iniciando upload para Firestore..."
echo ""

# Usar o novo script Dart (com autenticação via gcloud)
dart run bin/seed_firestore_production.dart

echo ""
echo "✅ Seed concluído!"
echo ""
echo "🔍 Verifique no Firebase Console:"
echo "   https://console.firebase.google.com/project/$PROJECT_ID/firestore"
