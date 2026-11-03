import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'catalog_test_data.dart';

void main() {
  test('os totais por subtema do ambiente de testes dão 190 e 35, 74, 42 e 39 por tema', () {
    final catalog = CatalogModel.fromRecords(devRecords());

    expect(catalog.total, 190);
    expect(catalog.countByTheme(ThemeEnum.representacoesEspaciais), 35);
    expect(catalog.countByTheme(ThemeEnum.naturezaMeioAmbiente), 74);
    expect(catalog.countByTheme(ThemeEnum.espacosUrbanosRurais), 42);
    expect(catalog.countByTheme(ThemeEnum.culturaPolitica), 39);
    expect(catalog.countBySubtheme(SubthemeEnum.sustentabilidade), 10);
  });

  test('tema e subtema saem do caminho, não dos campos do documento', () {
    final catalog = CatalogModel.fromRecords([recordAt('CP_PO', 'CP_PO_01')]);

    expect(catalog.items.single.theme, ThemeEnum.culturaPolitica);
    expect(catalog.items.single.subtheme, SubthemeEnum.povosOriginarios);
    expect(catalog.countByTheme(ThemeEnum.representacoesEspaciais), 0);
  });

  test(
    'ignora subtema fora da lista do tema, tema desconhecido, outro caminho e dados inválidos',
    () {
      final catalog = CatalogModel.fromRecords([
        recordAt('RE_CG', 'ok'),
        recordAt('RE_MOT', 'fora_da_lista'),
        const CatalogRecord(path: 'themes/XX/subthemes/XX_A/contents/a', id: 'a', data: {}),
        CatalogRecord(path: 'contents/solto', id: 'solto', data: validContentJson()),
        CatalogRecord(
          path: 'outros/RE/subthemes/RE_CG/contents/b',
          id: 'b',
          data: validContentJson(),
        ),
        recordAt('RE_CG', 'invalido', data: {'id': 'sem o resto'}),
      ]);

      expect(catalog.total, 1);
      expect(catalog.countBySubtheme(SubthemeEnum.movimentosTerra), 0);
    },
  );

  test('sem objetos, todas as contagens dão 0', () {
    final catalog = CatalogModel.fromRecords(const []);

    expect(catalog.total, 0);
    for (final theme in ThemeEnum.values) {
      expect(catalog.countByTheme(theme), 0);
    }
  });

  test('o primeiro de Biomas é o de menor código, mesmo fora de ordem', () {
    final catalog = CatalogModel.fromRecords([...devRecords(), ...biomasRecords()]);

    final first = catalog.firstOf(SubthemeEnum.biomas);
    expect(first?.content.id, 'NMA_BIO_01');
    expect(first?.content.contentInfo.title, 'aVoar Cerrado');
  });

  test('sem objetos no subtema, não há primeiro', () {
    final catalog = CatalogModel.fromRecords([recordAt('RE_CG', 'a')]);

    expect(catalog.firstOf(SubthemeEnum.biomas), isNull);
  });

  test('o objeto leva ao próprio subtema', () {
    final catalog = CatalogModel.fromRecords(biomasRecords());

    expect(catalog.items.first.route, '/natureza-meio-ambiente/biomas');
  });
}
