import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/fake_content.dart';

void main() {
  group('resultado', () {
    test('cada operação bem-sucedida publica o seu', () async {
      final store = ContentStore(FakeContentRepository());

      await store.createContent(subtheme: SubthemeEnum.biomas, content: sampleContent());
      expect(store.outcome?.kind, ContentOutcomeKind.created);

      await store.updateContent(
        subtheme: SubthemeEnum.biomas,
        contentId: 'doc_1',
        content: sampleContent(),
      );
      expect(store.outcome?.kind, ContentOutcomeKind.updated);

      await store.deleteContent(subtheme: SubthemeEnum.biomas, contentId: 'doc_1');
      expect(store.outcome?.kind, ContentOutcomeKind.deleted);
      expect(store.outcome?.docId, 'doc_1');
      expect(store.isBusy, isFalse);
    });

    test('falhas publicam a falha de salvar ou de excluir', () async {
      final store = ContentStore(FakeContentRepository()..failWrites = true);

      await store.createContent(subtheme: SubthemeEnum.biomas, content: sampleContent());
      expect(store.outcome?.kind, ContentOutcomeKind.saveFailed);

      await store.updateContent(
        subtheme: SubthemeEnum.biomas,
        contentId: 'doc_1',
        content: sampleContent(),
      );
      expect(store.outcome?.kind, ContentOutcomeKind.saveFailed);

      await store.deleteContent(subtheme: SubthemeEnum.biomas, contentId: 'doc_1');
      expect(store.outcome?.kind, ContentOutcomeKind.deleteFailed);
      expect(store.outcome?.docId, 'doc_1');
    });

    test('dois resultados iguais seguidos são objetos diferentes', () async {
      final store = ContentStore(FakeContentRepository());

      await store.createContent(subtheme: SubthemeEnum.biomas, content: sampleContent());
      final first = store.outcome;
      await store.createContent(subtheme: SubthemeEnum.biomas, content: sampleContent());

      expect(identical(store.outcome, first), isFalse);
    });
  });

  test('a exclusão usa o subtema recebido', () async {
    final repository = FakeContentRepository();
    final store = ContentStore(repository);

    await store.deleteContent(subtheme: SubthemeEnum.queimadas, contentId: 'doc_9');

    expect(repository.calls, ['delete:queimadas:doc_9']);
  });

  group('savedCount', () {
    test('sobe ao criar, editar e excluir com sucesso', () async {
      final store = ContentStore(FakeContentRepository());

      await store.createContent(subtheme: SubthemeEnum.biomas, content: sampleContent());
      await store.updateContent(
        subtheme: SubthemeEnum.biomas,
        contentId: 'doc_1',
        content: sampleContent(),
      );
      await store.deleteContent(subtheme: SubthemeEnum.biomas, contentId: 'doc_1');

      expect(store.savedCount, 3);
    });

    test('não sobe em falha', () async {
      final store = ContentStore(FakeContentRepository()..failWrites = true);

      await store.createContent(subtheme: SubthemeEnum.biomas, content: sampleContent());
      await store.deleteContent(subtheme: SubthemeEnum.biomas, contentId: 'doc_1');

      expect(store.savedCount, 0);
    });
  });

  group('editor', () {
    test('criar devolve o código gravado, o próximo do subtema', () async {
      final repository = FakeContentRepository(
        contents: [
          sampleContent('a').withCode('RE_CG_01'),
          sampleContent('b').withCode('RE_CG_02'),
        ],
      );
      final store = ContentStore(repository);

      final outcome = await store.createContent(
        subtheme: SubthemeEnum.coordenadasGeograficas,
        content: sampleContent(),
      );

      expect(outcome.kind, ContentOutcomeKind.created);
      expect(outcome.code, 'RE_CG_03');
      expect(store.outcome?.code, 'RE_CG_03');
      expect(repository.written.single.id, 'RE_CG_03');
      expect(repository.written.single.docId, 'RE_CG_03');
    });

    test('código ocupado na hora de gravar vai para o seguinte', () async {
      final repository = FakeContentRepository(contents: [sampleContent().withCode('RE_CG_01')])
        ..takenCodes.add('RE_CG_02');
      final store = ContentStore(repository);

      final outcome = await store.createContent(
        subtheme: SubthemeEnum.coordenadasGeograficas,
        content: sampleContent(),
      );

      expect(outcome.code, 'RE_CG_03');
    });

    test('mudar de subtema grava com o código do novo e publica "updated"', () async {
      final repository = FakeContentRepository();
      final store = ContentStore(repository);

      final outcome = await store.moveContent(
        from: SubthemeEnum.coordenadasGeograficas,
        docId: 'RE_CG_01',
        to: SubthemeEnum.biomas,
        content: sampleContent(),
      );

      expect(outcome.kind, ContentOutcomeKind.updated);
      expect(outcome.code, 'NMA_BIO_01');
      expect(repository.calls, ['move:coordenadas-geograficas:RE_CG_01:biomas']);
      expect(store.savedCount, 1);
    });

    test('falha ao criar ou mover publica a falha de salvar, sem código', () async {
      final store = ContentStore(FakeContentRepository()..failWrites = true);

      final created = await store.createContent(
        subtheme: SubthemeEnum.biomas,
        content: sampleContent(),
      );
      final moved = await store.moveContent(
        from: SubthemeEnum.coordenadasGeograficas,
        docId: 'doc_1',
        to: SubthemeEnum.biomas,
        content: sampleContent(),
      );

      expect(created.kind, ContentOutcomeKind.saveFailed);
      expect(moved.kind, ContentOutcomeKind.saveFailed);
      expect(created.code, isNull);
      expect(store.isBusy, isFalse);
    });
  });
}
