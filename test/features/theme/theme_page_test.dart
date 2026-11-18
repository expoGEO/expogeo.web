import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/subtheme_overview_card.dart';
import 'package:expogeo/features/theme/pages/theme_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/semantics.dart';
import '../catalog/catalog_test_data.dart';

void main() {
  late FakeCatalogRepository repository;
  late CatalogStore store;

  setUp(() {
    repository = FakeCatalogRepository();
    store = CatalogStore(repository);
  });

  final themes = ThemeDataModel.themes;

  GoRouter routerAt(String location) => GoRouter(
    initialLocation: location,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Text('página inicial')),
      for (final theme in themes)
        GoRoute(
          path: theme.type.route,
          builder: (context, state) =>
              ThemePage(themeId: theme.type.value, themeTitle: theme.title, store: store),
        ),
    ],
  );

  Future<void> pump(WidgetTester tester, GoRouter router, {double width = 1280}) async {
    tester.view.physicalSize = Size(width, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
  }

  for (final theme in themes) {
    testWidgets('abre direto: ${theme.title}', (tester) async {
      await pump(tester, routerAt(theme.type.route));

      expect(find.bySemanticsLabel('${theme.title}, página atual'), findsOneWidget);
      expect(find.text(theme.description.trim()), findsOneWidget);
      expect(find.text('Temas'), findsWidgets);
      expect(find.text('Início'), findsOneWidget);
      expect(tester.widget<AppMedallion>(find.byType(AppMedallion).first).size, anyOf(180.0, 30.0));
    });
  }

  testWidgets('medalhão do cabeçalho muda por faixa', (tester) async {
    await pump(tester, routerAt(themes[0].type.route));
    expect(find.byWidgetPredicate((w) => w is AppMedallion && w.size == 180), findsOneWidget);

    await pump(tester, routerAt(themes[0].type.route), width: 768);
    expect(find.byWidgetPredicate((w) => w is AppMedallion && w.size == 96), findsOneWidget);
  });

  testWidgets('entrar direto dispara uma única carga', (tester) async {
    await pump(tester, routerAt(themes[1].type.route));

    expect(repository.calls, 1);
    repository.succeed();
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('74 objetos digitais'), findsOneWidget);
    expect(repository.calls, 1);
  });

  testWidgets('"Início" vai à Home e "Temas" não é link', (tester) async {
    await pump(tester, routerAt(themes[0].type.route));

    expect(find.bySemanticsLabel('Início'), findsWidgets);
    final temas = find.descendant(
      of: find.bySemanticsLabel('Você está em'),
      matching: find.text('Temas'),
    );
    expect(tester.getSemantics(temas).getSemanticsData().flagsCollection.isLink, isFalse);

    await tester.tap(
      find.descendant(of: find.bySemanticsLabel('Você está em'), matching: find.text('Início')),
    );
    await tester.pumpAndSettle();
    expect(find.text('página inicial'), findsOneWidget);
  });

  testWidgets('hierarquia de títulos', (tester) async {
    await pump(tester, routerAt(themes[1].type.route));

    final levels = <String, int>{
      for (final widget in tester.widgetList<Semantics>(find.byType(Semantics)))
        if (widget.properties.headingLevel case final level? when level > 0)
          widget.properties.label ?? (widget.child is Text ? (widget.child! as Text).data! : '?'):
              level,
    };
    expect(levels.entries.where((e) => e.value == 1).map((e) => e.key), [themes[1].title]);
    expect(levels['12 subtemas'], 2);
    expect(levels['Outros temas'], 2);
    for (final subtheme in themes[1].subthemes) {
      expect(levels[subtheme.type.name], 3);
    }
    expectHeading(tester, find.text(themes[1].subthemes.first.type.name), 3);
  });

  testWidgets('migalhas com nome "Você está em"', (tester) async {
    await pump(tester, routerAt(themes[0].type.route));

    expect(find.bySemanticsLabel('Você está em'), findsOneWidget);
  });

  testWidgets('erro no catálogo mantém nomes e links', (tester) async {
    await pump(tester, routerAt(themes[1].type.route));
    repository.fail();
    await tester.pumpAndSettle();

    expect(find.byType(SubthemeOverviewCard), findsNWidgets(12));
    expect(find.text(themes[1].subthemes.first.type.name), findsOneWidget);
    expect(find.bySemanticsLabel('12 subtemas'), findsWidgets);
    expect(find.textContaining('objetos', findRichText: true), findsNothing);
    expect(find.bySemanticsLabel(themes[0].title), findsWidgets);
  });

  testWidgets('depois de um erro, trocar de tema tenta de novo', (tester) async {
    final router = routerAt(themes[1].type.route);
    await pump(tester, router);
    repository.fail();
    await tester.pumpAndSettle();
    expect(repository.calls, 1);

    router.go(themes[2].type.route);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(tester.takeException(), isNull);
    expect(repository.calls, 2);
    repository.succeed();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.bySemanticsLabel('42 objetos digitais'), findsOneWidget);
  });

  testWidgets('endereço fora das rotas mostra a página de não encontrada', (tester) async {
    await pump(tester, routerAt('/qualquer-coisa'));

    expect(find.byType(NotFoundPage), findsOneWidget);
    expect(find.byType(ThemePage), findsNothing);
  });
}
