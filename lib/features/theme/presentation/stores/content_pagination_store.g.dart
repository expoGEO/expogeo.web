// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_pagination_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContentPaginationStore on ContentPaginationStoreBase, Store {
  late final _$stateAtom = Atom(
    name: 'ContentPaginationStoreBase.state',
    context: context,
  );

  @override
  ContentPaginationState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(ContentPaginationState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$selectedSubthemeAtom = Atom(
    name: 'ContentPaginationStoreBase.selectedSubtheme',
    context: context,
  );

  @override
  SubthemeEnum? get selectedSubtheme {
    _$selectedSubthemeAtom.reportRead();
    return super.selectedSubtheme;
  }

  @override
  set selectedSubtheme(SubthemeEnum? value) {
    _$selectedSubthemeAtom.reportWrite(value, super.selectedSubtheme, () {
      super.selectedSubtheme = value;
    });
  }

  late final _$selectedThemeAtom = Atom(
    name: 'ContentPaginationStoreBase.selectedTheme',
    context: context,
  );

  @override
  ThemeEnum? get selectedTheme {
    _$selectedThemeAtom.reportRead();
    return super.selectedTheme;
  }

  @override
  set selectedTheme(ThemeEnum? value) {
    _$selectedThemeAtom.reportWrite(value, super.selectedTheme, () {
      super.selectedTheme = value;
    });
  }

  late final _$loadContentsBySubthemeAsyncAction = AsyncAction(
    'ContentPaginationStoreBase.loadContentsBySubtheme',
    context: context,
  );

  @override
  Future<void> loadContentsBySubtheme({
    required SubthemeEnum subtheme,
    ThemeEnum? theme,
  }) {
    return _$loadContentsBySubthemeAsyncAction.run(
      () => super.loadContentsBySubtheme(subtheme: subtheme, theme: theme),
    );
  }

  late final _$nextPageAsyncAction = AsyncAction(
    'ContentPaginationStoreBase.nextPage',
    context: context,
  );

  @override
  Future<void> nextPage() {
    return _$nextPageAsyncAction.run(() => super.nextPage());
  }

  late final _$previousPageAsyncAction = AsyncAction(
    'ContentPaginationStoreBase.previousPage',
    context: context,
  );

  @override
  Future<void> previousPage() {
    return _$previousPageAsyncAction.run(() => super.previousPage());
  }

  late final _$refreshAsyncAction = AsyncAction(
    'ContentPaginationStoreBase.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$resetToFirstPageAsyncAction = AsyncAction(
    'ContentPaginationStoreBase.resetToFirstPage',
    context: context,
  );

  @override
  Future<void> resetToFirstPage() {
    return _$resetToFirstPageAsyncAction.run(() => super.resetToFirstPage());
  }

  late final _$ContentPaginationStoreBaseActionController = ActionController(
    name: 'ContentPaginationStoreBase',
    context: context,
  );

  @override
  void reset() {
    final _$actionInfo = _$ContentPaginationStoreBaseActionController
        .startAction(name: 'ContentPaginationStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$ContentPaginationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
selectedSubtheme: ${selectedSubtheme},
selectedTheme: ${selectedTheme}
    ''';
  }
}
