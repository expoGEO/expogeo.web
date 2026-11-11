import 'dart:io';

import 'firestore_reader.dart';
import 'html_page.dart';
import 'site_pages.dart';
import 'sitemap.dart';

class SiteWriteResult {
  const SiteWriteResult({required this.pages, required this.objects, required this.sitemap});

  final int pages;
  final int objects;
  final bool sitemap;
}

final RegExp _segment = RegExp(r'^[a-z0-9][a-z0-9-]*$');

/// Grava em [outDir] uma página HTML por rota (`/sobre` vira `sobre.html`; a home reescreve o
/// `index.html`) e, se pedido, o `sitemap.xml`.
///
/// Recusa o que poderia escrever fora de [outDir] ou por cima de um arquivo do build.
SiteWriteResult writeSite({
  required List<SitePage> pages,
  required String template,
  required Directory outDir,
  required String origin,
  required bool noIndex,
  required bool withSitemap,
}) {
  for (final page in pages) {
    final html = renderPage(page, template: template, origin: origin, noIndex: noIndex);
    _fileFor(outDir, page)
      ..createSync(recursive: true)
      ..writeAsStringSync(html);
  }
  if (withSitemap) {
    File('${outDir.path}/sitemap.xml').writeAsStringSync(buildSitemap(pages, origin: origin));
  }
  return SiteWriteResult(
    pages: pages.length,
    objects: pages.where((page) => page.kind == PageKind.object).length,
    sitemap: withSitemap,
  );
}

File _fileFor(Directory outDir, SitePage page) {
  if (page.path == '/') return File('${outDir.path}/index.html');

  final segments = page.path.substring(1).split('/');
  if (!segments.every(_segment.hasMatch)) {
    throw SeoException('Endereço fora do padrão, não vou gravar a página: "${page.path}"');
  }
  final file = File('${outDir.path}/${segments.join('/')}.html');
  if (file.existsSync()) {
    throw SeoException(
      'Já existe um arquivo do build em ${file.path}; não vou sobrescrevê-lo. Se é uma execução repetida, rode `flutter build web` de novo.',
    );
  }
  return file;
}
