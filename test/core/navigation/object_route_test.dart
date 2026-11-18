import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/pages/object_page.dart';
import 'package:expogeo/features/theme/pages/subtheme_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/catalog/catalog_test_data.dart';

void main() {
  late FakeCatalogRepository repository;

  setUp(() {
    repository = FakeCatalogRepository();
    GetIt.I.registerSingleton<CatalogStore>(CatalogStore(repository));
  });

  tearDown(() => GetIt.I.reset());

  // O roteador do app consulta o Firebase no redirecionamento; aqui entram só as rotas dele.
  GoRouter routerAt(String location) => GoRouter(
    initialLocation: location,
    routes: [
      for (final route in AppRouter.router.configuration.routes.whereType<GoRoute>())
        if (route.path.contains(':')) route,
    ],
  );

  Future<GoRouter> pump(WidgetTester tester, String location) async {
    tester.view.physicalSize = const Size(1280, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = routerAt(location);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    return router;
  }

  String pathOf(GoRouter router) => router.routeInformationProvider.value.uri.toString();

  for (final (theme, subtheme, code) in [
    (ThemeEnum.representacoesEspaciais, 'coordenadas-geograficas', 're-cg-01'),
    (ThemeEnum.naturezaMeioAmbiente, 'biomas', 'nma-bio-01'),
    (ThemeEnum.espacosUrbanosRurais, 'conflitos-terra', 'eur-ct-01'),
    (ThemeEnum.culturaPolitica, 'geopolitica', 'cp-gp-01'),
  ]) {
    testWidgets('abre objeto de ${theme.name}', (tester) async {
      final location = '${theme.route}/$subtheme/$code';
      final router = await pump(tester, location);

      expect(find.byType(ObjectPage), findsOneWidget);
      expect(pathOf(router), location);
    });
  }

  for (final code in ['NMA_BH_03', 'nma_BH-03', 'Nma-Bh-03']) {
    testWidgets('$code termina em nma-bh-03', (tester) async {
      final router = await pump(tester, '/natureza-meio-ambiente/bacias-hidrograficas/$code');

      expect(find.byType(ObjectPage), findsOneWidget);
      expect(tester.widget<ObjectPage>(find.byType(ObjectPage)).code, 'nma-bh-03');
      expect(pathOf(router), '/natureza-meio-ambiente/bacias-hidrograficas/nma-bh-03');
    });
  }

  testWidgets('o endereço com hífen não redireciona', (tester) async {
    const location = '/natureza-meio-ambiente/bacias-hidrograficas/nma-bh-03';
    final router = await pump(tester, location);

    expect(pathOf(router), location);
  });

  testWidgets('a consulta do endereço se mantém ao normalizar', (tester) async {
    final router = await pump(tester, '/natureza-meio-ambiente/biomas/NMA_BIO_01?de=home');

    expect(pathOf(router), '/natureza-meio-ambiente/biomas/nma-bio-01?de=home');
  });

  testWidgets('código com espaço codificado não quebra', (tester) async {
    final router = await pump(tester, '/natureza-meio-ambiente/biomas/nma%20bio%2001');

    expect(find.byType(ObjectPage), findsOneWidget);
    expect(pathOf(router), '/natureza-meio-ambiente/biomas/nma%20bio%2001');
    expect(tester.takeException(), isNull);
  });

  testWidgets('a rota não empilha a página do subtema', (tester) async {
    await pump(tester, '/natureza-meio-ambiente/biomas/nma-bio-01');

    expect(find.byType(SubthemePage, skipOffstage: false), findsNothing);
  });

  testWidgets('as rotas de subtema seguem abrindo', (tester) async {
    await pump(tester, '/natureza-meio-ambiente/biomas');

    expect(find.byType(SubthemePage), findsOneWidget);
    expect(find.byType(ObjectPage), findsNothing);
  });
}
