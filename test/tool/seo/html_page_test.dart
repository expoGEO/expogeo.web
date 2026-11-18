import 'dart:io';

import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tool/seo/firestore_reader.dart';
import '../../../tool/seo/html_page.dart';
import '../../../tool/seo/site_pages.dart';
import '../../features/catalog/catalog_test_data.dart';

const _origin = 'https://expogeo.com.br';
const _object = '/representacoes-espaciais/historia-cartografia/re-hc-01';

/// Pedaço do `index.html` real: tags em uma ou várias linhas, como o formatador as deixa.
const _template = '''<!doctype html>
<html lang="pt-BR">
  <head>
    <title>expoGEO · Curadoria digital do saber geográfico</title>
    <meta
      name="description"
      content="Descrição da home."
    />
    <link rel="canonical" href="https://expogeo.com.br/" />
    <meta property="og:url" content="https://expogeo.com.br/" />
    <meta property="og:title" content="expoGEO" />
    <meta
      property="og:description"
      content="Descrição da home."
    />
    <meta name="twitter:title" content="expoGEO" />
    <meta
      name="twitter:description"
      content="Descrição da home."
    />
    <meta property="og:image" content="https://expogeo.com.br/og-image.png" />
  </head>

  <body>
    <div id="carregamento"></div>
  </body>
</html>
''';

SitePage _objectPage({String title = 'Mapa antigo', String description = 'Um mapa de 1500.'}) =>
    buildSitePages(
      CatalogModel.fromRecords([
        objectWith(
          'RE_HC',
          'RE_HC_01',
          title: title,
          description: description,
          creator: 'Ana',
          subjects: ['Cartografia'],
        ),
      ]),
    ).singleWhere((p) => p.path == _object);

SitePage _page(String path) =>
    buildSitePages(CatalogModel.fromRecords(const [])).singleWhere((p) => p.path == path);

String _attr(String html, String attribute, String key) {
  final tag = RegExp('<meta\\s[^>]*?$attribute="$key"[^>]*>').firstMatch(html)!.group(0)!;
  return RegExp('content="([^"]*)"').firstMatch(tag)!.group(1)!;
}

void main() {
  test('troca título, descrição, canonical, Open Graph e Twitter pelos da página', () {
    final html = renderPage(_objectPage(), template: _template, origin: _origin);

    expect(html, contains('<title>Mapa antigo · História da Cartografia · expoGEO</title>'));
    expect(_attr(html, 'name', 'description'), 'Um mapa de 1500.');
    expect(_attr(html, 'property', 'og:description'), 'Um mapa de 1500.');
    expect(_attr(html, 'name', 'twitter:description'), 'Um mapa de 1500.');
    expect(_attr(html, 'property', 'og:title'), 'Mapa antigo · História da Cartografia · expoGEO');
    expect(_attr(html, 'name', 'twitter:title'), 'Mapa antigo · História da Cartografia · expoGEO');
    expect(_attr(html, 'property', 'og:url'), '$_origin$_object');
    expect(html, contains('<link rel="canonical" href="$_origin$_object" />'));
    expect(html, isNot(contains('Descrição da home.')));
    expect(html, contains('og-image.png'));
  });

  test('põe o bloco de texto no início do body e o JSON-LD no fim do head', () {
    final html = renderPage(_objectPage(), template: _template, origin: _origin);

    expect(html.indexOf('<main id="conteudo-seo"'), lessThan(html.indexOf('id="carregamento"')));
    expect(html, contains('<h1>Mapa antigo</h1>'));
    expect(html, contains('<p>Um mapa de 1500.</p>'));
    expect(html, contains('<dt>Autoria</dt><dd>Ana</dd>'));
    expect(html, contains('<a href="/representacoes-espaciais/historia-cartografia">'));
    expect(html.indexOf('application/ld+json'), lessThan(html.indexOf('</head>')));
    expect(html, contains('"@type":"LearningResource"'));
  });

  test('a página de subtema lista os links dos objetos para o buscador seguir', () {
    final page = buildSitePages(
      CatalogModel.fromRecords([objectWith('RE_HC', 'RE_HC_01', title: 'Mapa antigo')]),
    ).singleWhere((p) => p.path == '/representacoes-espaciais/historia-cartografia');

    expect(
      renderPage(page, template: _template, origin: _origin),
      contains('<li><a href="$_object">Mapa antigo</a></li>'),
    );
  });

  test('escapa o texto do Firestore no HTML e nos atributos', () {
    final html = renderPage(
      _objectPage(title: 'A & B <i>"x"</i>', description: '<script>alert(1)</script> & "q"'),
      template: _template,
      origin: _origin,
    );

    expect(html, isNot(contains('<script>alert(1)')));
    expect(html, contains('<h1>A &amp; B &lt;i&gt;&quot;x&quot;&lt;/i&gt;</h1>'));
    expect(_attr(html, 'name', 'description'), contains('&lt;script&gt;'));
  });

  test('só leva noindex quando pedido', () {
    expect(
      renderPage(_page('/sobre'), template: _template, origin: _origin),
      isNot(contains('noindex')),
    );
    expect(
      renderPage(_page('/sobre'), template: _template, origin: _origin, noIndex: true),
      contains('<meta name="robots" content="noindex, nofollow" />'),
    );
  });

  test('falha, com a tag no erro, se o index.html perder uma delas', () {
    final broken = _template.replaceAll(
      '<link rel="canonical" href="https://expogeo.com.br/" />',
      '',
    );

    expect(
      () => renderPage(_page('/sobre'), template: broken, origin: _origin),
      throwsA(isA<SeoException>().having((e) => e.message, 'mensagem', contains('canonical'))),
    );
  });

  test('o index.html de verdade tem todas as tags que o gerador troca', () {
    final template = File('web/index.html').readAsStringSync();

    final html = renderPage(_page('/sobre'), template: template, origin: _origin);

    expect(html, contains('<title>Sobre a expoGEO · expoGEO</title>'));
    expect(html, contains('<link rel="canonical" href="$_origin/sobre" />'));
    expect(RegExp('<link rel="canonical"').allMatches(html), hasLength(1));
    expect(html, contains('id="carregamento"'));
  });
}
