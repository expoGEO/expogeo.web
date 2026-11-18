#!/usr/bin/env python3
"""Grava no Firestore do projeto escolhido os objetos de bin/content_seed_data.json.
Prefira ./run_seed.sh <dev|prod>, que confirma antes de gravar em produção."""

import argparse
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


JSON_FILE = Path("bin/content_seed_data.json")


def init_firebase(project_id):
    try:
        return firebase_admin.get_app()
    except ValueError:
        pass

    try:
        cred = credentials.ApplicationDefault()
    except Exception as e:
        print(f"❌ Erro ao obter credenciais: {e}")
        print("\nPossíveis soluções:")
        print("  1. Execute: gcloud auth application-default login")
        print("  2. Ou: export GOOGLE_APPLICATION_CREDENTIALS=/path/to/firebase-credentials.json")
        sys.exit(1)

    firebase_admin.initialize_app(cred, {"projectId": project_id})
    return firebase_admin.get_app()


def load_content_data():
    if not JSON_FILE.exists():
        print(f"❌ Arquivo {JSON_FILE} não encontrado!")
        print("Execute primeiro: python3 bin/extract_content_to_json_v2.py")
        sys.exit(1)

    with open(JSON_FILE) as f:
        data = json.load(f)

    return data["contents"]


def upload_content(db, content):
    theme_id = content["themeId"]
    subtheme_id = content["subthemeId"]
    content_id = content["id"]
    
    theme_title = content["themeTitle"]
    subtheme_title = content["subthemeTitle"]

    theme_ref = db.collection("themes").document(theme_id)
    theme_ref.set({"name": theme_title}, merge=True)

    subtheme_ref = (
        db.collection("themes")
        .document(theme_id)
        .collection("subthemes")
        .document(subtheme_id)
    )
    subtheme_ref.set({"name": subtheme_title}, merge=True)

    content_ref = subtheme_ref.collection("contents").document(content_id)

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

    if content.get("preservationAction") and content["preservationAction"].get("operation"):
        data["preservationAction"] = content["preservationAction"]

    content_ref.set(data)


def main():
    parser = argparse.ArgumentParser(description="Seed do Firestore")
    parser.add_argument("--project", required=True, help="id do projeto Firebase")
    project_id = parser.parse_args().project

    print("🚀 Upload para Firestore")
    print(f"   Projeto: {project_id}")
    print(f"   Host: firestore.googleapis.com")
    print()

    print("🔐 Inicializando Firebase...")
    try:
        app = init_firebase(project_id)
        db = firestore.client()
        print("   ✅ Conectado com sucesso!")
    except Exception as e:
        print(f"   ❌ Erro: {e}")
        sys.exit(1)

    print()

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

    uploaded_count = 0
    error_count = 0
    errors = []

    try:
        for i, content in enumerate(contents):
            try:
                upload_content(db, content)
                uploaded_count += 1

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

    print()
    print("🔍 Verificando estrutura criada...")
    print()

    try:
        themes = db.collection("themes").stream()
        theme_count = 0
        total_content_count = 0


        print("   Estrutura criada (verificação simplificada):")
        print("   - Execute no Firebase Console para ver a estrutura completa:")
        print(
            f"   https://console.firebase.google.com/project/{project_id}/firestore"
        )

    except Exception as e:
        print(f"   ⚠️  Erro na verificação: {e}")

    print()
    print("✅ Seed de produção concluído! 🎉")
    print()
    print("📊 Próximos passos:")
    print(f"  1. Verifique os dados em: https://console.firebase.google.com/project/{project_id}/firestore")
    print("  2. Configure Firestore Security Rules (se necessário)")
    print("  3. Teste o admin panel: flutter run")
    print()


if __name__ == "__main__":
    main()
