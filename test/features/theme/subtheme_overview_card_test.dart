import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/subtheme_overview_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/failing_asset_bundle.dart';
import '../../support/semantics.dart';
import '../catalog/catalog_test_data.dart';

void main() {
  late FakeCatalogRepository repository;
  late CatalogStore store;

  setUp(() {
    repository = FakeCatalogRepository();
    store = CatalogStore(repository);
  });

  final relevo = ThemeDataModel.themes[1].subthemes.firstWhere(
    (s) => s.type == SubthemeEnum.estruturasFormasRelevo,
  );
  final biomas = ThemeDataModel.themes[1].subthemes.firstWhere(
    (s) => s.type == SubthemeEnum.biomas,
  );

  Future<void> pump(
    WidgetTester tester,
    List<SubthemeModel> subthemes, {
    AssetBundle? bundle,
    bool disableAnimations = false,
    double screenWidth = 1280,
  }) {
    tester.view.physicalSize = Size(screenWidth, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            final page = MediaQuery(
              data: MediaQueryData(
                size: Size(screenWidth, 1000),
                disableAnimations: disableAnimations,
              ),
              child: Scaffold(
                body: Column(
                  children: [
                    for (final subtheme in subthemes)
                      SizedBox(
                        width: 260,
                        child: SubthemeOverviewCard(subtheme: subtheme, store: store),
                      ),
                  ],
                ),
              ),
            );
            return bundle == null ? page : DefaultAssetBundle(bundle: bundle, child: page);
          },
        ),
        GoRoute(
          path: '/:theme/:subtheme',
          builder: (context, state) => Text('rota ${state.uri.path}'),
        ),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  Future<void> loadCounts(List<CatalogRecord> records) async {
    final load = store.ensureLoaded();
    repository.succeed(records);
    await load;
  }

  List<CatalogRecord> records(int count) => [
    for (var i = 0; i < count; i++) recordAt('NMA_BIO', 'b$i'),
  ];

  testWidgets('nome em caixa normal', (tester) async {
    await pump(tester, [relevo]);

    expect(find.text('Estruturas e Formas do Relevo'), findsOneWidget);
  });

  for (final (width, compact) in [(390.0, true), (600.0, true), (768.0, true), (1280.0, false)]) {
    testWidgets('em $width, nome ${compact ? 'menor' : 'maior'}', (tester) async {
      await pump(tester, [relevo], screenWidth: width);

      final components = AppTheme.dimensions.components;
      final name = tester.widget<Text>(find.text('Estruturas e Formas do Relevo'));
      expect(
        name.style?.fontSize,
        compact ? components.subthemeCardNameMobile : components.subthemeCardName,
      );
    });
  }

  for (final (count, phrase) in [(7, '7 objetos'), (1, '1 objeto'), (0, 'Nenhum objeto ainda')]) {
    testWidgets('com $count, mostra "$phrase"', (tester) async {
      await loadCounts(records(count));
      await pump(tester, [biomas]);

      expect(find.text(phrase), findsOneWidget);
      expect(find.byType(AppSkeleton), findsNothing);
    });
  }

  testWidgets('carregando: esqueleto, sem número na leitura de tela', (tester) async {
    await pump(tester, [biomas]);

    expect(find.byType(AppSkeleton), findsOneWidget);
    expect(find.textContaining('objeto'), findsNothing);
  });

  testWidgets('o esqueleto não muda a altura do cartão', (tester) async {
    final load = store.ensureLoaded();
    await pump(tester, [biomas]);
    final loading = tester.getSize(find.byType(SubthemeOverviewCard)).height;

    repository.succeed(records(7));
    await load;
    await tester.pump();

    expect(tester.getSize(find.byType(SubthemeOverviewCard)).height, loading);
  });

  testWidgets('erro: sem contagem e continua sendo link', (tester) async {
    final load = store.ensureLoaded();
    repository.fail();
    await load;
    await pump(tester, [biomas]);

    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.textContaining('objeto'), findsNothing);
    final card = tester.getSemantics(find.byType(SubthemeOverviewCard)).getSemanticsData();
    expect(card.flagsCollection.isLink, isTrue);
  });

  testWidgets('clique leva à rota do subtema', (tester) async {
    await pump(tester, [biomas]);

    await tester.tap(find.byType(SubthemeOverviewCard));
    await tester.pumpAndSettle();

    expect(find.text('rota ${biomas.type.route}'), findsOneWidget);
  });

  testWidgets('Enter leva à rota do subtema', (tester) async {
    await pump(tester, [biomas]);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.text('rota ${biomas.type.route}'), findsOneWidget);
  });

  testWidgets('um ponto de foco por cartão no Tab', (tester) async {
    await pump(tester, [relevo, biomas]);
    final cards = find.byType(SubthemeOverviewCard);

    bool focused(int index) =>
        tester.getSemantics(cards.at(index)).getSemanticsData().flagsCollection.isFocused;

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect([focused(0), focused(1)], [true, false]);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect([focused(0), focused(1)], [false, true]);
  });

  testWidgets('um nó de link com o h3 dentro', (tester) async {
    await pump(tester, [biomas]);

    final card = tester.getSemantics(find.byType(SubthemeOverviewCard)).getSemanticsData();
    expect(card.flagsCollection.isLink, isTrue);
    expect(card.flagsCollection.isFocusable, isTrue);
    expectHeading(tester, find.text(biomas.type.name), 3);

    expect(
      tester.getSemantics(find.text(biomas.type.name)),
      isNot(same(tester.getSemantics(find.byType(SubthemeOverviewCard)))),
    );
  });

  testWidgets('ilustração que falha mostra o placeholder', (tester) async {
    await pump(tester, [biomas], bundle: FailingImageBundle());
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();

    expect(find.byIcon(Icons.map_outlined), findsOneWidget);
  });

  group('hover', () {
    Future<TestGesture> hover(WidgetTester tester) async {
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(SubthemeOverviewCard)));
      await tester.pumpAndSettle();
      return mouse;
    }

    testWidgets('gira e cresce o medalhão e pinta o nome', (tester) async {
      await loadCounts(records(7));
      await pump(tester, [biomas]);
      await hover(tester);

      expect(tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns, isNot(0));
      expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, greaterThan(1));
      final name = tester.widget<Text>(find.text(biomas.type.name));
      expect(name.style?.color, const Color(0xFFC94400));
    });

    testWidgets('com "reduzir movimento", só a cor muda', (tester) async {
      await pump(tester, [biomas], disableAnimations: true);
      await hover(tester);

      expect(tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns, 0);
      expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
      final name = tester.widget<Text>(find.text(biomas.type.name));
      expect(name.style?.color, const Color(0xFFC94400));
    });
  });
}
