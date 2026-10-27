import 'package:expogeo/features/admin/login/login_setup.dart';
import 'package:expogeo/features/admin/panel/panel_setup.dart';
import 'package:get_it/get_it.dart';

/// Configuração central de injeção de dependências para o módulo de admin
/// Coordena as subfeatures: login e panel
class AdminSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    // Setup da subfeature de login
    LoginSetup.setup();

    // Setup da subfeature de panel
    PanelSetup.setup();
  }
}
