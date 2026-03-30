import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/errors/content_failures.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';

/// Responsável pelas operações de dados no Firebase Firestore
class ContentDatasource {
  final FirebaseFirestore _firestore;

  ContentDatasource(this._firestore);

  /// Cria um novo conteúdo na hierarquia de coleções
  /// Estrutura: themes/{themeId}/subthemes/{subthemeId}/contents/{contentId}
  Future<String> createContent({
    required ContentResponseModel content,
    required SubthemeEnum subtheme,
    ThemeEnum? theme,
  }) async {
    try {
      final docRef = await _firestore
          .collection('themes')
          .doc(theme?.id ?? subtheme.theme.id)
          .collection('subthemes')
          .doc(subtheme.id)
          .collection('contents')
          .add(content.toJson());

      return docRef.id;
    } catch (e) {
      throw CreateFailure('Erro ao criar conteúdo: ${e.toString()}');
    }
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
