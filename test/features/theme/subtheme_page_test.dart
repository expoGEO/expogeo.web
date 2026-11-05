import 'package:expogeo/core/components/chip/filter_chip_button.dart';
import 'package:expogeo/core/components/image/app_medallion.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/object_row.dart';
import 'package:expogeo/features/theme/pages/subtheme_page.dart';
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
      for (final theme in themes) ...[
        GoRoute(path: theme.type.route, builder: (context, state) => Text('tema ${theme.title}')),
        GoRoute(
          path: '${theme.type.route}/:subthemeId',
          builder: (context, state) => SubthemePage(
            themeId: theme.type.value,
            subthemeId: state.pathParameters['subthemeId']!,
            store: store,
          ),
        ),
      ],
    ],
  );

  Future<void> pump(WidgetTester tester, GoRouter router, {double width = 1280}) async {
    tester.view.physicalSize = Size(width, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  for (final theme in themes) {
    for (final subtheme in theme.subthemes) {
      testWidgets('abre direto: ${theme.title} › ${subtheme.type.name}', (tester) async {
        await pump(tester, routerAt(subtheme.type.route));
        repository.succeed();
        await settle(tester);

        final name = subtheme.type.name;
        final count = devCountsBySubtheme[subtheme.type.id]!;
        expectHeading(tester, find.text(name).last, 1);
        expect(
          find.text('$count objetos digitais selecionados sobre ${name.toLowerCase()}.'),
          findsOneWidget,
        );
        expect(find.bySemanticsLabel('$name, página atual'), findsOneWidget);
        expect(find.bySemanticsLabel('Voltar para ${theme.title}'), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (w) => w is AppMedallion && w.size == 180 && w.image == subtheme.image,
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  final natureza = themes.firstWhere((t) => t.type == ThemeEnum.naturezaMeioAmbiente);
  const biomasRoute = '/natureza-meio-ambiente/biomas';

  testWidgets('medalhão de 96 fora do desktop', (tester) async {
    await pump(tester, routerAt(SubthemeEnum.biomas.route), width: 768);

    expect(find.byWidgetPredicate((w) => w is AppMedallion && w.size == 96), findsOneWidget);
    repository.succeed();
    await settle(tester);
  });

  testWidgets('entrar direto dispara uma única carga', (tester) async {
    await pump(tester, routerAt(SubthemeEnum.biomas.route));

    expect(repository.calls, 1);
    repository.succeed();
    await settle(tester);
    expect(repository.calls, 1);
  });

  testWidgets('cabeçalho aparece antes dos dados', (tester) async {
    await pump(tester, routerAt(SubthemeEnum.biomas.route));

    expect(find.bySemanticsLabel('Biomas, página atual'), findsOneWidget);
    expect(find.byType(ObjectRowSkeleton), findsNWidgets(3));
    repository.succeed();
    await settle(tester);
  });

  testWidgets('botão de voltar leva ao tema', (tester) async {
    await pump(tester, routerAt(SubthemeEnum.biomas.route));
    repository.succeed();
    await settle(tester);

    await tester.tap(find.bySemanticsLabel('Voltar para ${natureza.title}'));
    await tester.pumpAndSettle();
    expect(find.text('tema ${natureza.title}'), findsOneWidget);
  });

  testWidgets('migalha do tema leva ao tema', (tester) async {
    await pump(tester, routerAt(SubthemeEnum.biomas.route));
    repository.succeed();
    await settle(tester);

    await tester.tap(
      find.descendant(
        of: find.bySemanticsLabel('Você está em'),
        matching: find.text(natureza.title),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('tema ${natureza.title}'), findsOneWidget);
  });

  testWidgets('"Início" leva à Home', (tester) async {
    await pump(tester, routerAt(SubthemeEnum.biomas.route));
    repository.succeed();
    await settle(tester);

    await tester.tap(
      find.descendant(of: find.bySemanticsLabel('Você está em'), matching: find.text('Início')),
    );
    await tester.pumpAndSettle();
    expect(find.text('página inicial'), findsOneWidget);
  });

  for (final location in [
    '/cultura-politica/biomas',
    '/representacoes-espaciais/movimentos-terra',
    '/cultura-politica/qualquer-coisa',
  ]) {
    testWidgets('$location mostra a página de não encontrada', (tester) async {
      await pump(tester, routerAt(location));

      expect(find.byType(NotFoundPage), findsOneWidget);
      expect(find.byType(ObjectRow), findsNothing);
      expect(repository.calls, 0);
    });
  }

  testWidgets('trocar de subtema zera busca, tipo e quantidade', (tester) async {
    final router = routerAt(SubthemeEnum.biomas.route);
    await pump(tester, router);
    repository.succeed();
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'permafrost');
    await tester.pump();
    expect(find.byType(ObjectRow), findsNothing);

    router.go(SubthemeEnum.sustentabilidade.route);
    await settle(tester);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, isEmpty);
    expect(find.byType(ObjectRow), findsNWidgets(6));
    final chips = tester.widgetList<FilterChipButton>(find.byType(FilterChipButton));
    expect(chips.first.selected, isTrue);
    expect(repository.calls, 1);
  });

  testWidgets('um único h1, h3 por objeto e migalhas com nome', (tester) async {
    await pump(tester, routerAt(SubthemeEnum.biomas.route));
    repository.succeed(biomasRecords());
    await settle(tester);

    final levels = [
      for (final widget in tester.widgetList<Semantics>(find.byType(Semantics)))
        if (widget.properties.headingLevel case final level? when level > 0) level,
    ];
    expect(levels.where((level) => level == 1), hasLength(1));
    expect(levels.where((level) => level == 3), hasLength(6));
    expect(find.bySemanticsLabel('Você está em'), findsOneWidget);
    expect(biomasRoute, SubthemeEnum.biomas.route);
  });
}
