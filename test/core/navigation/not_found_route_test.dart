import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/catalog/catalog_test_data.dart';

void main() {
  setUp(() => GetIt.I.registerSingleton<CatalogStore>(CatalogStore(FakeCatalogRepository())));

  tearDown(() => GetIt.I.reset());

  // O roteador do app consulta o Firebase no redirecionamento; aqui entram as rotas e a página de
  // erro dele, sem as do painel.
  GoRouter routerAt(String location) => GoRouter(
    initialLocation: location,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      for (final route in AppRouter.router.configuration.routes.whereType<GoRoute>())
        if (route.path != AppRouter.admin && route.path != AppRouter.home) route,
    ],
  );

  for (final location in [
    '/nao-existe',
    '/natureza-meio-ambiente/nao-existe',
    '/cultura-politica/biomas',
    '/a/b/c/d',
  ]) {
    testWidgets('$location abre a página não encontrada', (tester) async {
      tester.view.physicalSize = const Size(1280, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp.router(routerConfig: routerAt(location)));
      await tester.pump();

      expect(find.byType(NotFoundPage), findsOneWidget);
      expect(find.text('Este lugar não está no mapa'), findsOneWidget);
    });
  }
}
