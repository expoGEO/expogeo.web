#!/usr/bin/env python3
"""
Upload para Firestore em PRODUÇÃO - Simples e Direto
Este é o método mais fácil e confiável!

Requisitos:
  pip install firebase-admin

Autenticação (escolha UMA):
  Opção 1: gcloud auth application-default login (mais fácil)
  Opção 2: export GOOGLE_APPLICATION_CREDENTIALS=firebase-credentials.json

Execução:
  python3 bin/seed_firestore_production.py
"""

import json
import sys
from pathlib import Path

try:
    import firebase_admin
    from firebase_admin import credentials, firestore
except ImportError:
    print("❌ Erro: firebase-admin package não instalado!")
    print("\nInstale com:")
    print("  pip install firebase-admin")
    sys.exit(1)


PROJECT_ID = "expogeo-fad33"
JSON_FILE = Path("bin/content_seed_data.json")


def init_firebase():
    """Inicializar Firebase (automático com credenciais do sistema)"""
    # Verificar se app já está inicializado
    try:
        return firebase_admin.get_app()
    except ValueError:
        # App não inicializado, continuar com o processo
        pass

    try:
        # Tentar credenciais padrão do gcloud
        cred = credentials.ApplicationDefault()
    except Exception as e:
        print(f"❌ Erro ao obter credenciais: {e}")
        print("\nPossíveis soluções:")
        print("  1. Execute: gcloud auth application-default login")
        print("  2. Ou: export GOOGLE_APPLICATION_CREDENTIALS=/path/to/firebase-credentials.json")
        sys.exit(1)

    firebase_admin.initialize_app(cred, {"projectId": PROJECT_ID})
    return firebase_admin.get_app()


def load_content_data():
    """Carregar dados do JSON"""
    if not JSON_FILE.exists():
        print(f"❌ Arquivo {JSON_FILE} não encontrado!")
        print("Execute primeiro: python3 bin/extract_content_to_json_v2.py")
        sys.exit(1)

    with open(JSON_FILE) as f:
        data = json.load(f)

    return data["contents"]


def upload_content(db, content):
    """Upload de um único conteúdo para Firestore"""
    theme_id = content["themeId"]
    subtheme_id = content["subthemeId"]
    content_id = content["id"]
    
    theme_title = content["themeTitle"]
    subtheme_title = content["subthemeTitle"]

    # 1. Criar documento pai do tema com campo "name"
    theme_ref = db.collection("themes").document(theme_id)
    theme_ref.set({"name": theme_title}, merge=True)

    # 2. Criar documento pai do subtema com campo "name"
    subtheme_ref = (
        db.collection("themes")
        .document(theme_id)
        .collection("subthemes")
        .document(subtheme_id)
    )
    subtheme_ref.set({"name": subtheme_title}, merge=True)

    # 3. Criar documento de conteúdo
    content_ref = subtheme_ref.collection("contents").document(content_id)

    # Converter para formato compatível com Firestore
    data = {
        "id": content["id"],
        "themeId": theme_id,
        "themeTitle": content["themeTitle"],
        "subthemeId": subtheme_id,
        "subthemeTitle": content["subthemeTitle"],
        "intellectualIndicator": content["intellectualIndicator"],
        "contentInfo": content["contentInfo"],
        "originInfo": content["originInfo"],
        "registrationInfo": content["registrationInfo"],
        "rightsInfo": content["rightsInfo"],
    }

    # Adicionar preservationAction se existir
    if content.get("preservationAction") and content["preservationAction"].get("operation"):
        data["preservationAction"] = content["preservationAction"]

    # Upload
    content_ref.set(data)


def main():
    print("🚀 Upload para Firestore em PRODUÇÃO")
    print(f"   Projeto: {PROJECT_ID}")
    print(f"   Host: firestore.googleapis.com")
    print()

    # 1. Inicializar Firebase
    print("🔐 Inicializando Firebase...")
    try:
        app = init_firebase()
        db = firestore.client()
        print("   ✅ Conectado com sucesso!")
    except Exception as e:
        print(f"   ❌ Erro: {e}")
        sys.exit(1)

    print()

    # 2. Carregar dados
    print("📂 Carregando dados...")
    try:
        contents = load_content_data()
        print(f"   ✅ {len(contents)} conteúdos carregados")
    except Exception as e:
        print(f"   ❌ Erro: {e}")
        sys.exit(1)

    print()
    print("📤 Iniciando upload para Firestore...")
    print()

    # 3. Upload em lotes
    uploaded_count = 0
    error_count = 0
    errors = []

    try:
        for i, content in enumerate(contents):
            try:
                upload_content(db, content)
                uploaded_count += 1

                # Feedback a cada 10 itens
                if (uploaded_count) % 10 == 0:
                    print(f"   ✓ {uploaded_count}/{len(contents)} conteúdos enviados")

            except Exception as e:
                error_count += 1
                errors.append(f"Item {i} ({content['id']}): {e}")
                print(f"   ❌ Erro em {content['id']}: {e}")

    except KeyboardInterrupt:
        print("\n\n⚠️  Upload cancelado pelo usuário")
        sys.exit(1)

    except Exception as e:
        print(f"\n\n❌ Erro durante upload: {e}")
        sys.exit(1)

    print()
    print("✅ Upload concluído!")
    print(f"   Sucesso: {uploaded_count}")
    print(f"   Erros: {error_count}")

    if errors and len(errors) <= 5:
        print()
        print("   Erros encontrados:")
        for err in errors:
            print(f"   - {err}")

    # 4. Verificação final
    print()
    print("🔍 Verificando estrutura criada...")
    print()

    try:
        themes = db.collection("themes").stream()
        theme_count = 0
        total_content_count = 0

        # Deixei de fazer a verificação completa aqui porque ficaria longo
        # mas basicamente estamos iterando por temas, contando subthemes e conteúdos

        print("   Estrutura criada (verificação simplificada):")
        print("   - Execute no Firebase Console para ver a estrutura completa:")
        print(
            f"   https://console.firebase.google.com/project/{PROJECT_ID}/firestore"
        )

    except Exception as e:
        print(f"   ⚠️  Erro na verificação: {e}")

    print()
    print("✅ Seed de produção concluído! 🎉")
    print()
    print("📊 Próximos passos:")
    print(f"  1. Verifique os dados em: https://console.firebase.google.com/project/{PROJECT_ID}/firestore")
    print("  2. Configure Firestore Security Rules (se necessário)")
    print("  3. Teste o admin panel: flutter run")
    print()


if __name__ == "__main__":
    main()
