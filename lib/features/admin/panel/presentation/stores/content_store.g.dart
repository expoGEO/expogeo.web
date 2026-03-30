// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContentStore on ContentStoreBase, Store {
  late final _$stateAtom = Atom(
    name: 'ContentStoreBase.state',
    context: context,
  );

  @override
  ContentState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(ContentState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$contentsAtom = Atom(
    name: 'ContentStoreBase.contents',
    context: context,
  );

  @override
  List<ContentResponseModel> get contents {
    _$contentsAtom.reportRead();
    return super.contents;
  }

  @override
  set contents(List<ContentResponseModel> value) {
    _$contentsAtom.reportWrite(value, super.contents, () {
      super.contents = value;
    });
  }

  late final _$selectedThemeAtom = Atom(
    name: 'ContentStoreBase.selectedTheme',
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

  late final _$selectedSubthemeAtom = Atom(
    name: 'ContentStoreBase.selectedSubtheme',
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

  late final _$loadContentsBySubthemeAsyncAction = AsyncAction(
    'ContentStoreBase.loadContentsBySubtheme',
    context: context,
  );

  @override
  Future<void> loadContentsBySubtheme({required SubthemeEnum subtheme}) {
    return _$loadContentsBySubthemeAsyncAction.run(
      () => super.loadContentsBySubtheme(subtheme: subtheme),
    );
  }

  late final _$loadContentsByThemeAsyncAction = AsyncAction(
    'ContentStoreBase.loadContentsByTheme',
    context: context,
  );

  @override
  Future<void> loadContentsByTheme({required ThemeEnum theme}) {
    return _$loadContentsByThemeAsyncAction.run(
      () => super.loadContentsByTheme(theme: theme),
    );
  }

  late final _$loadAllContentsAsyncAction = AsyncAction(
    'ContentStoreBase.loadAllContents',
    context: context,
  );

  @override
  Future<void> loadAllContents() {
    return _$loadAllContentsAsyncAction.run(() => super.loadAllContents());
  }

  late final _$createContentAsyncAction = AsyncAction(
    'ContentStoreBase.createContent',
    context: context,
  );

  @override
  Future<void> createContent({
    required SubthemeEnum subtheme,
    required ContentResponseModel content,
  }) {
    return _$createContentAsyncAction.run(
      () => super.createContent(subtheme: subtheme, content: content),
    );
  }

  late final _$updateContentAsyncAction = AsyncAction(
    'ContentStoreBase.updateContent',
    context: context,
  );

  @override
  Future<void> updateContent({
    required SubthemeEnum subtheme,
    required String contentId,
    required ContentResponseModel content,
  }) {
    return _$updateContentAsyncAction.run(
      () => super.updateContent(
        subtheme: subtheme,
        contentId: contentId,
        content: content,
      ),
    );
  }

  late final _$deleteContentAsyncAction = AsyncAction(
    'ContentStoreBase.deleteContent',
    context: context,
  );

  @override
  Future<void> deleteContent({
    required SubthemeEnum subtheme,
    required String contentId,
  }) {
    return _$deleteContentAsyncAction.run(
      () => super.deleteContent(subtheme: subtheme, contentId: contentId),
    );
  }

  late final _$ContentStoreBaseActionController = ActionController(
    name: 'ContentStoreBase',
    context: context,
  );

  @override
  void reset() {
    final _$actionInfo = _$ContentStoreBaseActionController.startAction(
      name: 'ContentStoreBase.reset',
    );
    try {
      return super.reset();
    } finally {
      _$ContentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
contents: ${contents},
selectedTheme: ${selectedTheme},
selectedSubtheme: ${selectedSubtheme}
    ''';
  }
}
