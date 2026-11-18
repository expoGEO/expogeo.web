#!/usr/bin/env python3
"""Extrai os dados de ContentModel dos arquivos Dart para JSON, lendo o texto sem compilar o Dart."""

import os
import json
import re
from pathlib import Path
from typing import Any, Optional, final

def extract_string_value(content: str, key: str, multiline: bool = False) -> Optional[str]:
    if multiline:
        pattern = rf"{key}:\s*['\"]([^'\"]*(?:\n[^'\"]*)*)['\"]"
        match = re.search(pattern, content, re.DOTALL)
    else:
        pattern = rf"{key}:\s*['\"]([^'\"]+)['\"]"
        match = re.search(pattern, content)
    
    if match:
        value = match.group(1).strip()
        value = re.sub(r'\s+', ' ', value)
        return value
    return None

def extract_list_values(content: str, key: str) -> list[str]:
    pattern = rf"{key}:\s*\[(.*?)\]"
    match = re.search(pattern, content, re.DOTALL)
    
    if match:
        values_str = match.group(1)
        quoted = re.findall(r"['\"]([^'\"]+)['\"]", values_str)
        return quoted
    return []

def extract_date_value(content: str, key: str) -> Optional[str]:
    pattern = rf"{key}:\s*DateTime\((\d+),\s*(\d+),?\s*(\d+)?\)"
    match = re.search(pattern, content)
    
    if match:
        year, month, day = match.groups()
        day = day or '1'
        return f"{year}-{month.zfill(2)}-{day.zfill(2)}"
    return None

def parse_content_file(file_path: str, theme_id: str, theme_title: str, subtheme_id: str, subtheme_title: str) -> Optional[dict[str, Any]]:
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content_code = f.read()
        
        file_name = Path(file_path).stem
        
        title = extract_string_value(content_code, r'title')
        if not title:
            return None
        
        description = extract_string_value(content_code, 'description', multiline=True)
        subjects = extract_list_values(content_code, 'subjects')
        contentNote = extract_string_value(content_code, 'contentNote', multiline=True)
        
        creator = extract_string_value(content_code, 'creator')
        collaborator = extract_string_value(content_code, 'collaborator')
        
        insertionDate = extract_date_value(content_code, 'insertionDate')
        language = extract_string_value(content_code, 'language')
        
        type_match = re.search(r'type:\s*ContentType\.(\w+)', content_code)
        content_type = type_match.group(1) if type_match else 'unknown'
        
        format_match = re.search(r'format:\s*ContentFormat\.(\w+)', content_code)
        content_format = format_match.group(1) if format_match else 'unknown'
        
        requirements = extract_string_value(content_code, 'requirements')
        location = extract_string_value(content_code, 'location')
        issueYear = extract_string_value(content_code, 'issueYear')
        registrationRules = extract_string_value(content_code, 'registrationRules', multiline=True)
        rights = extract_string_value(content_code, 'rights')
        
        operation = extract_string_value(content_code, 'operation')
        updateDate = extract_date_value(content_code, 'updateDate')
        
        return {
            'id': file_name,
            'themeId': theme_id,
            'themeTitle': theme_title,
            'subthemeId': subtheme_id,
            'subthemeTitle': subtheme_title,
            'intellectualIndicator': {
                'creator': creator or '',
                'collaborator': collaborator or '',
            },
            'contentInfo': {
                'title': title,
                'description': description or '',
                'subjects': subjects,
                'contentNote': contentNote or '',
            },
            'originInfo': {
                'insertionDate': insertionDate,
                'language': language or '',
                'type': content_type,
                'format': content_format,
                'requirements': requirements or '',
            },
            'registrationInfo': {
                'location': location or '',
                'issueYear': issueYear or '',
                'registrationRules': registrationRules or '',
            },
            'rightsInfo': {
                'rights': rights or '',
            },
            'preservationAction': {
                'operation': operation,
                'updateDate': updateDate,
            } if operation else None,
        }
    except Exception as e:
        print(f"  ⚠️  Error parsing {file_path}: {e}")
        return None

def extract_all_content() -> list[dict[str, Any]]:
    all_contents = []
    base_path = Path('/Users/tainass/Personal/expogeo.web/lib/core/content')
    
    theme_map = {
        'cultura_e_politica': ('CP', 'Cultura e Política'),
        'espacos_urbanos_e_rurais': ('EUR', 'Espaços Urbanos e Rurais'),
        'natureza_e_meio_ambiente': ('NMA', 'Natureza e Meio Ambiente'),
        'representacoes_espaciais': ('RE', 'Representações Espaciais'),
    }
    
    subtheme_map = {
        'censo_demografico': ('CP_CD', 'Censo Demográfico'),
        'geopolitica': ('CP_GP', 'Geopolítica'),
        'identidades_culturais': ('CP_IC', 'Identidades Culturais'),
        'populacao': ('CP_POP', 'População'),
        'povos_originarios': ('CP_PO', 'Povos Originários'),
        'regioes_administrativas': ('CP_RA', 'Regiões Administrativas'),
        'conflitos_terra': ('EUR_CT', 'Conflitos Terra'),
        'espaco_urbano_brasileiro': ('EUR_EUB', 'Espaço Urbano Brasileiro'),
        'espaco_rural_brasileiro': ('EUR_ERB', 'Espaço Rural Brasileiro'),
        'globalizacao_mobilidade': ('EUR_GM', 'Globalização Mobilidade'),
        'industria_transformacao': ('EUR_IT', 'Indústria Transformação'),
        'mercado_agropecuario': ('EUR_MA', 'Mercado Agropecuário'),
        'bacia_hidrografica': ('NMA_BH', 'Bacias Hidrográficas'),
        'bacias_hidrograficas': ('NMA_BH', 'Bacias Hidrográficas'),
        'biomas': ('NMA_BIO', 'Biomas'),
        'desmatamento': ('NMA_DES', 'Desmatamento'),
        'estruturas_formas_relevo': ('NMA_EFR', 'Estruturas Formas Relevo'),
        'poluicao_agua': ('NMA_PA', 'Poluição Água'),
        'poluicao_ar': ('NMA_PAR', 'Poluição Ar'),
        'queimadas': ('NMA_QUE', 'Queimadas'),
        'recursos_minerais': ('NMA_RM', 'Recursos Minerais'),
        'sustentabilidade': ('NMA_SUS', 'Sustentabilidade'),
        'tempo_clima': ('NMA_TC', 'Tempo Clima'),
        'tipos_climaticos': ('NMA_TPCL', 'Tipos Climáticos'),
        'uso_agua': ('NMA_UA', 'Uso Água'),
        'uso_da_agua': ('NMA_UA', 'Uso Água'),
        'compositor_mapas': ('RE_CM', 'Compositor Mapas'),
        'coordenadas_geograficas': ('RE_CG', 'Coordenadas Geográficas'),
        'fuso_horario': ('RE_FH', 'Fuso Horário'),
        'geotecnologias': ('RE_GT', 'Geotecnologias'),
        'historia_cartografia': ('RE_HC', 'História Cartografia'),
        'leitura_mapas': ('RE_LM', 'Leitura Mapas'),
        'pontos_cardeais': ('RE_PC', 'Pontos Cardeais'),
    }
    
    for theme_dir in sorted(base_path.iterdir()):
        if not theme_dir.is_dir() or theme_dir.name not in theme_map:
            continue
        
        theme_id, theme_title = theme_map[theme_dir.name]
        print(f"\n📚 Processando tema: {theme_title}")
        
        for subtheme_dir in sorted(theme_dir.iterdir()):
            if not subtheme_dir.is_dir():
                continue
            
            subtheme_key = subtheme_dir.name
            
            if subtheme_key not in subtheme_map:
                print(f"   ⚠️  Subtema desconhecido: {subtheme_key} (pulando)")
                continue
            
            subtheme_id, subtheme_title = subtheme_map[subtheme_key]
            
            print(f"   📁 Processando subtema: {subtheme_title} ({subtheme_id})")
            
            dart_files = sorted(subtheme_dir.glob('*.dart'))
            
            for dart_file in dart_files:
                if dart_file.name.endswith('.dart'):
                    content_item = parse_content_file(
                        str(dart_file),
                        theme_id,
                        theme_title,
                        subtheme_id,
                        subtheme_title,
                    )
                    if content_item:
                        all_contents.append(content_item)
                        print(f"      ✓ {content_item['id']}: {content_item['contentInfo']['title'][:50]}...")
    
    return all_contents

def main():
    print("🚀 Extraindo dados de conteúdo de arquivos Dart...\n")
    
    contents = extract_all_content()
    
    print(f"\n\n✅ Total extraído: {len(contents)} itens de conteúdo\n")
    
    output_file = Path('/Users/tainass/Personal/expogeo.web/bin/content_seed_data.json')
    data = {'contents': contents}
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    file_size_kb = output_file.stat().st_size / 1024
    print(f"💾 Salvo em: {output_file}")
    print(f"   Tamanho: {file_size_kb:.1f} KB\n")
    print("Próximo passo:")
    print("  dart run bin/seed_firestore_from_json.dart")

if __name__ == '__main__':
    main()
