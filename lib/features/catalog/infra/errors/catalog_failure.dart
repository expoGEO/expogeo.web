sealed class CatalogFailure implements Exception {
  const CatalogFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class CatalogFetchFailure extends CatalogFailure {
  const CatalogFetchFailure(super.message);
}

class CatalogTimeoutFailure extends CatalogFailure {
  const CatalogTimeoutFailure(super.message);
}

class CatalogGenericFailure extends CatalogFailure {
  const CatalogGenericFailure(super.message);
}
