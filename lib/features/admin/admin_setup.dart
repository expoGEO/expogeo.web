import 'package:expogeo/features/admin/login/login_setup.dart';
import 'package:expogeo/features/admin/panel/panel_setup.dart';
import 'package:get_it/get_it.dart';

class AdminSetup {
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    LoginSetup.setup();

    PanelSetup.setup();
  }
}
