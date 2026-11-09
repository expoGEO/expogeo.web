import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/admin/panel/infra/repositories/content_repository.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_state.dart';
import 'package:mobx/mobx.dart';

part 'content_store.g.dart';

class ContentStore = ContentStoreBase with _$ContentStore;

abstract class ContentStoreBase with Store {
  final ContentRepository _repository;

  ContentStoreBase(this._repository);

  @observable
  ContentState state = ContentStateInitial();

  @observable
  List<ContentResponseModel> contents = [];

  @observable
  ThemeEnum? selectedTheme;

  @observable
  SubthemeEnum? selectedSubtheme;

  /// Sobe a cada criação, edição ou exclusão bem-sucedida, para quem depende das contagens.
  @observable
  int savedCount = 0;

  /// Escolhe o tema e o subtema vindos do endereço e carrega a tabela deles; sem tema, limpa.
  @action
  Future<void> selectFromAddress({ThemeEnum? theme, SubthemeEnum? subtheme}) async {
    if (theme == null) {
      reset();
      return;
    }
    if (subtheme == null) {
      await loadContentsByTheme(theme: theme);
      return;
    }
    selectedTheme = theme;
    await loadContentsBySubtheme(subtheme: subtheme);
  }

  @action
  Future<void> loadContentsBySubtheme({required SubthemeEnum subtheme}) async {
    state = ContentStateLoading();

    selectedSubtheme = subtheme;

    final result = await _repository.getContentsBySubtheme(subtheme: subtheme);

    result.fold(
      (failure) {
        contents = [];
        state = ContentStateError(failure.message);
      },
      (loadedContents) {
        contents = loadedContents;
        state = ContentStateSuccess();
      },
    );
  }

  @action
  Future<void> loadContentsByTheme({required ThemeEnum theme}) async {
    state = ContentStateLoading();

    selectedTheme = theme;
    selectedSubtheme = null;

    final result = await _repository.getContentsByTheme(theme: theme);

    result.fold(
      (failure) {
        contents = [];
        state = ContentStateError(failure.message);
      },
      (loadedContents) {
        contents = loadedContents;
        state = ContentStateSuccess();
      },
    );
  }

  @action
  Future<void> loadAllContents() async {
    state = ContentStateLoading();

    selectedTheme = null;
    selectedSubtheme = null;

    final result = await _repository.getAllContents();

    result.fold(
      (failure) {
        contents = [];
        state = ContentStateError(failure.message);
      },
      (loadedContents) {
        contents = loadedContents;
        state = ContentStateSuccess();
      },
    );
  }

  @action
  Future<void> createContent({
    required SubthemeEnum subtheme,
    required ContentResponseModel content,
  }) async {
    state = ContentStateLoading();

    final result = await _repository.createContent(subtheme: subtheme, content: content);

    result.fold(
      (failure) {
        state = ContentStateError(failure.message);
      },
      (docId) {
        state = ContentStateSuccess();
        savedCount++;
        loadContentsBySubtheme(subtheme: subtheme);
      },
    );
  }

  @action
  Future<void> updateContent({
    required SubthemeEnum subtheme,
    required String contentId,
    required ContentResponseModel content,
  }) async {
    state = ContentStateLoading();

    final result = await _repository.updateContent(
      subtheme: subtheme,
      contentId: contentId,
      content: content,
    );

    result.fold(
      (failure) {
        state = ContentStateError(failure.message);
      },
      (_) {
        state = ContentStateSuccess();
        savedCount++;
        loadContentsBySubtheme(subtheme: subtheme);
      },
    );
  }

  @action
  Future<void> deleteContent({required SubthemeEnum subtheme, required String contentId}) async {
    subtheme = selectedSubtheme ?? subtheme;
    state = ContentStateLoading();

    final result = await _repository.deleteContent(subtheme: subtheme, contentId: contentId);

    result.fold(
      (failure) {
        state = ContentStateError(failure.message);
      },
      (_) {
        state = ContentStateSuccess();
        savedCount++;
        loadContentsBySubtheme(subtheme: subtheme);
      },
    );
  }

  @action
  void reset() {
    state = ContentStateInitial();
    contents = [];
    selectedTheme = null;
    selectedSubtheme = null;
  }
}
