import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/panel_objects_store.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../catalog/catalog_test_data.dart';

void main() {
  late FakeCatalogRepository repository;
  late CatalogStore catalog;

  Future<PanelObjectsStore> storeWith(List<CatalogRecord> records) async {
    repository = FakeCatalogRepository();
    catalog = CatalogStore(repository);
    final loading = catalog.ensureLoaded();
    repository.succeed(records);
    await loading;
    return PanelObjectsStore(catalog);
  }

  CatalogRecord dated(
    String subthemeId,
    String code, {
    DateTime? date,
    String title = 'Sem título',
    String creator = 'Sem criador',
    List<String> subjects = const [],
    String type = 'site',
  }) {
    final record = objectWith(
      subthemeId,
      code,
      title: title,
      creator: creator,
      subjects: subjects,
      type: type,
    );
    (record.data['originInfo'] as Map<String, dynamic>)['insertionDate'] = (date ?? DateTime(2025))
        .toIso8601String();
    return record;
  }

  List<String> ids(List<CatalogItem> items) => [for (final i in items) i.content.id];

  List<CatalogRecord> sample() => [
    dated('NMA_BH', 'NMA_BH_01', title: 'Bacias do Brasil', date: DateTime(2025, 1, 1)),
    dated('NMA_BH', 'NMA_BH_03', title: 'Rio São Francisco', date: DateTime(2025, 1, 2)),
    dated(
      'NMA_BIO',
      'NMA_BIO_01',
      title: 'Cerrado vivo',
      creator: 'Instituto Ambiental',
      type: 'video',
      date: DateTime(2025, 3, 1),
    ),
    dated(
      'CP_CD',
      'CP_CD_01',
      title: 'Censo em São Paulo',
      subjects: ['População urbana'],
      type: 'Documento',
      date: DateTime(2025, 3, 1),
    ),
    dated('RE_CG', 'RE_CG_01', title: 'Latitude e longitude', date: DateTime(2024, 6, 1)),
  ];

  group('ordem e lista', () {
    test('mais recente primeiro; na mesma data, o menor código', () async {
      final store = await storeWith(sample());

      expect(ids(store.results), ['CP_CD_01', 'NMA_BIO_01', 'NMA_BH_03', 'NMA_BH_01', 'RE_CG_01']);
      expect(store.status, PanelObjectsStatus.ready);
      expect(store.summary, '5 objetos');
    });

    test('tipo gravado pelo rótulo é reconhecido no filtro', () async {
      final store = await storeWith(sample());
      store.applySelection(const PanelSelection(type: ContentType.documento));

      expect(ids(store.results), ['CP_CD_01']);
    });
  });

  group('busca', () {
    for (final (query, expected) in [
      ('nma_bh', ['NMA_BH_03', 'NMA_BH_01']),
      ('nma-bh-03', ['NMA_BH_03']),
      ('bacia', ['NMA_BH_01']),
      ('São Paulo', ['CP_CD_01']),
      ('sao paulo', ['CP_CD_01']),
      ('rio francisco', ['NMA_BH_03']),
      ('instituto', ['NMA_BIO_01']),
      ('populacao', ['CP_CD_01']),
      ('cerrado brasil', <String>[]),
    ]) {
      test('"$query"', () async {
        final store = await storeWith(sample());
        store.applySelection(PanelSelection(query: query));

        expect(ids(store.results), expected);
      });
    }
  });

  group('filtros', () {
    test('tema, subtema, tipo e busca combinam', () async {
      final store = await storeWith(sample());

      store.applySelection(const PanelSelection(theme: ThemeEnum.naturezaMeioAmbiente));
      expect(ids(store.results), ['NMA_BIO_01', 'NMA_BH_03', 'NMA_BH_01']);
      expect(store.summary, '3 objetos');

      store.applySelection(
        const PanelSelection(
          theme: ThemeEnum.naturezaMeioAmbiente,
          subtheme: SubthemeEnum.baciasHidrograficas,
        ),
      );
      expect(ids(store.results), ['NMA_BH_03', 'NMA_BH_01']);
      expect(store.summary, '2 objetos com os filtros atuais');

      store.applySelection(
        const PanelSelection(
          theme: ThemeEnum.naturezaMeioAmbiente,
          subtheme: SubthemeEnum.baciasHidrograficas,
          query: 'rio',
        ),
      );
      expect(store.summary, '1 objeto com os filtros atuais');

      store.applySelection(
        const PanelSelection(theme: ThemeEnum.naturezaMeioAmbiente, type: ContentType.video),
      );
      expect(ids(store.results), ['NMA_BIO_01']);
    });

    test('subtemas do tema na ordem do site', () async {
      final store = await storeWith(sample());

      expect(store.subthemesOf(ThemeEnum.culturaPolitica), contains(SubthemeEnum.censoDemografico));
      expect(store.subthemesOf(ThemeEnum.culturaPolitica), isNot(contains(SubthemeEnum.biomas)));
    });
  });

  group('páginas', () {
    List<CatalogRecord> many(int count) => [
      for (var n = 1; n <= count; n++)
        dated('NMA_SUS', 'NMA_SUS_${n.toString().padLeft(2, '0')}', date: DateTime(2025, 1, n)),
    ];

    test('12 de cada vez; mudar um filtro volta aos 12 primeiros', () async {
      final store = await storeWith(many(30));

      expect(store.visible, hasLength(12));
      expect(store.footer, 'Mostrando 12 de 30');
      expect(store.hasMore, isTrue);

      store.showMore();
      expect(store.visible, hasLength(24));
      store.showMore();
      expect(store.visible, hasLength(30));
      expect(store.hasMore, isFalse);
      expect(store.footer, 'Mostrando 30 de 30');

      store.applySelection(const PanelSelection(query: 'nma'));
      expect(store.visible, hasLength(12));
    });

    test('exatamente 12, sem mais; 1 resultado no singular', () async {
      final store = await storeWith(many(12));
      expect(store.hasMore, isFalse);

      store.applySelection(const PanelSelection(query: 'nma_sus_07'));
      expect(store.summary, '1 objeto com os filtros atuais');
      expect(store.footer, 'Mostrando 1 de 1');
    });

    test('a mesma seleção não volta à primeira página', () async {
      final store = await storeWith(many(30));
      store.showMore();

      store.applySelection(const PanelSelection());

      expect(store.visible, hasLength(24));
    });
  });

  group('excluídos', () {
    test('somem na hora e deixam de valer quando o catálogo recarrega', () async {
      final store = await storeWith(sample());

      store.hide('doc_NMA_BH_03');
      expect(ids(store.results), isNot(contains('NMA_BH_03')));
      expect(store.total, 4);

      final refreshing = catalog.refresh();
      repository.succeed(sample());
      await refreshing;

      expect(ids(store.results), contains('NMA_BH_03'));
    });

    test('excluir o último do filtro dá vazio com filtros; o último de todos, vazio', () async {
      final store = await storeWith([dated('NMA_BH', 'NMA_BH_01')]);

      store.applySelection(const PanelSelection(query: 'nma'));
      store.hide('doc_NMA_BH_01');
      expect(store.status, PanelObjectsStatus.empty);

      final other = await storeWith([dated('NMA_BH', 'NMA_BH_01'), dated('CP_CD', 'CP_CD_01')]);
      other.applySelection(const PanelSelection(query: 'nma'));
      other.hide('doc_NMA_BH_01');
      expect(other.status, PanelObjectsStatus.emptyFiltered);
    });
  });

  group('situação', () {
    test('carregando sem catálogo e erro', () async {
      repository = FakeCatalogRepository();
      catalog = CatalogStore(repository);
      final store = PanelObjectsStore(catalog);
      final loading = catalog.ensureLoaded();

      expect(store.status, PanelObjectsStatus.loading);
      repository.fail();
      await loading;
      expect(store.status, PanelObjectsStatus.error);
    });

    test('sem objetos e vazio com filtros', () async {
      final empty = await storeWith([]);
      expect(empty.status, PanelObjectsStatus.empty);

      final store = await storeWith(sample());
      store.applySelection(const PanelSelection(query: 'xyz'));
      expect(store.status, PanelObjectsStatus.emptyFiltered);
    });

    test('recarga em andamento mantém a lista atual', () async {
      final store = await storeWith(sample());

      final refreshing = catalog.refresh();
      expect(store.status, PanelObjectsStatus.ready);
      expect(store.total, 5);
      repository.succeed(sample());
      await refreshing;
    });
  });
}
