import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter_test/flutter_test.dart';

import 'catalog_test_data.dart';

void main() {
  test(
    'chamadas simultâneas fazem uma consulta só e passam por carregando até o sucesso',
    () async {
      final repository = FakeCatalogRepository();
      final store = CatalogStore(repository);

      final first = store.ensureLoaded();
      final second = store.ensureLoaded();
      expect(store.state, isA<CatalogStateLoading>());
      expect(repository.calls, 1);

      repository.succeed();
      await Future.wait([first, second]);

      expect(store.state, isA<CatalogStateSuccess>());
      expect(store.catalog?.total, 190);
    },
  );

  test('depois do sucesso, não consulta de novo', () async {
    final repository = FakeCatalogRepository();
    final store = CatalogStore(repository);

    final load = store.ensureLoaded();
    repository.succeed();
    await load;
    await store.ensureLoaded();

    expect(repository.calls, 1);
  });

  test('depois de erro, a próxima chamada consulta de novo', () async {
    final repository = FakeCatalogRepository();
    final store = CatalogStore(repository);

    final load = store.ensureLoaded();
    repository.fail();
    await load;
    expect(store.state, isA<CatalogStateError>());
    expect(store.catalog, isNull);

    final retry = store.ensureLoaded();
    expect(repository.calls, 2);
    repository.succeed();
    await retry;
    expect(store.state, isA<CatalogStateSuccess>());
  });

  test('depois de erro, várias novas tentativas seguidas fazem uma só consulta', () async {
    final repository = FakeCatalogRepository();
    final store = CatalogStore(repository);

    final load = store.ensureLoaded();
    repository.fail();
    await load;

    final retries = [store.ensureLoaded(), store.ensureLoaded(), store.ensureLoaded()];
    expect(repository.calls, 2);
    repository.succeed();
    await Future.wait(retries);
    expect(store.state, isA<CatalogStateSuccess>());
  });

  group('refresh', () {
    Future<CatalogStore> loaded(FakeCatalogRepository repository) async {
      final store = CatalogStore(repository);
      final load = store.ensureLoaded();
      repository.succeed();
      await load;
      return store;
    }

    test('sem catálogo, carrega como ensureLoaded', () async {
      final repository = FakeCatalogRepository();
      final store = CatalogStore(repository);

      final refresh = store.refresh();
      expect(store.state, isA<CatalogStateLoading>());
      repository.succeed();
      await refresh;

      expect(store.catalog?.total, 190);
    });

    test('com catálogo, mantém o anterior durante a busca e troca no sucesso', () async {
      final repository = FakeCatalogRepository();
      final store = await loaded(repository);

      final refresh = store.refresh();
      expect(repository.calls, 2);
      expect(store.state, isA<CatalogStateSuccess>());
      expect(store.catalog?.total, 190);

      repository.succeed(biomasRecords());
      await refresh;
      expect(store.catalog?.total, 7);
    });

    test('erro mantém o catálogo anterior', () async {
      final repository = FakeCatalogRepository();
      final store = await loaded(repository);

      final refresh = store.refresh();
      repository.fail();
      await refresh;

      expect(store.state, isA<CatalogStateSuccess>());
      expect(store.catalog?.total, 190);
    });

    test('erro sem catálogo vai para o estado de erro', () async {
      final repository = FakeCatalogRepository();
      final store = CatalogStore(repository);

      final refresh = store.refresh();
      repository.fail();
      await refresh;

      expect(store.state, isA<CatalogStateError>());
    });

    test('chamada com busca em andamento é ignorada', () async {
      final repository = FakeCatalogRepository();
      final store = await loaded(repository);

      final first = store.refresh();
      final second = store.refresh();
      await store.ensureLoaded();
      expect(repository.calls, 2);

      repository.succeed();
      await Future.wait([first, second]);
    });
  });
}
