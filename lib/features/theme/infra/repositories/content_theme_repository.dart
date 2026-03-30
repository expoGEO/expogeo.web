import 'package:dartz/dartz.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/theme/infra/datasources/content_theme_datasource.dart';
import 'package:expogeo/features/theme/infra/errors/content_theme_failures.dart';
import 'package:expogeo/features/theme/infra/models/pagination_model.dart';

/// Repository que abstrai as operações de leitura de conteúdos com paginação
class ContentThemeRepository {
  final ContentThemeDatasource _datasource;

  ContentThemeRepository(this._datasource);

  static const int defaultPageSize = 20;

  /// Busca conteúdos de um subtema com paginação
  /// Retorna Either com failure ou PaginationModel
  Future<Either<ContentThemeFailure, PaginationModel>> getContentsBySubthemeWithPagination({
    required SubthemeEnum subtheme,
    ThemeEnum? theme,
    int pageSize = defaultPageSize,
  }) async {
    try {
      final result = await _datasource.getContentsBySubthemeWithPagination(
        subtheme: subtheme,
        theme: theme,
        pageSize: pageSize,
      );
      return Right(result);
    } on ContentThemeFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  /// Busca a próxima página de conteúdos
  Future<Either<ContentThemeFailure, PaginationModel>> getNextPage({
    required SubthemeEnum subtheme,
    required PaginationModel currentPage,
    ThemeEnum? theme,
  }) async {
    try {
      final result = await _datasource.getNextPage(
        subtheme: subtheme,
        currentPage: currentPage,
        theme: theme,
      );
      return Right(result);
    } on ContentThemeFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  /// Busca a página anterior de conteúdos
  Future<Either<ContentThemeFailure, PaginationModel>> getPreviousPage({
    required SubthemeEnum subtheme,
    required PaginationModel currentPage,
    ThemeEnum? theme,
  }) async {
    try {
      final result = await _datasource.getPreviousPage(
        subtheme: subtheme,
        currentPage: currentPage,
        theme: theme,
      );
      return Right(result);
    } on ContentThemeFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }
}
