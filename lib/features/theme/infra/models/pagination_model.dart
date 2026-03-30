import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';

class PaginationModel {
  final List<ContentResponseModel> items;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final List<dynamic> _pageDocuments;
  final List<dynamic>? nextPageDocuments;

  /// Histórico de cursores para cada página visitada
  /// Ex: [cursor_page0, cursor_page1, cursor_page2]
  /// Usado para navegação para página anterior
  final List<List<dynamic>> pageHistory;

  PaginationModel({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    List<dynamic>? pageDocuments,
    this.nextPageDocuments,
    List<List<dynamic>>? pageHistory,
  }) : _pageDocuments = pageDocuments ?? [],
       pageHistory = pageHistory ?? [];

  /// Quantidade total de páginas
  int get totalPages => (totalCount / pageSize).ceil();

  /// Se há próxima página
  bool get hasNextPage => nextPageDocuments != null && nextPageDocuments!.isNotEmpty;

  /// Se há página anterior
  bool get hasPreviousPage => currentPage > 0;

  /// Índice para exibição (páginas começam em 1)
  int get displayPage => currentPage + 1;

  /// Cria uma cópia vazia (para estado inicial)
  factory PaginationModel.empty({int pageSize = 12}) {
    return PaginationModel(
      items: [],
      totalCount: 0,
      currentPage: 0,
      pageSize: pageSize,
      pageHistory: [],
    );
  }

  /// Copia com novos valores
  PaginationModel copyWith({
    List<ContentResponseModel>? items,
    int? totalCount,
    int? currentPage,
    int? pageSize,
    List<dynamic>? pageDocuments,
    List<dynamic>? nextPageDocuments,
    List<List<dynamic>>? pageHistory,
  }) {
    return PaginationModel(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      pageDocuments: pageDocuments ?? _pageDocuments,
      nextPageDocuments: nextPageDocuments ?? this.nextPageDocuments,
      pageHistory: pageHistory ?? this.pageHistory,
    );
  }
}
