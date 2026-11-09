import 'package:dartz/dartz.dart';
import 'package:expogeo/core/content/representacoes_espaciais/coordenadas_geograficas/RE_CG_01.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/errors/content_failures.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/admin/panel/infra/repositories/content_repository.dart';

ContentResponseModel sampleContent([String docId = 'doc_1']) =>
    ContentResponseModel.fromContentModel(content: RE_CG_01, docId: docId);

/// Repositório de conteúdo em memória, sem Firestore; [failWrites] faz as gravações falharem.
class FakeContentRepository implements ContentRepository {
  FakeContentRepository({List<ContentResponseModel>? contents})
    : contents = contents ?? [sampleContent()];

  final List<ContentResponseModel> contents;
  bool failWrites = false;
  final List<String> calls = [];

  @override
  Future<Either<ContentFailure, List<ContentResponseModel>>> getContentsBySubtheme({
    required SubthemeEnum subtheme,
    ThemeEnum? theme,
  }) async {
    calls.add('subtheme:${subtheme.value}');
    return Right(contents);
  }

  @override
  Future<Either<ContentFailure, List<ContentResponseModel>>> getContentsByTheme({
    required ThemeEnum theme,
  }) async {
    calls.add('theme:${theme.value}');
    return Right(contents);
  }

  @override
  Future<Either<ContentFailure, List<ContentResponseModel>>> getAllContents() async {
    calls.add('all');
    return Right(contents);
  }

  @override
  Future<Either<ContentFailure, String>> createContent({
    required SubthemeEnum subtheme,
    required ContentResponseModel content,
    ThemeEnum? theme,
  }) async {
    calls.add('create');
    if (failWrites) return Left(CreateFailure());
    return const Right('novo');
  }

  @override
  Future<Either<ContentFailure, void>> updateContent({
    required SubthemeEnum subtheme,
    required String contentId,
    required ContentResponseModel content,
    ThemeEnum? theme,
  }) async {
    calls.add('update');
    if (failWrites) return Left(UpdateFailure());
    return const Right(null);
  }

  @override
  Future<Either<ContentFailure, void>> deleteContent({
    required SubthemeEnum subtheme,
    required String contentId,
    ThemeEnum? theme,
  }) async {
    calls.add('delete');
    if (failWrites) return Left(FetchFailure());
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
