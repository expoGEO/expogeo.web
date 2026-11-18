import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expogeo/features/admin/panel/infra/datasources/content_datasource.dart';
import 'package:expogeo/features/admin/panel/infra/repositories/content_repository.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_list_memory.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:get_it/get_it.dart';

class PanelSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    if (!getIt.isRegistered<FirebaseFirestore>()) {
      getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    }

    getIt.registerSingleton<ContentDatasource>(ContentDatasource(getIt<FirebaseFirestore>()));

    getIt.registerSingleton<ContentRepository>(ContentRepository(getIt<ContentDatasource>()));

    getIt.registerSingleton<ContentStore>(ContentStore(getIt<ContentRepository>()));

    getIt.registerSingleton<PanelListMemory>(PanelListMemory());
  }
}
