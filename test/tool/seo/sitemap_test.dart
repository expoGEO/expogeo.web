import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tool/seo/site_pages.dart';
import '../../../tool/seo/sitemap.dart';
import '../../features/catalog/catalog_test_data.dart';

void main() {
  final pages = buildSitePages(
    CatalogModel.fromRecords([
      objectAt('RE_HC', 'RE_HC_01', date: DateTime(2025, 3, 9)),
      objectAt('RE_HC', 'RE_HC_02', date: DateTime(2024, 12, 1)),
    ]),
  );
  final xml = buildSitemap(pages, origin: 'https://expogeo.com.br');

  test('lista todas as páginas com endereço completo e a home com barra', () {
    expect(RegExp('<url>').allMatches(xml), hasLength(pages.length));
    expect(xml, contains('<loc>https://expogeo.com.br/</loc>'));
    expect(xml, contains('<loc>https://expogeo.com.br/sobre</loc>'));
    expect(xml, contains('<loc>https://expogeo.com.br/representacoes-espaciais</loc>'));
    expect(xml, isNot(contains('/admin')));
  });

  test('só os objetos levam lastmod, com a data de inserção', () {
    expect(RegExp('<lastmod>').allMatches(xml), hasLength(2));
    expect(xml, contains('<lastmod>2025-03-09</lastmod>'));
    expect(xml, contains('<lastmod>2024-12-01</lastmod>'));
  });

  test('é XML bem formado e escapa o que precisa', () {
    expect(xml, startsWith('<?xml version="1.0" encoding="UTF-8"?>'));
    expect(xml, contains('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'));

    final escaped = buildSitemap(pages, origin: 'https://exemplo.com?a=1&b=2');

    expect(escaped, contains('https://exemplo.com?a=1&amp;b=2/sobre'));
  });
}
