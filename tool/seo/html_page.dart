import 'firestore_reader.dart';
import 'json_ld.dart';
import 'site_pages.dart';

String escapeHtml(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');

/// A página [page] a partir do `index.html` do build: troca título, descrição, canonical,
/// Open Graph e Twitter, e acrescenta o JSON-LD e o bloco de texto para o buscador.
/// Fora de produção, [noIndex] acrescenta `noindex`.
///
/// Se o `index.html` perder alguma dessas tags, falha: melhor interromper o deploy do que
/// publicar páginas com o texto da home.
String renderPage(
  SitePage page, {
  required String template,
  required String origin,
  bool noIndex = false,
}) {
  final meta = page.meta;
  final url = meta.canonicalUrl(origin);

  var html = template;
  html = _replace(
    html,
    RegExp(r'<title>[\s\S]*?</title>'),
    '<title>${escapeHtml(meta.title)}</title>',
    'title',
  );
  html = _setMeta(html, 'name', 'description', meta.description);
  html = _setMeta(html, 'property', 'og:title', meta.title);
  html = _setMeta(html, 'property', 'og:description', meta.description);
  html = _setMeta(html, 'property', 'og:url', url);
  html = _setMeta(html, 'name', 'twitter:title', meta.title);
  html = _setMeta(html, 'name', 'twitter:description', meta.description);
  html = _replace(
    html,
    RegExp(r'<link\s[^>]*?rel="canonical"[^>]*>'),
    '<link rel="canonical" href="${escapeHtml(url)}" />',
    'canonical',
  );

  final head = [
    if (noIndex) '<meta name="robots" content="noindex, nofollow" />',
    jsonLdScript(jsonLdFor(page, origin: origin)),
  ].join('\n    ');
  html = _replace(html, RegExp(r'</head>'), '    $head\n  </head>', 'fim do head');
  html = _replace(html, RegExp(r'<body>'), '<body>\n    ${_block(page)}', 'início do body');
  return html;
}

String _setMeta(String html, String attribute, String key, String content) => _replace(
  html,
  RegExp('<meta\\s[^>]*?$attribute="${RegExp.escape(key)}"[^>]*>'),
  '<meta $attribute="$key" content="${escapeHtml(content)}" />',
  '$attribute="$key"',
);

String _replace(String html, RegExp pattern, String replacement, String what) {
  if (!pattern.hasMatch(html)) {
    throw SeoException('O index.html do build não tem a tag "$what"; o gerador não sabe trocá-la.');
  }
  return html.replaceFirstMapped(pattern, (_) => replacement);
}

/// O texto que o app mostra, em HTML simples. Some quando o app desenha o primeiro quadro.
String _block(SitePage page) {
  final buffer = StringBuffer('<main id="conteudo-seo" class="conteudo-seo">');
  if (page.breadcrumbs.isNotEmpty) {
    buffer.write('<nav aria-label="Trilha"><ol>');
    for (final crumb in page.breadcrumbs) {
      buffer.write('<li><a href="${escapeHtml(crumb.path)}">${escapeHtml(crumb.name)}</a></li>');
    }
    buffer.write('</ol></nav>');
  }
  buffer.write('<h1>${escapeHtml(page.heading)}</h1>');
  for (final paragraph in page.paragraphs) {
    buffer.write('<p>${escapeHtml(paragraph)}</p>');
  }
  if (page.facts.isNotEmpty) {
    buffer.write('<dl>');
    for (final fact in page.facts) {
      buffer.write('<dt>${escapeHtml(fact.label)}</dt><dd>${escapeHtml(fact.value)}</dd>');
    }
    buffer.write('</dl>');
  }
  if (page.links.isNotEmpty) {
    buffer.write('<ul>');
    for (final link in page.links) {
      buffer.write('<li><a href="${escapeHtml(link.path)}">${escapeHtml(link.title)}</a></li>');
    }
    buffer.write('</ul>');
  }
  buffer.write('</main>');
  return buffer.toString();
}
