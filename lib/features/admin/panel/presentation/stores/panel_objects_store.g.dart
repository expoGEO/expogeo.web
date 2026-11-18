// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_objects_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PanelObjectsStore on PanelObjectsStoreBase, Store {
  Computed<List<CatalogItem>>? _$itemsComputed;

  @override
  List<CatalogItem> get items =>
      (_$itemsComputed ??= Computed<List<CatalogItem>>(
        () => super.items,
        name: 'PanelObjectsStoreBase.items',
      )).value;
  Computed<Map<CatalogItem, String>>? _$_searchIndexComputed;

  @override
  Map<CatalogItem, String> get _searchIndex =>
      (_$_searchIndexComputed ??= Computed<Map<CatalogItem, String>>(
        () => super._searchIndex,
        name: 'PanelObjectsStoreBase._searchIndex',
      )).value;
  Computed<List<CatalogItem>>? _$resultsComputed;

  @override
  List<CatalogItem> get results =>
      (_$resultsComputed ??= Computed<List<CatalogItem>>(
        () => super.results,
        name: 'PanelObjectsStoreBase.results',
      )).value;
  Computed<List<CatalogItem>>? _$visibleComputed;

  @override
  List<CatalogItem> get visible =>
      (_$visibleComputed ??= Computed<List<CatalogItem>>(
        () => super.visible,
        name: 'PanelObjectsStoreBase.visible',
      )).value;
  Computed<String>? _$summaryComputed;

  @override
  String get summary => (_$summaryComputed ??= Computed<String>(
    () => super.summary,
    name: 'PanelObjectsStoreBase.summary',
  )).value;
  Computed<String>? _$footerComputed;

  @override
  String get footer => (_$footerComputed ??= Computed<String>(
    () => super.footer,
    name: 'PanelObjectsStoreBase.footer',
  )).value;
  Computed<PanelObjectsStatus>? _$statusComputed;

  @override
  PanelObjectsStatus get status =>
      (_$statusComputed ??= Computed<PanelObjectsStatus>(
        () => super.status,
        name: 'PanelObjectsStoreBase.status',
      )).value;

  late final _$selectionAtom = Atom(
    name: 'PanelObjectsStoreBase.selection',
    context: context,
  );

  @override
  PanelSelection get selection {
    _$selectionAtom.reportRead();
    return super.selection;
  }

  @override
  set selection(PanelSelection value) {
    _$selectionAtom.reportWrite(value, super.selection, () {
      super.selection = value;
    });
  }

  late final _$shownAtom = Atom(
    name: 'PanelObjectsStoreBase.shown',
    context: context,
  );

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

  late final _$_hiddenAtom = Atom(
    name: 'PanelObjectsStoreBase._hidden',
    context: context,
  );

  @override
  ObservableSet<String> get _hidden {
    _$_hiddenAtom.reportRead();
    return super._hidden;
  }

  @override
  set _hidden(ObservableSet<String> value) {
    _$_hiddenAtom.reportWrite(value, super._hidden, () {
      super._hidden = value;
    });
  }

  late final _$_hiddenInAtom = Atom(
    name: 'PanelObjectsStoreBase._hiddenIn',
    context: context,
  );

  @override
  CatalogModel? get _hiddenIn {
    _$_hiddenInAtom.reportRead();
    return super._hiddenIn;
  }

  @override
  set _hiddenIn(CatalogModel? value) {
    _$_hiddenInAtom.reportWrite(value, super._hiddenIn, () {
      super._hiddenIn = value;
    });
  }

  late final _$PanelObjectsStoreBaseActionController = ActionController(
    name: 'PanelObjectsStoreBase',
    context: context,
  );

  @override
  void applySelection(PanelSelection next) {
    final _$actionInfo = _$PanelObjectsStoreBaseActionController.startAction(
      name: 'PanelObjectsStoreBase.applySelection',
    );
    try {
      return super.applySelection(next);
    } finally {
      _$PanelObjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void showMore() {
    final _$actionInfo = _$PanelObjectsStoreBaseActionController.startAction(
      name: 'PanelObjectsStoreBase.showMore',
    );
    try {
      return super.showMore();
    } finally {
      _$PanelObjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void hide(String docId) {
    final _$actionInfo = _$PanelObjectsStoreBaseActionController.startAction(
      name: 'PanelObjectsStoreBase.hide',
    );
    try {
      return super.hide(docId);
    } finally {
      _$PanelObjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selection: ${selection},
shown: ${shown},
items: ${items},
results: ${results},
visible: ${visible},
summary: ${summary},
footer: ${footer},
status: ${status}
    ''';
  }
}
