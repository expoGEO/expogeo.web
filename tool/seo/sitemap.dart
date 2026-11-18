import 'package:expogeo/core/utils/date/date.dart';

import 'site_pages.dart';

String _escapeXml(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');

/// Todas as páginas com o endereço completo; os objetos levam a data de inserção como `lastmod`.
String buildSitemap(List<SitePage> pages, {required String origin}) {
  final buffer = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
    ..writeln('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');
  for (final page in pages) {
    buffer.writeln('  <url>');
    buffer.writeln('    <loc>${_escapeXml(page.meta.canonicalUrl(origin))}</loc>');
    final modified = page.lastModified;
    if (modified != null) buffer.writeln('    <lastmod>${modified.isoDay}</lastmod>');
    buffer.writeln('  </url>');
  }
  buffer.writeln('</urlset>');
  return buffer.toString();
}
