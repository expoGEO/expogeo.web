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
}
