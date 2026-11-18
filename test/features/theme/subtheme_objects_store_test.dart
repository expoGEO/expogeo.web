import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/presentation/stores/subtheme_objects_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../catalog/catalog_test_data.dart';

void main() {
  const biomas = 'NMA_BIO';

  Future<SubthemeObjectsStore> storeWith(
    List<CatalogRecord> records, {
    SubthemeEnum subtheme = SubthemeEnum.biomas,
  }) async {
    final repository = FakeCatalogRepository();
    final catalog = CatalogStore(repository);
    final loading = catalog.ensureLoaded();
    repository.succeed(records);
    await loading;
    return SubthemeObjectsStore(subtheme, catalog);
  }

  List<String> ids(List<CatalogItem> items) => [for (final i in items) i.content.id];

  CatalogRecord numbered(int n, {String type = 'site'}) =>
      objectWith(biomas, 'NMA_BIO_${n.toString().padLeft(2, '0')}', type: type);

  List<CatalogRecord> many(int count) => [for (var n = 1; n <= count; n++) numbered(n)];

  group('recorte', () {
    test('só objetos do subtema, na ordem do código', () async {
      final store = await storeWith([
        numbered(10),
        objectWith('NMA_SUS', 'NMA_SUS_01'),
        numbered(2),
        numbered(1),
      ]);

      expect(ids(store.items), ['NMA_BIO_01', 'NMA_BIO_02', 'NMA_BIO_10']);
    });
  });

  group('busca', () {
    late SubthemeObjectsStore store;

    setUp(() async {
      store = await storeWith([
        objectWith(biomas, 'A_01', title: 'História da Cartografia'),
        objectWith(biomas, 'A_02', description: 'Uso da água no campo'),
        objectWith(biomas, 'A_03', creator: 'Instituto Geográfico'),
        objectWith(biomas, 'A_04', collaborator: 'Museu Nacional'),
        objectWith(biomas, 'A_05', note: 'Inclui legendas em libras'),
        objectWith(biomas, 'A_06', subjects: ['Permafrost']),
        objectWith(biomas, 'A_07', title: 'Mapa antigo', creator: 'Museu Paulista'),
      ]);
    });

    List<String> search(String text) {
      store.setQuery(text);
      return ids(store.matches);
    }

    test('maiúsculas não importam', () {
      expect(search('cartografia'), ['A_01']);
      expect(search('CARTOGRAFIA'), ['A_01']);
    });

    test('acentos não importam', () {
      expect(search('agua'), ['A_02']);
      expect(search('água'), ['A_02']);
    });

    test('cada um dos seis campos', () {
      expect(search('historia'), ['A_01']);
      expect(search('campo'), ['A_02']);
      expect(search('geografico'), ['A_03']);
      expect(search('nacional'), ['A_04']);
      expect(search('libras'), ['A_05']);
      expect(search('permafrost'), ['A_06']);
    });

    test('duas palavras precisam aparecer, em qualquer campo', () {
      expect(search('mapa paulista'), ['A_07']);
      expect(search('mapa nacional'), isEmpty);
    });

    test('só espaços contam como busca vazia', () {
      expect(search('   '), hasLength(7));
    });
  });

  group('tipos', () {
    late SubthemeObjectsStore store;

    setUp(() async {
      store = await storeWith([
        objectWith(biomas, 'A_01', title: 'mapa', type: 'outro'),
        objectWith(biomas, 'A_02', title: 'mapa', type: 'imagem'),
        objectWith(biomas, 'A_03', title: 'mapa', type: 'aplicativo'),
        objectWith(biomas, 'A_04', title: 'mapa', type: 'documento'),
        objectWith(biomas, 'A_05', title: 'mapa', type: 'video'),
        objectWith(biomas, 'A_06', title: 'mapa', type: 'site'),
        objectWith(biomas, 'A_07', title: 'rio', type: 'site'),
      ]);
    });

    test('ordem da spec, não a do enum', () {
      expect(store.chipTypes, [
        ContentType.site,
        ContentType.video,
        ContentType.documento,
        ContentType.aplicativo,
        ContentType.imagem,
        ContentType.outro,
      ]);
    });

    test('contagem acompanha a busca', () {
      expect(store.typeCounts[ContentType.site], 2);
      store.setQuery('rio');
      expect(store.typeCounts, {ContentType.site: 1});
      expect(store.chipTypes, [ContentType.site]);
      expect(store.matches, hasLength(1));
    });

    test('tipo escolhido filtra a lista', () {
      store.selectType(ContentType.site);
      expect(ids(store.results), ['A_06', 'A_07']);
      expect(store.matches, hasLength(7));
    });

    test('tipo que some volta a nulo e não retorna com a busca', () {
      store.selectType(ContentType.video);
      store.setQuery('rio');
      expect(store.type, isNull);

      store.setQuery('');
      expect(store.type, isNull);
    });

    test('tipo que continua presente fica', () {
      store.selectType(ContentType.site);
      store.setQuery('rio');
      expect(store.type, ContentType.site);
    });
  });

  group('assuntos', () {
    test('até 8, por frequência e, no empate, em ordem alfabética sem acento', () async {
      final store = await storeWith([
        objectWith(
          biomas,
          'A_01',
          subjects: ['Zona', 'Água', 'Bacia', 'Mapa', 'Rio', 'Solo', 'Clima', 'Fauna', 'Flora'],
        ),
        objectWith(biomas, 'A_02', subjects: ['Zona']),
      ]);

      expect(store.frequentSubjects, [
        'Zona',
        'Água',
        'Bacia',
        'Clima',
        'Fauna',
        'Flora',
        'Mapa',
        'Rio',
      ]);
    });

    test('sem o nome do subtema, com qualquer caixa ou acento, e sem vazios', () async {
      final store = await storeWith([
        objectWith('RE_HC', 'A_01', subjects: ['HISTÓRIA da cartografia', '  ', '', 'Mapa']),
        objectWith('RE_HC', 'A_02', subjects: ['Historia da Cartografia', ' Mapa ']),
      ], subtheme: SubthemeEnum.historiaCartografia);

      expect(store.frequentSubjects, ['Mapa']);
    });

    test('a lista não muda com a busca nem com o tipo', () async {
      final store = await storeWith([
        objectWith(biomas, 'A_01', title: 'x', subjects: ['Rio']),
        objectWith(biomas, 'A_02', title: 'y', subjects: ['Solo']),
      ]);

      store.setQuery('x');
      expect(store.frequentSubjects, ['Rio', 'Solo']);
    });

    test('applySubject põe o texto na busca e zera tipo e quantidade', () async {
      final store = await storeWith([
        ...many(8),
        objectWith(biomas, 'A_01', subjects: ['Rio'], type: 'video'),
      ]);
      store.selectType(ContentType.site);
      store.loadMore();

      store.applySubject('Rio');

      expect(store.query, 'Rio');
      expect(store.type, isNull);
      expect(store.shown, 6);
      expect(ids(store.visible), ['A_01']);
    });
  });

  group('quantidade mostrada', () {
    test('de 6 em 6 até o fim', () async {
      final store = await storeWith(many(14));

      expect(store.visible, hasLength(6));
      expect(store.hasMore, isTrue);
      store.loadMore();
      expect(store.visible, hasLength(12));
      expect(store.hasMore, isTrue);
      store.loadMore();
      expect(store.visible, hasLength(14));
      expect(store.hasMore, isFalse);
    });

    test('6 exatos não têm mais', () async {
      final store = await storeWith(many(6));

      expect(store.hasMore, isFalse);
    });

    test('busca, tipo e limpar voltam a mostrar 6', () async {
      final store = await storeWith(many(14));

      store.loadMore();
      store.setQuery('sem');
      expect(store.shown, 6);

      store.loadMore();
      store.selectType(ContentType.site);
      expect(store.shown, 6);

      store.loadMore();
      store.clearSearch();
      expect(store.shown, 6);
    });
  });

  group('limpar', () {
    test('clearSearch mantém o tipo', () async {
      final store = await storeWith(many(2));
      store.selectType(ContentType.site);
      store.setQuery('sem');

      store.clearSearch();

      expect(store.query, isEmpty);
      expect(store.type, ContentType.site);
    });

    test('reset zera tudo', () async {
      final store = await storeWith(many(8));
      store.selectType(ContentType.site);
      store.setQuery('sem');
      store.loadMore();

      store.reset();

      expect(store.query, isEmpty);
      expect(store.type, isNull);
      expect(store.shown, 6);
    });
  });

  group('contagem', () {
    test('plural, singular e busca entre aspas curvas', () async {
      final store = await storeWith([...many(7), objectWith(biomas, 'NMA_BIO_08', title: 'Mapa')]);

      expect(store.summary, 'Mostrando 6 de 8 objetos');
      store.setQuery(' mapa ');
      expect(store.summary, 'Mostrando 1 de 1 objeto para “mapa”');
      store.setQuery('nada disso');
      expect(store.summary, isEmpty);
    });
  });

  test('sem catálogo carregado, nada na lista', () {
    final store = SubthemeObjectsStore(SubthemeEnum.biomas, CatalogStore(FakeCatalogRepository()));

    expect(store.items, isEmpty);
    expect(store.frequentSubjects, isEmpty);
  });
}
