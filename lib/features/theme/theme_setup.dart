import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expogeo/features/theme/infra/datasources/content_theme_datasource.dart';
import 'package:expogeo/features/theme/infra/repositories/content_theme_repository.dart';
import 'package:expogeo/features/theme/presentation/stores/content_pagination_store.dart';
import 'package:get_it/get_it.dart';

/// Setup de dependency injection para a feature theme
class ThemeSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Registra o Firestore (singleton compartilhado)
    if (!getIt.isRegistered<FirebaseFirestore>()) {
      getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    }

    // Registra o datasource de conteúdo com paginação
    getIt.registerSingleton<ContentThemeDatasource>(
      ContentThemeDatasource(getIt<FirebaseFirestore>()),
    );

    // Registra o repository de conteúdo
    getIt.registerSingleton<ContentThemeRepository>(
      ContentThemeRepository(getIt<ContentThemeDatasource>()),
    );

    // Registra o store de paginação
    getIt.registerSingleton<ContentPaginationStore>(
      ContentPaginationStore(getIt<ContentThemeRepository>()),
    );
  }
}
