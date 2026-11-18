import 'package:expogeo/features/catalog/infra/datasources/catalog_datasource.dart';
import 'package:expogeo/features/catalog/infra/errors/catalog_failure.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/infra/repositories/catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _OfflineDatasource implements CatalogDatasource {
  @override
  Future<List<CatalogRecord>> fetchAll() async => throw const CatalogOfflineException();
}

void main() {
  test('resposta vazia vinda do cache é recusada', () {
    expect(
      () => CatalogDatasource.checkSnapshot(isEmpty: true, isFromCache: true),
      throwsA(isA<CatalogOfflineException>()),
    );
  });

  test('vazio do servidor e cheio do cache passam', () {
    expect(
      () => CatalogDatasource.checkSnapshot(isEmpty: true, isFromCache: false),
      returnsNormally,
    );
    expect(
      () => CatalogDatasource.checkSnapshot(isEmpty: false, isFromCache: true),
      returnsNormally,
    );
  });

  test('o repositório transforma a recusa em falha de consulta', () async {
    final result = await CatalogRepository(_OfflineDatasource()).load();

    expect(result.fold((failure) => failure, (_) => null), isA<CatalogFetchFailure>());
  });
}
