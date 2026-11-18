import 'package:dartz/dartz.dart';
import 'package:expogeo/core/content/representacoes_espaciais/coordenadas_geograficas/RE_CG_01.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/errors/content_failures.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/reference_code.dart';
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

  /// Códigos já ocupados no Firestore: a criação pula para o número seguinte, como a transação.
  final Set<String> takenCodes = {};

  /// Gravações recebidas, para conferir o documento montado.
  final List<ContentResponseModel> written = [];

  String _freeCode(ContentResponseModel content, SubthemeEnum subtheme) {
    var code = nextCode([
      for (final item in contents)
        if (item.subtheme == subtheme) item.id,
    ], subtheme);
    while (takenCodes.contains(code)) {
      code = following(code);
    }
    return code;
  }

  @override
  Future<Either<ContentFailure, String>> createWithCode({
    required SubthemeEnum subtheme,
    required ContentResponseModel content,
  }) async {
    calls.add('create:${subtheme.value}');
    if (failWrites) return Left(CreateFailure());
    final code = _freeCode(content, subtheme);
    written.add(content.withCode(code));
    return Right(code);
  }

  @override
  Future<Either<ContentFailure, String>> moveContent({
    required SubthemeEnum from,
    required String docId,
    required SubthemeEnum to,
    required ContentResponseModel content,
  }) async {
    calls.add('move:${from.value}:$docId:${to.value}');
    if (failWrites) return Left(UpdateFailure());
    final code = _freeCode(content, to);
    written.add(content.withCode(code));
    return Right(code);
  }

  @override
  Future<Either<ContentFailure, void>> updateContent({
    required SubthemeEnum subtheme,
    required String contentId,
    required ContentResponseModel content,
    ThemeEnum? theme,
  }) async {
    calls.add('update:${subtheme.value}:$contentId');
    if (failWrites) return Left(UpdateFailure());
    written.add(content);
    return const Right(null);
  }

  @override
  Future<Either<ContentFailure, void>> deleteContent({
    required SubthemeEnum subtheme,
    required String contentId,
    ThemeEnum? theme,
  }) async {
    calls.add('delete:${subtheme.value}:$contentId');
    if (failWrites) return Left(FetchFailure());
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
