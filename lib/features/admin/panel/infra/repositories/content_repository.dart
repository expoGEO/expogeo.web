import 'package:dartz/dartz.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/datasources/content_datasource.dart';
import 'package:expogeo/features/admin/panel/infra/errors/content_failures.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';

/// Repository que abstrai as operações CRUD de conteúdo
class ContentRepository {
  final ContentDatasource _datasource;

  ContentRepository(this._datasource);

  /// Cria o objeto com o próximo código livre do subtema; devolve o código gravado.
  Future<Either<ContentFailure, String>> createWithCode({
    required SubthemeEnum subtheme,
    required ContentResponseModel content,
  }) async {
    try {
      return Right(await _datasource.createWithCode(content: content, subtheme: subtheme));
    } on ContentFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  /// Leva o objeto para [to] com um código novo; devolve o código gravado.
  Future<Either<ContentFailure, String>> moveContent({
    required SubthemeEnum from,
    required String docId,
    required SubthemeEnum to,
    required ContentResponseModel content,
  }) async {
    try {
      return Right(
        await _datasource.moveContent(from: from, docId: docId, to: to, content: content),
      );
    } on ContentFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  /// Busca todos os conteúdos de um subtema com enum
  Future<Either<ContentFailure, List<ContentResponseModel>>> getContentsBySubtheme({
    required SubthemeEnum subtheme,
    ThemeEnum? theme,
  }) async {
    try {
      final contents = await _datasource.getContentsBySubtheme(subtheme: subtheme, theme: theme);
      return Right(contents);
    } on ContentFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  /// Busca um conteúdo específico com enum
  Future<Either<ContentFailure, ContentResponseModel>> getContent({
    required SubthemeEnum subtheme,
    required String contentId,
    ThemeEnum? theme,
  }) async {
    try {
      final content = await _datasource.getContent(
        subtheme: subtheme,
        contentId: contentId,
        theme: theme,
      );
      return Right(content);
    } on ContentFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  /// Atualiza um conteúdo com enum
  Future<Either<ContentFailure, void>> updateContent({
    required SubthemeEnum subtheme,
    required String contentId,
    required ContentResponseModel content,
    ThemeEnum? theme,
  }) async {
    try {
      await _datasource.updateContent(
        subtheme: subtheme,
        contentId: contentId,
        content: content,
        theme: theme,
      );
      return const Right(null);
    } on ContentFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  /// Deleta um conteúdo com enum
  Future<Either<ContentFailure, void>> deleteContent({
    required SubthemeEnum subtheme,
    required String contentId,
    ThemeEnum? theme,
  }) async {
    try {
      await _datasource.deleteContent(subtheme: subtheme, contentId: contentId, theme: theme);
      return const Right(null);
    } on ContentFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  /// Busca todos os conteúdos de um tema com enum
  Future<Either<ContentFailure, List<ContentResponseModel>>> getContentsByTheme({
    required ThemeEnum theme,
  }) async {
    try {
      final contents = await _datasource.getContentsByTheme(theme: theme);
      return Right(contents);
    } on ContentFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  /// Busca todos os conteúdos
  Future<Either<ContentFailure, List<ContentResponseModel>>> getAllContents() async {
    try {
      final contents = await _datasource.getAllContents();
      return Right(contents);
    } on ContentFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GenericFailure('Erro inesperado: ${e.toString()}'));
    }
  }
}
