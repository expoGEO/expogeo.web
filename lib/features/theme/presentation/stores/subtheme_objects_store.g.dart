// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtheme_objects_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubthemeObjectsStore on SubthemeObjectsStoreBase, Store {
  Computed<List<CatalogItem>>? _$itemsComputed;

  @override
  List<CatalogItem> get items => (_$itemsComputed ??= Computed<List<CatalogItem>>(
    () => super.items,
    name: 'SubthemeObjectsStoreBase.items',
  )).value;
  Computed<Map<CatalogItem, String>>? _$_searchIndexComputed;

  @override
  Map<CatalogItem, String> get _searchIndex =>
      (_$_searchIndexComputed ??= Computed<Map<CatalogItem, String>>(
        () => super._searchIndex,
        name: 'SubthemeObjectsStoreBase._searchIndex',
      )).value;
  Computed<List<CatalogItem>>? _$matchesComputed;

  @override
  List<CatalogItem> get matches => (_$matchesComputed ??= Computed<List<CatalogItem>>(
    () => super.matches,
    name: 'SubthemeObjectsStoreBase.matches',
  )).value;
  Computed<Map<ContentType, int>>? _$typeCountsComputed;

  @override
  Map<ContentType, int> get typeCounts => (_$typeCountsComputed ??= Computed<Map<ContentType, int>>(
    () => super.typeCounts,
    name: 'SubthemeObjectsStoreBase.typeCounts',
  )).value;
  Computed<List<ContentType>>? _$chipTypesComputed;

  @override
  List<ContentType> get chipTypes => (_$chipTypesComputed ??= Computed<List<ContentType>>(
    () => super.chipTypes,
    name: 'SubthemeObjectsStoreBase.chipTypes',
  )).value;
  Computed<List<CatalogItem>>? _$resultsComputed;

  @override
  List<CatalogItem> get results => (_$resultsComputed ??= Computed<List<CatalogItem>>(
    () => super.results,
    name: 'SubthemeObjectsStoreBase.results',
  )).value;
  Computed<List<CatalogItem>>? _$visibleComputed;

  @override
  List<CatalogItem> get visible => (_$visibleComputed ??= Computed<List<CatalogItem>>(
    () => super.visible,
    name: 'SubthemeObjectsStoreBase.visible',
  )).value;
  Computed<String>? _$summaryComputed;

  @override
  String get summary => (_$summaryComputed ??= Computed<String>(
    () => super.summary,
    name: 'SubthemeObjectsStoreBase.summary',
  )).value;
  Computed<List<String>>? _$frequentSubjectsComputed;

  @override
  List<String> get frequentSubjects => (_$frequentSubjectsComputed ??= Computed<List<String>>(
    () => super.frequentSubjects,
    name: 'SubthemeObjectsStoreBase.frequentSubjects',
  )).value;

  late final _$queryAtom = Atom(name: 'SubthemeObjectsStoreBase.query', context: context);

  @override
  String get query {
    _$queryAtom.reportRead();
    return super.query;
  }

  @override
  set query(String value) {
    _$queryAtom.reportWrite(value, super.query, () {
      super.query = value;
    });
  }

  late final _$typeAtom = Atom(name: 'SubthemeObjectsStoreBase.type', context: context);

  @override
  ContentType? get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(ContentType? value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$shownAtom = Atom(name: 'SubthemeObjectsStoreBase.shown', context: context);

  @override
  int get shown {
    _$shownAtom.reportRead();
    return super.shown;
  }

  @override
  set shown(int value) {
    _$shownAtom.reportWrite(value, super.shown, () {
      super.shown = value;
    });
  }

  late final _$SubthemeObjectsStoreBaseActionController = ActionController(
    name: 'SubthemeObjectsStoreBase',
    context: context,
  );

  @override
  void setQuery(String text) {
    final _$actionInfo = _$SubthemeObjectsStoreBaseActionController.startAction(
      name: 'SubthemeObjectsStoreBase.setQuery',
    );
    try {
      return super.setQuery(text);
    } finally {
      _$SubthemeObjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectType(ContentType? value) {
    final _$actionInfo = _$SubthemeObjectsStoreBaseActionController.startAction(
      name: 'SubthemeObjectsStoreBase.selectType',
    );
    try {
      return super.selectType(value);
    } finally {
      _$SubthemeObjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void applySubject(String subject) {
    final _$actionInfo = _$SubthemeObjectsStoreBaseActionController.startAction(
      name: 'SubthemeObjectsStoreBase.applySubject',
    );
    try {
      return super.applySubject(subject);
    } finally {
      _$SubthemeObjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSearch() {
    final _$actionInfo = _$SubthemeObjectsStoreBaseActionController.startAction(
      name: 'SubthemeObjectsStoreBase.clearSearch',
    );
    try {
      return super.clearSearch();
    } finally {
      _$SubthemeObjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$SubthemeObjectsStoreBaseActionController.startAction(
      name: 'SubthemeObjectsStoreBase.reset',
    );
    try {
      return super.reset();
    } finally {
      _$SubthemeObjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadMore() {
    final _$actionInfo = _$SubthemeObjectsStoreBaseActionController.startAction(
      name: 'SubthemeObjectsStoreBase.loadMore',
    );
    try {
      return super.loadMore();
    } finally {
      _$SubthemeObjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
query: ${query},
type: ${type},
shown: ${shown},
items: ${items},
matches: ${matches},
typeCounts: ${typeCounts},
chipTypes: ${chipTypes},
results: ${results},
visible: ${visible},
summary: ${summary},
frequentSubjects: ${frequentSubjects}
    ''';
  }
}
