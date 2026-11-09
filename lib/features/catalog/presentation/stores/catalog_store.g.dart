// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CatalogStore on CatalogStoreBase, Store {
  Computed<CatalogModel?>? _$catalogComputed;

  @override
  CatalogModel? get catalog => (_$catalogComputed ??= Computed<CatalogModel?>(
    () => super.catalog,
    name: 'CatalogStoreBase.catalog',
  )).value;

  late final _$stateAtom = Atom(
    name: 'CatalogStoreBase.state',
    context: context,
  );

  @override
  CatalogState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(CatalogState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$ensureLoadedAsyncAction = AsyncAction(
    'CatalogStoreBase.ensureLoaded',
    context: context,
  );

  @override
  Future<void> ensureLoaded() {
    return _$ensureLoadedAsyncAction.run(() => super.ensureLoaded());
  }

  late final _$refreshAsyncAction = AsyncAction(
    'CatalogStoreBase.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$CatalogStoreBaseActionController = ActionController(
    name: 'CatalogStoreBase',
    context: context,
  );

  @override
  void _apply(CatalogState next) {
    final _$actionInfo = _$CatalogStoreBaseActionController.startAction(
      name: 'CatalogStoreBase._apply',
    );
    try {
      return super._apply(next);
    } finally {
      _$CatalogStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
catalog: ${catalog}
    ''';
  }
}
