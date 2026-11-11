import 'dart:convert';

import 'package:expogeo/core/utils/browser/page_meta_data.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/core/utils/date/date.dart';

import 'site_pages.dart';

/// Dados estruturados da página: site e organização na home, trilha nas internas e a ficha
/// do recurso nos objetos.
List<Map<String, Object?>> jsonLdFor(SitePage page, {required String origin}) {
  final url = page.meta.canonicalUrl(origin);
  return [
    if (page.kind == PageKind.home) ...[
      {
        '@context': 'https://schema.org',
        '@type': 'WebSite',
        'name': siteName,
        'url': '$origin/',
        'description': page.meta.description,
        'inLanguage': 'pt-BR',
      },
      {
        '@context': 'https://schema.org',
        '@type': 'Organization',
        'name': siteName,
        'url': '$origin/',
        'logo': '$origin/icons/Icon-192.png',
        'parentOrganization': {
          '@type': 'Organization',
          'name': 'Observatório do Ensino de História e Geografia',
          'url': AppLinks.observatory,
        },
      },
    ],
    if (page.breadcrumbs.isNotEmpty)
      {
        '@context': 'https://schema.org',
        '@type': 'BreadcrumbList',
        'itemListElement': [
          for (var i = 0; i < page.breadcrumbs.length; i++)
            {
              '@type': 'ListItem',
              'position': i + 1,
              'name': page.breadcrumbs[i].name,
              'item': PageMeta(
                title: '',
                description: '',
                path: page.breadcrumbs[i].path,
              ).canonicalUrl(origin),
            },
        ],
      },
    if (page.item != null) _learningResource(page, url),
  ];
}

Map<String, Object?> _learningResource(SitePage page, String url) {
  final content = page.item!.content;
  final language = _languageCode(content.originInfo.language);
  return {
    '@context': 'https://schema.org',
    '@type': 'LearningResource',
    'name': content.contentInfo.title,
    'description': content.contentInfo.description,
    'url': url,
    'creator': content.intellectualIndicator.creator,
    'datePublished': content.originInfo.insertionDate.isoDay,
    'about': page.item!.subtheme.name,
    if (language != null) 'inLanguage': language,
    if (content.contentInfo.subjects.isNotEmpty)
      'keywords': content.contentInfo.subjects.join(', '),
  };
}

/// O Firestore guarda o idioma por extenso ("Português", "Inglês – ..."); o JSON-LD pede o código.
String? _languageCode(String language) {
  final text = language.trim().toLowerCase();
  if (text.startsWith('portug')) return 'pt';
  if (text.startsWith('ingl')) return 'en';
  return null;
}

/// O `<script>` do JSON-LD. O texto vem do Firestore, então `<`, `>`, `&` e os separadores de
/// linha saem escapados: nada dentro dele fecha a tag nem vira HTML.
String jsonLdScript(List<Map<String, Object?>> data) {
  final escapes = {
    '<': '\\u003c',
    '>': '\\u003e',
    '&': '\\u0026',
    String.fromCharCode(0x2028): '\\u2028',
    String.fromCharCode(0x2029): '\\u2029',
  };
  var json = jsonEncode(data);
  for (final entry in escapes.entries) {
    json = json.replaceAll(entry.key, entry.value);
  }
  return '<script type="application/ld+json">$json</script>';
}
