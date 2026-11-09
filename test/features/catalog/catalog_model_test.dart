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

  test('o objeto leva à própria página, com o código em minúsculas e hífen', () {
    final catalog = CatalogModel.fromRecords(biomasRecords());

    expect(catalog.items.first.slug, 'nma-bio-04');
    expect(catalog.items.first.route, '/natureza-meio-ambiente/biomas/nma-bio-04');
  });

  group('preservação', () {
    Map<String, dynamic> withPreservation(Object? value) {
      final data = validContentJson();
      data['preservationAction'] = value;
      return data;
    }

    test('vem de preservationAction', () {
      final catalog = CatalogModel.fromRecords([
        recordAt(
          'RE_CG',
          'a',
          data: withPreservation({'operation': 'Revisar o link', 'updateDate': '2026-12-01'}),
        ),
      ]);

      final preservation = catalog.items.single.preservation;
      expect(preservation?.operation, 'Revisar o link');
      expect(preservation?.updateDate, DateTime(2026, 12));
    });

    test('sem updateDate, fica só a operação', () {
      final catalog = CatalogModel.fromRecords([
        recordAt('RE_CG', 'a', data: withPreservation({'operation': 'Revisar o link'})),
      ]);

      expect(catalog.items.single.preservation?.operation, 'Revisar o link');
      expect(catalog.items.single.preservation?.updateDate, isNull);
    });

    for (final (label, value) in [
      ('updateDate malformado', {'operation': 'Revisar', 'updateDate': 'ontem'}),
      ('campo que não é mapa', 'texto'),
      ('campo ausente', null),
    ]) {
      test('$label mantém o objeto, sem preservação', () {
        final catalog = CatalogModel.fromRecords([
          recordAt('RE_CG', 'a', data: withPreservation(value)),
        ]);

        expect(catalog.total, 1);
        expect(catalog.items.single.preservation, isNull);
      });
    }
  });

  group('find', () {
    for (final code in ['NMA_BIO_03', 'nma-bio-03', 'nma_BIO-03']) {
      test('acha "$code" sem diferenciar a grafia', () {
        final catalog = CatalogModel.fromRecords(biomasRecords());

        expect(catalog.find(SubthemeEnum.biomas, code)?.content.id, 'NMA_BIO_03');
      });
    }

    test('código de outro subtema não acha', () {
      final catalog = CatalogModel.fromRecords(biomasRecords());

      expect(catalog.find(SubthemeEnum.sustentabilidade, 'NMA_BIO_03'), isNull);
      expect(catalog.find(SubthemeEnum.biomas, 'nao-existe'), isNull);
    });

    test('se dois códigos coincidem, vale o menor', () {
      final catalog = CatalogModel.fromRecords([
        objectAt('NMA_BIO', 'NMA_BIO_01', date: DateTime(2025)),
        objectAt('NMA_BIO', 'NMA-BIO-01', date: DateTime(2025)),
      ]);

      expect(catalog.find(SubthemeEnum.biomas, 'nma-bio-01')?.content.id, 'NMA-BIO-01');
    });
  });

  group('othersOf', () {
    final catalog = CatalogModel.fromRecords([
      ...biomasRecords(),
      objectAt('NMA_SUS', 'NMA_SUS_01', date: DateTime(2025)),
    ]);
    CatalogItem bySlug(String code) => catalog.find(SubthemeEnum.biomas, code)!;

    test('sem o atual, em ordem, até o limite e só do subtema', () {
      expect(catalog.othersOf(bySlug('nma-bio-02'), 3).map((item) => item.content.id), [
        'NMA_BIO_01',
        'NMA_BIO_03',
        'NMA_BIO_04',
      ]);
    });

    test('vazio com um objeto só no subtema', () {
      final single = catalog.find(SubthemeEnum.sustentabilidade, 'nma-sus-01')!;

      expect(catalog.othersOf(single, 3), isEmpty);
    });
  });

  test('os 6 mais recentes saem em ordem de data decrescente', () {
    final catalog = CatalogModel.fromRecords([
      for (var day = 1; day <= 8; day++)
        objectAt('RE_CG', 'RE_CG_0$day', date: DateTime(2025, 1, day)),
    ]);

    expect(catalog.latest(6).map((item) => item.content.id), [
      'RE_CG_08',
      'RE_CG_07',
      'RE_CG_06',
      'RE_CG_05',
      'RE_CG_04',
      'RE_CG_03',
    ]);
  });

  test('na mesma data, o menor código vem antes, em qualquer ordem de chegada', () {
    final records = [
      objectAt('NMA_BIO', 'NMA_BIO_03', date: DateTime(2024, 12, 13)),
      objectAt('CP_PO', 'CP_PO_02', date: DateTime(2024, 12, 13)),
      objectAt('RE_CG', 'RE_CG_01', date: DateTime(2025, 2)),
      objectAt('EUR_CT', 'EUR_CT_09', date: DateTime(2024, 12, 13)),
    ];
    const expected = ['RE_CG_01', 'CP_PO_02', 'EUR_CT_09', 'NMA_BIO_03'];

    expect(CatalogModel.fromRecords(records).latest(6).map((i) => i.content.id), expected);
    expect(CatalogModel.fromRecords(records.reversed).latest(6).map((i) => i.content.id), expected);
  });

  test('com menos objetos que o pedido, devolve os que houver', () {
    expect(CatalogModel.fromRecords(biomasRecords().take(4)).latest(6), hasLength(4));
    expect(CatalogModel.fromRecords(const []).latest(6), isEmpty);
  });
}
