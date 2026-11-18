import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../tool/seo/site_pages.dart';
import '../../features/catalog/catalog_test_data.dart';

CatalogModel _catalog(List<CatalogRecord> records) => CatalogModel.fromRecords(records);

void main() {
  final records = [
    objectWith(
      'RE_HC',
      'RE_HC_01',
      title: 'Mapa antigo',
      description: 'Um mapa de 1500.',
      creator: 'Ana',
      collaborator: 'Bia',
      note: 'Atenção ao idioma.',
      subjects: ['Cartografia', 'História'],
    ),
    objectWith('RE_HC', 'RE_HC_02', title: 'Atlas'),
    objectWith('RE_HC', 'RE_HC_06', title: 'Breve história'),
    objectWith('EUR_GM', 'EUR_GM_09', title: 'Painel'),
  ];
  final pages = buildSitePages(_catalog(records));

  SitePage at(String path) => pages.singleWhere((p) => p.path == path);

  test('tem home, sobre, contato, 4 temas, 31 subtemas e um por objeto', () {
    int count(PageKind kind) => pages.where((p) => p.kind == kind).length;

    expect(count(PageKind.home), 1);
    expect(count(PageKind.about), 1);
    expect(count(PageKind.contact), 1);
    expect(count(PageKind.theme), 4);
    expect(count(PageKind.subtheme), 31);
    expect(count(PageKind.object), 4);
  });

  test('não repete endereço, não inclui /admin nem subtema fora do site', () {
    final paths = pages.map((p) => p.path).toList();

    expect(paths.toSet().length, paths.length);
    expect(paths.where((p) => p.startsWith('/admin')), isEmpty);
    expect(paths.where((p) => p.contains('movimentos-terra')), isEmpty);
  });

  test('a página do objeto sai com a rota do código, título, texto e dados da ficha', () {
    final page = at('/representacoes-espaciais/historia-cartografia/re-hc-01');

    expect(page.kind, PageKind.object);
    expect(page.meta.title, 'Mapa antigo · História da Cartografia · expoGEO');
    expect(page.meta.description, 'Um mapa de 1500.');
    expect(page.paragraphs, ['Um mapa de 1500.', 'Atenção ao idioma.']);
    expect(page.facts.map((f) => '${f.label}: ${f.value}'), [
      'Autoria: Ana',
      'Colaboração: Bia',
      'Assuntos: Cartografia, História',
      'Tema: Representações Espaciais',
      'Subtema: História da Cartografia',
    ]);
    expect(page.breadcrumbs.map((c) => c.name), [
      'Início',
      'Representações Espaciais',
      'História da Cartografia',
      'Mapa antigo',
    ]);
    expect(page.lastModified, isNotNull);
  });

  test('o subtema lista os objetos na ordem do código, e o vazio sai sem lista', () {
    final withObjects = at('/representacoes-espaciais/historia-cartografia');
    final empty = at('/representacoes-espaciais/fuso-horario');

    expect(withObjects.links.map((l) => l.title), ['Mapa antigo', 'Atlas', 'Breve história']);
    expect(empty.links, isEmpty);
    expect(empty.kind, PageKind.subtheme);
  });

  test('o tema lista os subtemas e a home lista os temas', () {
    expect(at('/representacoes-espaciais').links, hasLength(7));
    expect(at('/').links, hasLength(4));
    expect(at('/').links.map((l) => l.path), [for (final t in ThemeDataModel.themes) t.type.route]);
  });

  test('dois códigos com o mesmo endereço dão uma página só, a do menor código', () {
    final dup = buildSitePages(
      _catalog([
        objectWith('RE_HC', 'RE_HC_02', title: 'Segundo'),
        objectWith('RE_HC', 're_hc_02', title: 'Primeiro por código'),
      ]),
    );
    final objects = dup.where((p) => p.kind == PageKind.object).toList();

    expect(objects, hasLength(1));
    expect(objects.single.heading, 'Segundo');
  });
}
