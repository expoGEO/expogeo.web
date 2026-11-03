import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';

class CatalogDatasource {
  CatalogDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  /// Sem rede, o SDK pode esperar indefinidamente; depois disso a consulta vira erro.
  static const Duration timeout = Duration(seconds: 15);

  Future<List<CatalogRecord>> fetchAll() async {
    final snapshot = await _firestore.collectionGroup('contents').get().timeout(timeout);
    return [
      for (final doc in snapshot.docs)
        CatalogRecord(path: doc.reference.path, id: doc.id, data: doc.data()),
    ];
  }
}
