#!/usr/bin/env python3
"""
Extract content data from Dart files to JSON (no Dart compilation needed).
This bypasses Flutter SDK issues by parsing files directly.
"""

import os
import json
import re
from pathlib import Path
from typing import Any

# Map theme folder names to proper IDs
THEME_MAP = {
    'cultura_e_politica': 'CP',
    'espacos_urbanos_e_rurais': 'EUR',
    'natureza_e_meio_ambiente': 'NMA',
    'representacoes_espaciais': 'RE',
}

def extract_content_from_file(file_path: str) -> dict[str, Any]:
    """Extract a single content item from a Dart file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract data using regex patterns
    data = {}
    
    # ID (from const id = 'XXX')
    id_match = re.search(r"const id = '([^']+)'", content)
    if id_match:
        data['id'] = id_match.group(1)
    
    # Title
    title_match = re.search(r"title: '([^']+)'", content)
    if title_match:
        data['title'] = title_match.group(1)
    
    # Description
    desc_match = re.search(r"description: '([^']+)'", content, re.DOTALL)
    if desc_match:
        data['description'] = desc_match.group(1)[:500]  # First 500 chars
    
    return data

def scannar_content_files() -> list[dict[str, Any]]:
    """Scan all content Dart files and extract data."""
    base_path = Path('/Users/tainass/Personal/expogeo.web/lib/core/content')
    all_contents = []
    
    for theme_dir in sorted(base_path.iterdir()):
        if not theme_dir.is_dir():
            continue
        
        theme_name = theme_dir.name
        theme_id = THEME_MAP.get(theme_name, theme_name)
        
        # Scan for content files (usually named content_*.dart or similar)
        dart_files = list(theme_dir.glob('**/*.dart'))
        print(f"Found {len(dart_files)} Dart files in {theme_name}")
        
        for dart_file in dart_files:
            try:
                content_data = extract_content_from_file(str(dart_file))
                if content_data.get('id'):
                    content_data['themeId'] = theme_id
                    content_data['themeName'] = theme_name
                    all_contents.append(content_data)
            except Exception as e:
                print(f"  Warning: Could not parse {dart_file}: {e}")
    
    return all_contents

def main():
    print("🚀 Extracting content data from Dart files...\n")
    
    contents = scannar_content_files()
    
    print(f"\n✅ Found {len(contents)} content items\n")
    
    # Save as JSON
    output_file = Path('/Users/tainass/Personal/expogeo.web/bin/content_seed_data.json')
    data = {'contents': contents}
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"💾 Saved to: {output_file}")
    print(f"   File size: {output_file.stat().st_size / 1024:.1f} KB\n")
    print("Now you can run:")
    print("  dart run bin/seed_firestore_from_json.dart")

if __name__ == '__main__':
    main()
