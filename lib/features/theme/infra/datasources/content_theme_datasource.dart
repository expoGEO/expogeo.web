import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/theme/infra/errors/content_theme_failures.dart';
import 'package:expogeo/features/theme/infra/models/pagination_model.dart';

/// Responsável pelas operações de dados no Firebase Firestore para tema
/// Foco em buscas e recuperação de conteúdos com suporte a paginação
class ContentThemeDatasource {
  final FirebaseFirestore _firestore;

  ContentThemeDatasource(this._firestore);

  static const int defaultPageSize = 20;

  /// Busca conteúdos de um subtema com suporte a paginação
  /// Retorna um PaginationModel com os dados da página solicitada
  Future<PaginationModel> getContentsBySubthemeWithPagination({
    required SubthemeEnum subtheme,
    ThemeEnum? theme,
    int pageSize = defaultPageSize,
  }) async {
    try {
      final themeId = theme?.id ?? subtheme.theme.id;

      // Busca primeira página com histórico vazio
      final snapshot = await _buildQuery(
        themeId: themeId,
        subtheme: subtheme,
        queryLimit: pageSize + 1,
      ).get();

      if (snapshot.docs.isEmpty) {
        return PaginationModel.empty(pageSize: pageSize);
      }

      final (items, nextPageDocs) = _processSnapshot(snapshot, pageSize);

      // Buscar contagem total (pode ser custoso em coleções grandes)
      final totalCount = await _fetchTotalCount(themeId, subtheme);

      // Inicializa histórico com primeira página
      final pageHistory = [items.map((item) => item.docId).toList()];

      return PaginationModel(
        items: items,
        totalCount: totalCount,
        currentPage: 0,
        pageSize: pageSize,
        pageDocuments: items.map((item) => item.docId).toList(),
        nextPageDocuments: nextPageDocs,
        pageHistory: pageHistory,
      );
    } catch (e) {
      throw FetchFailure('Erro ao buscar conteúdos paginados: ${e.toString()}');
    }
  }

  /// Busca a próxima página de conteúdos
  Future<PaginationModel> getNextPage({
    required SubthemeEnum subtheme,
    required PaginationModel currentPage,
    ThemeEnum? theme,
  }) async {
    try {
      if (!currentPage.hasNextPage) {
        throw FetchFailure('Não há próxima página');
      }

      final themeId = theme?.id ?? subtheme.theme.id;
      final nextPageDocs = currentPage.nextPageDocuments ?? [];

      if (nextPageDocs.isEmpty) {
        return currentPage;
      }

      final lastDocId = nextPageDocs.first as String;

      // Validar que o documento existe
      final lastDocSnapshot = await _firestore
          .collection('themes')
          .doc(themeId)
          .collection('subthemes')
          .doc(subtheme.id)
          .collection('contents')
          .doc(lastDocId)
          .get();

      if (!lastDocSnapshot.exists) {
        throw FetchFailure('Documento de referência para próxima página não encontrado');
      }

      // Buscar próxima página
      final snapshot = await _buildQuery(
        themeId: themeId,
        subtheme: subtheme,
        queryLimit: currentPage.pageSize + 1,
        startAfter: [lastDocId],
      ).get();

      if (snapshot.docs.isEmpty) {
        return currentPage.copyWith(items: [], nextPageDocuments: []);
      }

      final (items, nextPageDocuments) = _processSnapshot(snapshot, currentPage.pageSize);

      // Atualiza histórico com a nova página
      var newHistory = [...currentPage.pageHistory];
      newHistory.add(items.map((item) => item.docId).toList());

      return currentPage.copyWith(
        items: items,
        currentPage: currentPage.currentPage + 1,
        pageDocuments: items.map((item) => item.docId).toList(),
        nextPageDocuments: nextPageDocuments,
        pageHistory: newHistory,
      );
    } catch (e) {
      throw FetchFailure('Erro ao buscar próxima página: ${e.toString()}');
    }
  }

  /// Busca a página anterior de conteúdos
  Future<PaginationModel> getPreviousPage({
    required SubthemeEnum subtheme,
    required PaginationModel currentPage,
    ThemeEnum? theme,
  }) async {
    try {
      if (!currentPage.hasPreviousPage) {
        throw FetchFailure('Você está na primeira página');
      }

      final previousPageIndex = currentPage.currentPage - 1;

      if (previousPageIndex < 0 || previousPageIndex >= currentPage.pageHistory.length) {
        throw FetchFailure('Histórico de páginas indisponível');
      }

      final previousPageCursor = currentPage.pageHistory[previousPageIndex];

      if (previousPageCursor.isEmpty) {
        throw FetchFailure('Cursor da página anterior inválido');
      }

      // Se for a primeira página, não precisa de startAfter
      final snapshot = previousPageIndex == 0
          ? await _buildQuery(
              themeId: theme?.id ?? subtheme.theme.id,
              subtheme: subtheme,
              queryLimit: currentPage.pageSize + 1,
            ).get()
          : await _buildQuery(
              themeId: theme?.id ?? subtheme.theme.id,
              subtheme: subtheme,
              queryLimit: currentPage.pageSize + 1,
              startAfter: [previousPageCursor.last as String],
            ).get();

      if (snapshot.docs.isEmpty) {
        throw FetchFailure('Nenhum documento encontrado na página anterior');
      }

      final (items, nextPageDocs) = _processSnapshot(snapshot, currentPage.pageSize);

      // Remove páginas do histórico após esta (pois voltou para trás)
      var newHistory = currentPage.pageHistory.sublist(0, previousPageIndex + 1);

      return currentPage.copyWith(
        items: items,
        currentPage: previousPageIndex,
        pageDocuments: items.map((item) => item.docId).toList(),
        nextPageDocuments: nextPageDocs,
        pageHistory: newHistory,
      );
    } catch (e) {
      throw FetchFailure('Erro ao buscar página anterior: ${e.toString()}');
    }
  }

  /// Busca um conteúdo específico
  Future<ContentResponseModel> getContent({
    required SubthemeEnum subtheme,
    required String contentId,
    ThemeEnum? theme,
  }) async {
    try {
      final doc = await _firestore
          .collection('themes')
          .doc(theme?.id ?? subtheme.theme.id)
          .collection('subthemes')
          .doc(subtheme.id)
          .collection('contents')
          .doc(contentId)
          .get();

      if (!doc.exists) {
        throw FetchFailure('Conteúdo não encontrado');
      }

      return ContentResponseModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw FetchFailure('Erro ao buscar conteúdo: ${e.toString()}');
    }
  }

  // ======================== Métodos Auxiliares Privados ========================

  /// Constrói uma query base para conteúdos ordenados por documentId
  Query _buildQuery({
    required String themeId,
    required SubthemeEnum subtheme,
    required int queryLimit,
    List<dynamic>? startAfter,
  }) {
    var query =
        _firestore
                .collection('themes')
                .doc(themeId)
                .collection('subthemes')
                .doc(subtheme.id)
                .collection('contents')
                .orderBy(FieldPath.documentId)
                .limit(queryLimit)
            as Query;

    if (startAfter != null && startAfter.isNotEmpty) {
      query = query.startAfter(startAfter);
    }

    return query;
  }

  /// Processa um snapshot em items e detecta próxima página
  /// Retorna (items, nextPageDocuments)
  (List<ContentResponseModel>, List<dynamic>?) _processSnapshot(
    QuerySnapshot snapshot,
    int pageSize,
  ) {
    final hasNextPage = snapshot.docs.length > pageSize;
    final itemsToReturn = hasNextPage ? snapshot.docs.take(pageSize).toList() : snapshot.docs;

    final items = itemsToReturn
        .map((doc) => ContentResponseModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    List<dynamic>? nextPageDocuments;
    if (hasNextPage && itemsToReturn.isNotEmpty) {
      final lastDoc = itemsToReturn.last;
      nextPageDocuments = [lastDoc.id];
    }

    return (items, nextPageDocuments);
  }

  /// Busca a contagem total de documentos em uma coleção
  Future<int> _fetchTotalCount(String themeId, SubthemeEnum subtheme) async {
    try {
      final countSnapshot = await _firestore
          .collection('themes')
          .doc(themeId)
          .collection('subthemes')
          .doc(subtheme.id)
          .collection('contents')
          .count()
          .get();

      return countSnapshot.count ?? 0;
    } catch (_) {
      // Se count falhar, retorna 0 (não é crítico)
      return 0;
    }
  }
}
