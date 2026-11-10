// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContentStore on ContentStoreBase, Store {
  late final _$isBusyAtom = Atom(
    name: 'ContentStoreBase.isBusy',
    context: context,
  );

  @override
  bool get isBusy {
    _$isBusyAtom.reportRead();
    return super.isBusy;
  }

  @override
  set isBusy(bool value) {
    _$isBusyAtom.reportWrite(value, super.isBusy, () {
      super.isBusy = value;
    });
  }

  late final _$outcomeAtom = Atom(
    name: 'ContentStoreBase.outcome',
    context: context,
  );

  @override
  ContentOutcome? get outcome {
    _$outcomeAtom.reportRead();
    return super.outcome;
  }

  @override
  set outcome(ContentOutcome? value) {
    _$outcomeAtom.reportWrite(value, super.outcome, () {
      super.outcome = value;
    });
  }

  late final _$savedCountAtom = Atom(
    name: 'ContentStoreBase.savedCount',
    context: context,
  );

  @override
  int get savedCount {
    _$savedCountAtom.reportRead();
    return super.savedCount;
  }

  @override
  set savedCount(int value) {
    _$savedCountAtom.reportWrite(value, super.savedCount, () {
      super.savedCount = value;
    });
  }

  late final _$createContentAsyncAction = AsyncAction(
    'ContentStoreBase.createContent',
    context: context,
  );

  @override
  Future<ContentOutcome> createContent({
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
  Future<ContentOutcome> updateContent({
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

  late final _$moveContentAsyncAction = AsyncAction(
    'ContentStoreBase.moveContent',
    context: context,
  );

  @override
  Future<ContentOutcome> moveContent({
    required SubthemeEnum from,
    required String docId,
    required SubthemeEnum to,
    required ContentResponseModel content,
  }) {
    return _$moveContentAsyncAction.run(
      () =>
          super.moveContent(from: from, docId: docId, to: to, content: content),
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
  ContentOutcome _finish(ContentOutcome result) {
    final _$actionInfo = _$ContentStoreBaseActionController.startAction(
      name: 'ContentStoreBase._finish',
    );
    try {
      return super._finish(result);
    } finally {
      _$ContentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isBusy: ${isBusy},
outcome: ${outcome},
savedCount: ${savedCount}
    ''';
  }
}
