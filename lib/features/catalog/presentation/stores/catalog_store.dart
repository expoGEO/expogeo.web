import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/infra/repositories/catalog_repository.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_state.dart';
import 'package:mobx/mobx.dart';

part 'catalog_store.g.dart';

class CatalogStore = CatalogStoreBase with _$CatalogStore;

/// Acervo carregado uma vez por visita e compartilhado pelas telas.
abstract class CatalogStoreBase with Store {
  CatalogStoreBase(this._repository);

  final CatalogRepository _repository;

  @observable
  CatalogState state = const CatalogStateInitial();

  @computed
  CatalogModel? get catalog => switch (state) {
    CatalogStateSuccess(:final catalog) => catalog,
    _ => null,
  };

  /// Só consulta se ainda não carregou; depois de um erro, a próxima chamada tenta de novo.
  @action
  Future<void> ensureLoaded() async {
    if (state.isLoading || state.isSuccess) return;

    state = const CatalogStateLoading();
    final result = await _repository.load();
    _apply(result.fold((failure) => CatalogStateError(failure.message), CatalogStateSuccess.new));
  }

  @action
  void _apply(CatalogState next) => state = next;
}
