import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expogeo/features/admin/panel/infra/datasources/content_datasource.dart';
import 'package:expogeo/features/admin/panel/infra/repositories/content_repository.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:get_it/get_it.dart';

/// Setup de dependency injection para a subfeature panel
class PanelSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Registra o Firestore (singleton)
    if (!getIt.isRegistered<FirebaseFirestore>()) {
      getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    }

    // Registra o datasource de conteúdo
    getIt.registerSingleton<ContentDatasource>(ContentDatasource(getIt<FirebaseFirestore>()));

    // Registra o repository de conteúdo
    getIt.registerSingleton<ContentRepository>(ContentRepository(getIt<ContentDatasource>()));

    // Registra o store de conteúdo
    getIt.registerSingleton<ContentStore>(ContentStore(getIt<ContentRepository>()));
  }
}
