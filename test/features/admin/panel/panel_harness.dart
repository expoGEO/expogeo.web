import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:expogeo/features/admin/login/presentation/stores/auth_store.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../support/fake_auth.dart';
import '../../../support/fake_content.dart';
import '../../catalog/catalog_test_data.dart';

const panelEmail = 'ana.souza@exemplo.org';

/// Painel com sessão, conteúdo e catálogo falsos, montado pelas rotas de verdade.
class PanelHarness {
  PanelHarness() {
    auth.current = FakeUser(email: panelEmail);
    authStore = AuthStore(auth);
    contentStore = ContentStore(content);
    catalogStore = CatalogStore(catalog);
    GetIt.I
      ..registerSingleton<AuthStore>(authStore)
      ..registerSingleton<ContentStore>(contentStore)
      ..registerSingleton<CatalogStore>(catalogStore);
    addTearDown(GetIt.I.reset);
  }

  final auth = FakeAuthRepository();
  final content = FakeContentRepository();
  final catalog = FakeCatalogRepository();
  late final AuthStore authStore;
  late final ContentStore contentStore;
  late final CatalogStore catalogStore;
  late final GoRouter router;

  String get location => router.routerDelegate.currentConfiguration.uri.toString();

  Future<void> pump(
    WidgetTester tester,
    String location, {
    Size size = const Size(1280, 900),
    bool logged = true,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    router = GoRouter(
      initialLocation: location,
      errorBuilder: (context, state) => const NotFoundPage(),
      routes: AppRouter.router.configuration.routes,
      redirect: (context, state) =>
          AppRouter.adminRedirect(state.uri.path, () async => logged ? auth.current : null),
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    await tester.pump();
  }

  /// Responde à carga do catálogo que a casca pediu ao abrir.
  Future<void> loadCatalog(WidgetTester tester) async {
    catalog.succeed();
    await tester.pump();
    await tester.pump();
  }
}
