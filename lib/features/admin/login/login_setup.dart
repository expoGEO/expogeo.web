import 'package:expogeo/features/admin/login/infra/datasources/firebase_auth_datasource.dart';
import 'package:expogeo/features/admin/login/infra/repositories/auth_repository.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

/// Setup de dependency injection para a subfeature login
class LoginSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    getIt.registerSingleton<FirebaseAuthDatasource>(
      FirebaseAuthDatasourceImpl(FirebaseAuth.instance),
    );

    getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(getIt<FirebaseAuthDatasource>()));

    getIt.registerLazySingleton<AuthStore>(() => AuthStore(getIt<AuthRepository>()));
  }
}
