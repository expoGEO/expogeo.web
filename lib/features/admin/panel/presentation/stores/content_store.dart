import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/admin/panel/infra/repositories/content_repository.dart';
import 'package:mobx/mobx.dart';

part 'content_store.g.dart';

enum ContentOutcomeKind { created, updated, deleted, saveFailed, deleteFailed }

/// Resultado da última gravação ou exclusão. Cada operação cria um novo, para quem reage a ele
/// ver também dois resultados iguais seguidos.
class ContentOutcome {
  ContentOutcome(this.kind, {this.docId});

  final ContentOutcomeKind kind;

  /// O objeto excluído, quando [kind] é [ContentOutcomeKind.deleted] ou `deleteFailed`.
  final String? docId;
}

class ContentStore = ContentStoreBase with _$ContentStore;

/// Cria, edita e exclui objetos no subtema de cada um.
abstract class ContentStoreBase with Store {
  ContentStoreBase(this._repository);

  final ContentRepository _repository;

  @observable
  bool isBusy = false;

  @observable
  ContentOutcome? outcome;

  /// Sobe a cada criação, edição ou exclusão bem-sucedida, para quem depende das contagens.
  @observable
  int savedCount = 0;

  @action
  Future<void> createContent({
    required SubthemeEnum subtheme,
    required ContentResponseModel content,
  }) async {
    isBusy = true;
    final result = await _repository.createContent(subtheme: subtheme, content: content);
    _finish(
      result.isRight()
          ? ContentOutcome(ContentOutcomeKind.created)
          : ContentOutcome(ContentOutcomeKind.saveFailed),
    );
  }

  @action
  Future<void> updateContent({
    required SubthemeEnum subtheme,
    required String contentId,
    required ContentResponseModel content,
  }) async {
    isBusy = true;
    final result = await _repository.updateContent(
      subtheme: subtheme,
      contentId: contentId,
      content: content,
    );
    _finish(
      result.isRight()
          ? ContentOutcome(ContentOutcomeKind.updated, docId: contentId)
          : ContentOutcome(ContentOutcomeKind.saveFailed, docId: contentId),
    );
  }

  @action
  Future<void> deleteContent({required SubthemeEnum subtheme, required String contentId}) async {
    isBusy = true;
    final result = await _repository.deleteContent(subtheme: subtheme, contentId: contentId);
    _finish(
      result.isRight()
          ? ContentOutcome(ContentOutcomeKind.deleted, docId: contentId)
          : ContentOutcome(ContentOutcomeKind.deleteFailed, docId: contentId),
    );
  }

  @action
  void _finish(ContentOutcome result) {
    isBusy = false;
    if (result.kind
        case ContentOutcomeKind.created ||
            ContentOutcomeKind.updated ||
            ContentOutcomeKind.deleted) {
      savedCount++;
    }
    outcome = result;
  }
}
