import 'package:expogeo/features/theme/infra/models/pagination_model.dart';

/// Estado selado para gerenciamento de paginação de conteúdos
sealed class ContentPaginationState {
  const ContentPaginationState();

  bool get isInitial => this is ContentPaginationStateInitial;
  bool get isLoading => this is ContentPaginationStateLoading;
  bool get isSuccess => this is ContentPaginationStateSuccess;
  bool get isError => this is ContentPaginationStateError;

  bool get isNextPageLoading =>
      this is ContentPaginationStateSuccess &&
      (this as ContentPaginationStateSuccess).isLoadingNextPage;

  bool get isPreviousPageLoading =>
      this is ContentPaginationStateSuccess &&
      (this as ContentPaginationStateSuccess).isLoadingPreviousPage;
}

class ContentPaginationStateInitial extends ContentPaginationState {
  const ContentPaginationStateInitial();
}

class ContentPaginationStateLoading extends ContentPaginationState {
  const ContentPaginationStateLoading();
}

class ContentPaginationStateSuccess extends ContentPaginationState {
  final PaginationModel paginationData;
  final bool isLoadingNextPage;
  final bool isLoadingPreviousPage;

  const ContentPaginationStateSuccess(
    this.paginationData, {
    this.isLoadingNextPage = false,
    this.isLoadingPreviousPage = false,
  });
}

class ContentPaginationStateError extends ContentPaginationState {
  final String message;
  const ContentPaginationStateError(this.message);
}
