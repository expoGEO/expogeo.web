import 'package:dartz/dartz.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/theme/infra/errors/content_theme_failures.dart';
import 'package:expogeo/features/theme/infra/models/pagination_model.dart';
import 'package:expogeo/features/theme/infra/repositories/content_theme_repository.dart';
import 'package:expogeo/features/theme/presentation/stores/content_pagination_state.dart';
import 'package:mobx/mobx.dart';

part 'content_pagination_store.g.dart';

class ContentPaginationStore = ContentPaginationStoreBase with _$ContentPaginationStore;

abstract class ContentPaginationStoreBase with Store {
  final ContentThemeRepository _repository;

  ContentPaginationStoreBase(this._repository);

  @observable
  ContentPaginationState state = const ContentPaginationStateInitial();

  @observable
  SubthemeEnum? selectedSubtheme;

  @observable
  ThemeEnum? selectedTheme;

  @action
  Future<void> loadContentsBySubtheme({required SubthemeEnum subtheme, ThemeEnum? theme}) async {
    state = const ContentPaginationStateLoading();
    selectedSubtheme = subtheme;
    selectedTheme = theme;

    final result = await _repository.getContentsBySubthemeWithPagination(
      subtheme: subtheme,
      theme: theme,
    );

    result.fold(
      (failure) {
        state = ContentPaginationStateError(failure.message);
      },
      (paginationData) {
        state = ContentPaginationStateSuccess(paginationData);
      },
    );
  }

  @action
  Future<void> nextPage() async {
    if (!state.isSuccess) {
      return;
    }

    if (selectedSubtheme == null) {
      state = const ContentPaginationStateError('Nenhum subtema selecionado');
      return;
    }

    final currentSuccess = state as ContentPaginationStateSuccess;

    if (!currentSuccess.paginationData.hasNextPage) {
      state = ContentPaginationStateError(
        'Você está na última página (${currentSuccess.paginationData.displayPage})',
      );
      return;
    }

    state = ContentPaginationStateSuccess(currentSuccess.paginationData, isLoadingNextPage: true);

    final result = await _repository.getNextPage(
      subtheme: selectedSubtheme!,
      currentPage: currentSuccess.paginationData,
      theme: selectedTheme,
    );

    _applyPaginationResult(result);
  }

  @action
  Future<void> previousPage() async {
    if (!state.isSuccess) {
      return;
    }

    if (selectedSubtheme == null) {
      state = const ContentPaginationStateError('Nenhum subtema selecionado');
      return;
    }

    final currentSuccess = state as ContentPaginationStateSuccess;

    if (!currentSuccess.paginationData.hasPreviousPage) {
      state = ContentPaginationStateError(
        'Você está na primeira página (${currentSuccess.paginationData.displayPage})',
      );
      return;
    }

    state = ContentPaginationStateSuccess(
      currentSuccess.paginationData,
      isLoadingPreviousPage: true,
    );

    final result = await _repository.getPreviousPage(
      subtheme: selectedSubtheme!,
      currentPage: currentSuccess.paginationData,
      theme: selectedTheme,
    );

    _applyPaginationResult(result);
  }

  @action
  Future<void> refresh() async {
    if (state is! ContentPaginationStateSuccess) {
      return;
    }

    if (selectedSubtheme == null) {
      return;
    }

    final currentSuccess = state as ContentPaginationStateSuccess;
    final currentPage = currentSuccess.paginationData;

    state = const ContentPaginationStateLoading();

    final result = await _repository.getContentsBySubthemeWithPagination(
      subtheme: selectedSubtheme!,
      theme: selectedTheme,
      pageSize: currentPage.pageSize,
    );

    result.fold(
      (failure) {
        state = ContentPaginationStateError(failure.message);
      },
      (paginationData) {
        state = ContentPaginationStateSuccess(paginationData);
      },
    );
  }

  @action
  Future<void> resetToFirstPage() async {
    if (selectedSubtheme == null) {
      return;
    }

    await loadContentsBySubtheme(subtheme: selectedSubtheme!, theme: selectedTheme);
  }

  @action
  void reset() {
    state = const ContentPaginationStateInitial();
    selectedSubtheme = null;
    selectedTheme = null;
  }

  ContentPaginationStateSuccess? get successState {
    return state is ContentPaginationStateSuccess ? state as ContentPaginationStateSuccess : null;
  }

  bool get hasNextPage {
    final success = successState;
    return success != null && success.paginationData.hasNextPage;
  }

  bool get hasPreviousPage {
    final success = successState;
    return success != null && success.paginationData.hasPreviousPage;
  }

  int get currentPageNumber {
    final success = successState;
    return success?.paginationData.displayPage ?? 0;
  }

  int get totalPages {
    final success = successState;
    return success?.paginationData.totalPages ?? 0;
  }

  int get itemCount {
    final success = successState;
    return success?.paginationData.items.length ?? 0;
  }

  List get contents {
    final success = successState;
    return success?.paginationData.items ?? [];
  }

  // ======================== Métodos Auxiliares Privados ========================

  /// Aplica resultado de paginação ao estado
  /// Extrai duplicação do padrão fold(failure, success)
  void _applyPaginationResult(Either<ContentThemeFailure, PaginationModel> result) {
    result.fold(
      (failure) {
        state = ContentPaginationStateError(failure.message);
      },
      (paginationData) {
        state = ContentPaginationStateSuccess(paginationData);
      },
    );
  }
}
