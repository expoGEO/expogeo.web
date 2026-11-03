import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expogeo/features/catalog/infra/datasources/catalog_datasource.dart';
import 'package:expogeo/features/catalog/infra/repositories/catalog_repository.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:get_it/get_it.dart';

class CatalogSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    if (!getIt.isRegistered<FirebaseFirestore>()) {
      getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    }

    getIt.registerSingleton<CatalogDatasource>(CatalogDatasource(getIt<FirebaseFirestore>()));
    getIt.registerSingleton<CatalogRepository>(CatalogRepository(getIt<CatalogDatasource>()));
    getIt.registerSingleton<CatalogStore>(CatalogStore(getIt<CatalogRepository>()));
  }
}
