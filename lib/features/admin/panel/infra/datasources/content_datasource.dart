import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/errors/content_failures.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/reference_code.dart';

/// Responsável pelas operações de dados no Firebase Firestore
class ContentDatasource {
  final FirebaseFirestore _firestore;

  ContentDatasource(this._firestore);

  /// Tentativas de código seguinte quando o calculado já está ocupado por outro cadastro.
  static const int _codeAttempts = 5;

  CollectionReference<Map<String, dynamic>> _contentsOf(SubthemeEnum subtheme) => _firestore
      .collection('themes')
      .doc(subtheme.theme.id)
      .collection('subthemes')
      .doc(subtheme.id)
      .collection('contents');

  /// Cria o objeto no subtema com o próximo código livre, que também é o id do documento.
  /// Devolve o código gravado.
  Future<String> createWithCode({
    required ContentResponseModel content,
    required SubthemeEnum subtheme,
  }) async {
    try {
      return await _writeWithFreeCode(content: content, subtheme: subtheme);
    } on ContentFailure {
      rethrow;
    } catch (e) {
      throw CreateFailure('Erro ao criar conteúdo: ${e.toString()}');
    }
  }

  /// Leva o objeto para outro subtema com um código novo: cria lá e apaga o documento antigo na
  /// mesma transação. Devolve o código gravado.
  Future<String> moveContent({
    required SubthemeEnum from,
    required String docId,
    required SubthemeEnum to,
    required ContentResponseModel content,
  }) async {
    try {
      return await _writeWithFreeCode(
        content: content,
        subtheme: to,
        remove: _contentsOf(from).doc(docId),
      );
    } on ContentFailure {
      rethrow;
    } catch (e) {
      throw UpdateFailure('Erro ao mover conteúdo: ${e.toString()}');
    }
  }

  // A transação só lê documentos, não consultas: os códigos do subtema são lidos antes, e dentro
  // dela só se confere se o documento do código ainda está livre.
  Future<String> _writeWithFreeCode({
    required ContentResponseModel content,
    required SubthemeEnum subtheme,
    DocumentReference<Map<String, dynamic>>? remove,
  }) async {
    final contents = _contentsOf(subtheme);
    final existing = await contents.get();
    final first = nextCode(
      existing.docs.map((doc) {
        final id = doc.data()['id'];
        return id is String ? id : doc.id;
      }),
      subtheme,
    );

    return _firestore.runTransaction((transaction) async {
      var code = first;
      for (var attempt = 0; attempt < _codeAttempts; attempt++) {
        final ref = contents.doc(code);
        final current = await transaction.get(ref);
        if (!current.exists) {
          transaction.set(ref, content.withCode(code).toJson());
          if (remove != null) transaction.delete(remove);
          return code;
        }
        code = following(code);
      }
      throw CreateFailure('Nenhum código livre a partir de $first');
    });
  }

  /// Busca todos os conteúdos de um subtema específico
  /// Aceita enums diretos: getContentsBySubtheme(subtheme: SubthemeEnum.censoDemografico)
  Future<List<ContentResponseModel>> getContentsBySubtheme({
    required SubthemeEnum subtheme,
    ThemeEnum? theme,
  }) async {
    try {
      final themeId = theme?.id ?? subtheme.theme.id;

      final snapshot = await _firestore
          .collection('themes')
          .doc(themeId)
          .collection('subthemes')
          .doc(subtheme.id)
          .collection('contents')
          .get();

      return snapshot.docs.map((doc) => ContentResponseModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw FetchFailure('Erro ao buscar conteúdos: ${e.toString()}');
    }
  }

  /// Busca um conteúdo específico
  /// Aceita enums diretos: getContent(subtheme: SubthemeEnum.censoDemografico, contentId: 'CP_CD_01')
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

      return ContentResponseModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw FetchFailure('Erro ao buscar conteúdo: ${e.toString()}');
    }
  }

  /// Atualiza um conteúdo existente
  /// Aceita enums diretos: updateContent(subtheme: SubthemeEnum.censoDemografico, contentId: 'CP_CD_01', content: ...)
  Future<void> updateContent({
    required SubthemeEnum subtheme,
    required String contentId,
    required ContentResponseModel content,
    ThemeEnum? theme,
  }) async {
    try {
      await _firestore
          .collection('themes')
          .doc(theme?.id ?? subtheme.theme.id)
          .collection('subthemes')
          .doc(subtheme.id)
          .collection('contents')
          .doc(contentId)
          .update(content.toJson());
    } catch (e) {
      throw UpdateFailure('Erro ao atualizar conteúdo: ${e.toString()}');
    }
  }

  /// Deleta um conteúdo
  /// Aceita enums diretos: deleteContent(subtheme: SubthemeEnum.censoDemografico, contentId: 'CP_CD_01')
  Future<void> deleteContent({
    required SubthemeEnum subtheme,
    required String contentId,
    ThemeEnum? theme,
  }) async {
    try {
      await _firestore
          .collection('themes')
          .doc(theme?.id ?? subtheme.theme.id)
          .collection('subthemes')
          .doc(subtheme.id)
          .collection('contents')
          .doc(contentId)
          .delete();
    } catch (e) {
      throw DeleteFailure('Erro ao deletar conteúdo: ${e.toString()}');
    }
  }

  /// Busca todos os conteúdos de um tema
  /// Aceita enums diretos: getContentsByTheme(theme: ThemeEnum.culturaPolitica)
  Future<List<ContentResponseModel>> getContentsByTheme({required ThemeEnum theme}) async {
    try {
      final subthemeDocs = await _firestore
          .collection('themes')
          .doc(theme.id)
          .collection('subthemes')
          .get();

      final allContents = <ContentResponseModel>[];

      for (final subthemeDoc in subthemeDocs.docs) {
        final contentDocs = await subthemeDoc.reference.collection('contents').get();

        for (final contentDoc in contentDocs.docs) {
          allContents.add(ContentResponseModel.fromJson(contentDoc.data(), contentDoc.id));
        }
      }

      return allContents;
    } catch (e) {
      throw FetchFailure('Erro ao buscar conteúdos do tema: ${e.toString()}');
    }
  }

  /// Busca todos os conteúdos de todos os temas
  Future<List<ContentResponseModel>> getAllContents() async {
    try {
      final themeDocs = await _firestore.collection('themes').get();
      final allContents = <ContentResponseModel>[];

      for (final themeDoc in themeDocs.docs) {
        final subthemeDocs = await themeDoc.reference.collection('subthemes').get();

        for (final subthemeDoc in subthemeDocs.docs) {
          final contentDocs = await subthemeDoc.reference.collection('contents').get();

          for (final contentDoc in contentDocs.docs) {
            allContents.add(ContentResponseModel.fromJson(contentDoc.data(), contentDoc.id));
          }
        }
      }

      return allContents;
    } catch (e) {
      throw FetchFailure('Erro ao buscar todos os conteúdos: ${e.toString()}');
    }
  }
}
