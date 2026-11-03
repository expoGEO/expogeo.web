import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';

sealed class CatalogState {
  const CatalogState();

  bool get isInitial => this is CatalogStateInitial;
  bool get isLoading => this is CatalogStateLoading;
  bool get isSuccess => this is CatalogStateSuccess;
  bool get isError => this is CatalogStateError;
}

class CatalogStateInitial extends CatalogState {
  const CatalogStateInitial();
}

class CatalogStateLoading extends CatalogState {
  const CatalogStateLoading();
}

class CatalogStateSuccess extends CatalogState {
  const CatalogStateSuccess(this.catalog);

  final CatalogModel catalog;
}

class CatalogStateError extends CatalogState {
  const CatalogStateError(this.message);

  final String message;
}
