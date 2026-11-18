import 'dart:io';

import 'package:expogeo/core/utils/browser/page_meta_data.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tool/seo/firestore_reader.dart';
import '../../../tool/seo/site_pages.dart';
import '../../../tool/seo/site_writer.dart';
import '../../features/catalog/catalog_test_data.dart';

const _template = '''<!doctype html>
<html lang="pt-BR">
  <head>
    <title>expoGEO</title>
    <meta name="description" content="x" />
    <link rel="canonical" href="https://expogeo.com.br/" />
    <meta property="og:url" content="https://expogeo.com.br/" />
    <meta property="og:title" content="x" />
    <meta property="og:description" content="x" />
    <meta name="twitter:title" content="x" />
    <meta name="twitter:description" content="x" />
  </head>
  <body>
    <div id="carregamento"></div>
  </body>
</html>
''';

List<SitePage> _pages() => buildSitePages(
  CatalogModel.fromRecords([
    objectWith('RE_HC', 'RE_HC_01', title: 'Mapa antigo'),
    objectWith('EUR_GM', 'EUR_GM_09', title: 'Painel'),
  ]),
);

void main() {
  late Directory out;

  setUp(() {
    out = Directory.systemTemp.createTempSync('seo_');
    File('${out.path}/index.html').writeAsStringSync(_template);
  });

  tearDown(() => out.deleteSync(recursive: true));

  SiteWriteResult write({List<SitePage>? pages, bool noIndex = false, bool withSitemap = true}) =>
      writeSite(
        pages: pages ?? _pages(),
        template: _template,
        outDir: out,
        origin: 'https://expogeo.com.br',
        noIndex: noIndex,
        withSitemap: withSitemap,
      );

  test('grava a home no index.html e as demais rotas como arquivos .html', () {
    final result = write();

    expect(result.pages, 3 + 4 + 31 + 2);
    expect(result.objects, 2);
    expect(File('${out.path}/index.html').readAsStringSync(), contains('<h1>Conteúdos digitais'));
    expect(File('${out.path}/sobre.html').existsSync(), isTrue);
    expect(File('${out.path}/contato.html').existsSync(), isTrue);
    expect(File('${out.path}/representacoes-espaciais.html').existsSync(), isTrue);
    expect(
      File('${out.path}/representacoes-espaciais/historia-cartografia.html').existsSync(),
      isTrue,
    );
    expect(
      File(
        '${out.path}/representacoes-espaciais/historia-cartografia/re-hc-01.html',
      ).readAsStringSync(),
      contains('<h1>Mapa antigo</h1>'),
    );
    expect(
      Directory(
        out.path,
      ).listSync(recursive: true).any((e) => e.path.substring(out.path.length).contains('/admin')),
      isFalse,
    );
  });

  test('grava o sitemap.xml quando pedido', () {
    expect(write().sitemap, isTrue);
    expect(File('${out.path}/sitemap.xml').readAsStringSync(), contains('<urlset'));
  });

  test('não grava o sitemap.xml quando não pedido', () {
    expect(write(withSitemap: false).sitemap, isFalse);
    expect(File('${out.path}/sitemap.xml').existsSync(), isFalse);
  });

  test('noindex vai em todas as páginas quando pedido', () {
    write(noIndex: true);

    expect(File('${out.path}/sobre.html').readAsStringSync(), contains('noindex'));
    expect(File('${out.path}/index.html').readAsStringSync(), contains('noindex'));
  });

  test('não escreve fora da pasta nem aceita endereço fora do padrão', () {
    SitePage at(String path) => SitePage(
      kind: PageKind.object,
      meta: PageMeta(title: 't', description: 'd', path: path),
      heading: 'x',
    );

    expect(() => write(pages: [at('/tema/../../fora')]), throwsA(isA<SeoException>()));
    expect(() => write(pages: [at('/tema/Código Ruim')]), throwsA(isA<SeoException>()));
    expect(Directory(out.parent.path).listSync().any((e) => e.path.endsWith('fora.html')), isFalse);
  });

  test('não sobrescreve um arquivo do build', () {
    File('${out.path}/sobre.html').writeAsStringSync('do build');

    expect(
      () => write(),
      throwsA(isA<SeoException>().having((e) => e.message, 'm', contains('sobre.html'))),
    );
    expect(File('${out.path}/sobre.html').readAsStringSync(), 'do build');
  });
}
