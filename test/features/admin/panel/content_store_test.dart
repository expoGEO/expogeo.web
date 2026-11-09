import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/fake_content.dart';

void main() {
  group('selectFromAddress', () {
    test('com tema e subtema guarda os dois e carrega o subtema', () async {
      final repository = FakeContentRepository();
      final store = ContentStore(repository);

      await store.selectFromAddress(
        theme: ThemeEnum.naturezaMeioAmbiente,
        subtheme: SubthemeEnum.biomas,
      );

      expect(store.selectedTheme, ThemeEnum.naturezaMeioAmbiente);
      expect(store.selectedSubtheme, SubthemeEnum.biomas);
      expect(repository.calls, ['subtheme:biomas']);
      expect(store.contents, hasLength(1));
      expect(store.state.isSuccess, isTrue);
    });

    test('só com tema carrega o tema', () async {
      final repository = FakeContentRepository();
      final store = ContentStore(repository);

      await store.selectFromAddress(theme: ThemeEnum.culturaPolitica);

      expect(store.selectedTheme, ThemeEnum.culturaPolitica);
      expect(store.selectedSubtheme, isNull);
      expect(repository.calls, ['theme:cultura-politica']);
    });

    test('sem tema limpa a escolha e a lista', () async {
      final repository = FakeContentRepository();
      final store = ContentStore(repository);
      await store.selectFromAddress(
        theme: ThemeEnum.naturezaMeioAmbiente,
        subtheme: SubthemeEnum.biomas,
      );

      await store.selectFromAddress();

      expect(store.selectedTheme, isNull);
      expect(store.selectedSubtheme, isNull);
      expect(store.contents, isEmpty);
      expect(store.state.isInitial, isTrue);
    });
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

    test('não sobe em falha nem em leitura', () async {
      final repository = FakeContentRepository()..failWrites = true;
      final store = ContentStore(repository);

      await store.createContent(subtheme: SubthemeEnum.biomas, content: sampleContent());
      await store.deleteContent(subtheme: SubthemeEnum.biomas, contentId: 'doc_1');
      await store.loadContentsByTheme(theme: ThemeEnum.culturaPolitica);
      await store.selectFromAddress(
        theme: ThemeEnum.naturezaMeioAmbiente,
        subtheme: SubthemeEnum.biomas,
      );

      expect(store.savedCount, 0);
    });
  });
}
