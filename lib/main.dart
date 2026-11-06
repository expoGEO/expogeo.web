import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'core/components/environment/environment_banner.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/environment/app_environment.dart';
import 'features/admin/admin_setup.dart';
import 'features/catalog/catalog_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: AppEnvironment.current.firebaseOptions);

  // Configurar injeção de dependências do admin
  AdminSetup.setup();

  CatalogSetup.setup();

  usePathUrlStrategy();

  runApp(const ExpoGeoApp());
}

class ExpoGeoApp extends StatelessWidget {
  const ExpoGeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'expoGEO · Curadoria digital do saber geográfico',
      theme: ThemeData.light().copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppTheme.colors.textSelection,
          selectionHandleColor: AppTheme.colors.accent,
        ),
      ),
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final bannerHeight = AppEnvironment.current.isProd
            ? 0.0
            : AppTheme.dimensions.environmentBannerHeight;
        final mediaQuery = MediaQuery.of(context);

        // As páginas medem a tela pelo MediaQuery; descontar a faixa evita que passem do fundo.
        return MediaQuery(
          data: mediaQuery.copyWith(
            size: Size(mediaQuery.size.width, mediaQuery.size.height - bannerHeight),
          ),
          child: Column(
            children: [
              const EnvironmentBanner(),
              Expanded(child: child ?? const SizedBox.shrink()),
            ],
          ),
        );
      },
    );
  }
}
