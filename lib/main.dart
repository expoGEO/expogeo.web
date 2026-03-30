import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'core/navigation/app_router.dart';
import 'features/admin/admin_setup.dart';
import 'features/theme/theme_setup.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configurar injeção de dependências do admin
  AdminSetup.setup();

  // Configurar injeção de dependências da feature theme
  ThemeSetup.setup();

  usePathUrlStrategy();

  runApp(const ExpoGeoApp());
}

class ExpoGeoApp extends StatelessWidget {
  const ExpoGeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'expoGEO: Exposição Geográfica',
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
