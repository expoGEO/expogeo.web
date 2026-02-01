import 'package:flutter/material.dart';

import 'core/navigation/app_router.dart';

void main() {
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
