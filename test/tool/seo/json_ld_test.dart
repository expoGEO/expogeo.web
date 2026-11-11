import 'dart:convert';

import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tool/seo/json_ld.dart';
import '../../../tool/seo/site_pages.dart';
import '../../features/catalog/catalog_test_data.dart';

const _origin = 'https://expogeo.com.br';

SitePage _page(String path, List<CatalogRecord> records) =>
    buildSitePages(CatalogModel.fromRecords(records)).singleWhere((p) => p.path == path);

Map<String, Object?> _ofType(List<Map<String, Object?>> data, String type) =>
    data.singleWhere((d) => d['@type'] == type);

void main() {
  test('a home traz WebSite e Organization, sem trilha', () {
    final data = jsonLdFor(_page('/', const []), origin: _origin);

    expect(data.map((d) => d['@type']), ['WebSite', 'Organization']);
    expect(_ofType(data, 'WebSite')['url'], 'https://expogeo.com.br/');
    expect(_ofType(data, 'Organization')['logo'], 'https://expogeo.com.br/icons/Icon-192.png');
  });

  test('uma página interna traz a trilha com endereços completos e posições em ordem', () {
    final data = jsonLdFor(_page('/sobre', const []), origin: _origin);
    final items = (_ofType(data, 'BreadcrumbList')['itemListElement'] as List).cast<Map>();

    expect(items.map((i) => i['position']), [1, 2]);
    expect(items.map((i) => i['item']), [
      'https://expogeo.com.br/',
      'https://expogeo.com.br/sobre',
    ]);
    expect(data.any((d) => d['@type'] == 'WebSite'), isFalse);
  });

  test('o objeto traz LearningResource com os dados da ficha e a trilha', () {
    final page = _page('/representacoes-espaciais/historia-cartografia/re-hc-01', [
      objectWith(
        'RE_HC',
        'RE_HC_01',
        title: 'Mapa antigo',
        description: 'Um mapa de 1500.',
        creator: 'Ana',
        subjects: ['Cartografia', 'História'],
      ),
    ]);
    final data = jsonLdFor(page, origin: _origin);
    final resource = _ofType(data, 'LearningResource');

    expect(resource['name'], 'Mapa antigo');
    expect(resource['description'], 'Um mapa de 1500.');
    expect(resource['creator'], 'Ana');
    expect(resource['keywords'], 'Cartografia, História');
    expect(resource['about'], 'História da Cartografia');
    expect(
      resource['url'],
      'https://expogeo.com.br/representacoes-espaciais/historia-cartografia/re-hc-01',
    );
    expect(resource['datePublished'], matches(r'^\d{4}-\d{2}-\d{2}$'));
    expect(resource['inLanguage'], 'pt');
    expect(data.any((d) => d['@type'] == 'BreadcrumbList'), isTrue);
  });

  test('o idioma vira código e o desconhecido é omitido', () {
    Map<String, Object?> resourceWith(String language) {
      final data = validContentJson();
      data['id'] = 'RE_HC_01';
      (data['originInfo'] as Map<String, dynamic>)['language'] = language;
      final page = _page('/representacoes-espaciais/historia-cartografia/re-hc-01', [
        recordAt('RE_HC', 'RE_HC_01', data: data),
      ]);
      return _ofType(jsonLdFor(page, origin: _origin), 'LearningResource');
    }

    expect(resourceWith('Inglês – Ativar a tradução do Google Tradutor')['inLanguage'], 'en');
    expect(resourceWith('Esperanto').containsKey('inLanguage'), isFalse);
  });

  test('o script escapa o que fecharia a tag e continua sendo JSON válido', () {
    final script = jsonLdScript([
      {'name': '</script><script>alert(1)</script> & "aspas"'},
    ]);
    final body = script
        .replaceFirst('<script type="application/ld+json">', '')
        .replaceFirst('</script>', '');

    expect(script, isNot(contains('</script><script>')));
    expect(RegExp('</script>').allMatches(script), hasLength(1));
    expect(body, isNot(contains('<')));
    expect(jsonDecode(body), [
      {'name': '</script><script>alert(1)</script> & "aspas"'},
    ]);
  });
}
