import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:expogeo/features/catalog/infra/errors/catalog_failure.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/infra/repositories/catalog_repository.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter_test/flutter_test.dart';

import 'catalog_test_data.dart';

class _FakeRepository implements CatalogRepository {
  int calls = 0;
  final List<Completer<Either<CatalogFailure, CatalogModel>>> pending = [];

  @override
  Future<Either<CatalogFailure, CatalogModel>> load() {
    calls++;
    final completer = Completer<Either<CatalogFailure, CatalogModel>>();
    pending.add(completer);
    return completer.future;
  }

  void succeed() => pending.removeLast().complete(Right(CatalogModel.fromRecords(devRecords())));

  void fail() => pending.removeLast().complete(const Left(CatalogFetchFailure('negado')));
}

void main() {
  test(
    'chamadas simultâneas fazem uma consulta só e passam por carregando até o sucesso',
    () async {
      final repository = _FakeRepository();
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
    final repository = _FakeRepository();
    final store = CatalogStore(repository);

    final load = store.ensureLoaded();
    repository.succeed();
    await load;
    await store.ensureLoaded();

    expect(repository.calls, 1);
  });

  test('depois de erro, a próxima chamada consulta de novo', () async {
    final repository = _FakeRepository();
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
}
