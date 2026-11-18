import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';

/// Sem rede, o Firestore responde com o cache local, que pode estar vazio.
class CatalogOfflineException implements Exception {
  const CatalogOfflineException();
}

class CatalogDatasource {
  CatalogDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  /// Sem rede, o SDK pode esperar indefinidamente; depois disso a consulta vira erro.
  static const Duration timeout = Duration(seconds: 15);

  /// Acervo vazio vindo do cache quer dizer que não houve consulta ao servidor, não que não há
  /// objetos; tratá-lo como vazio esconderia a falha de conexão.
  static void checkSnapshot({required bool isEmpty, required bool isFromCache}) {
    if (isEmpty && isFromCache) throw const CatalogOfflineException();
  }

  Future<List<CatalogRecord>> fetchAll() async {
    final snapshot = await _firestore.collectionGroup('contents').get().timeout(timeout);
    checkSnapshot(isEmpty: snapshot.docs.isEmpty, isFromCache: snapshot.metadata.isFromCache);
    return [
      for (final doc in snapshot.docs)
        CatalogRecord(path: doc.reference.path, id: doc.id, data: doc.data()),
    ];
  }
}
