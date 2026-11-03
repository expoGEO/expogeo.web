import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/home/components/theme_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/failing_asset_bundle.dart';
import '../catalog/catalog_test_data.dart';

void main() {
  late FakeCatalogRepository repository;
  late CatalogStore store;

  setUp(() {
    repository = FakeCatalogRepository();
    store = CatalogStore(repository);
  });

  final natureza = ThemeDataModel.themes[1];
  final cultura = ThemeDataModel.themes[3];

  Future<void> pump(
    WidgetTester tester,
    List<ThemeModel> themes, {
    double width = 1280,
    AssetBundle? bundle,
  }) {
    tester.view.physicalSize = Size(width, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            final page = Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final theme in themes) ThemeOverviewCard(theme: theme, store: store),
                  ],
                ),
              ),
            );
            return bundle == null ? page : DefaultAssetBundle(bundle: bundle, child: page);
          },
        ),
        GoRoute(
          path: '/:theme',
          builder: (context, state) => Text('rota ${state.pathParameters['theme']}'),
        ),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('mostra até 4 subtemas e "+N" com o resto', (tester) async {
    await pump(tester, [natureza, cultura]);

    expect(natureza.subthemes.length, 12);
    expect(find.text('+8'), findsOneWidget);
    expect(cultura.subthemes.length, 6);
    expect(find.text('+2'), findsOneWidget);
    for (final subtheme in natureza.subthemes.take(4)) {
      expect(find.text(subtheme.type.name), findsOneWidget);
    }
    expect(find.text(natureza.subthemes[4].type.name), findsNothing);
  });

  testWidgets('tema com menos de 4 subtemas não mostra "+N"', (tester) async {
    final base = ThemeDataModel.themes.first;
    final small = ThemeModel(
      type: base.type,
      title: base.title,
      description: base.description,
      imagePath: base.imagePath,
      color: base.color,
      icon: base.icon,
      subthemes: base.subthemes.take(3).toList(),
    );
    await pump(tester, [small]);

    expect(find.textContaining('+'), findsNothing);
  });

  testWidgets('contagem de objetos vem do catálogo', (tester) async {
    final load = store.ensureLoaded();
    repository.succeed();
    await load;
    await pump(tester, [natureza]);

    expect(find.bySemanticsLabel('12 subtemas, 74 objetos'), findsOneWidget);
  });

  testWidgets('sem catálogo, mostra só os subtemas', (tester) async {
    final load = store.ensureLoaded();
    repository.fail();
    await load;
    await pump(tester, [natureza]);

    expect(find.bySemanticsLabel('12 subtemas'), findsOneWidget);
    expect(find.textContaining('objetos'), findsNothing);
  });

  testWidgets('Tab passa uma vez por cartão', (tester) async {
    await pump(tester, [natureza, cultura]);
    final cards = find.byType(ThemeOverviewCard);

    bool focused(int index) =>
        tester.getSemantics(cards.at(index)).getSemanticsData().flagsCollection.isFocused;

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect([focused(0), focused(1)], [true, false]);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect([focused(0), focused(1)], [false, true]);
  });

  testWidgets('o cartão é um link e o nome do tema é cabeçalho de nível 3', (tester) async {
    await pump(tester, [natureza]);

    final card = tester.getSemantics(find.byType(ThemeOverviewCard)).getSemanticsData();
    expect(card.flagsCollection.isLink, isTrue);
    expect(card.flagsCollection.isFocusable, isTrue);

    final title = tester.getSemantics(find.text(natureza.title)).getSemanticsData();
    expect(title.flagsCollection.isHeader, isTrue);
    expect(title.headingLevel, 3);
  });

  for (final (name, target) in [
    ('medalhão', (ThemeModel t) => find.byType(Image)),
    ('descrição', (ThemeModel t) => find.text(t.description.trim())),
    ('chip', (ThemeModel t) => find.text(t.subthemes.first.type.name)),
  ]) {
    testWidgets('tocar no $name leva ao tema', (tester) async {
      await pump(tester, [natureza]);

      await tester.tap(target(natureza).first);
      await tester.pumpAndSettle();

      expect(find.text('rota ${natureza.type.value}'), findsOneWidget);
    });
  }

  testWidgets('ilustração que falha mostra o placeholder', (tester) async {
    await pump(tester, [natureza], bundle: FailingImageBundle());
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();

    expect(find.byIcon(Icons.map_outlined), findsOneWidget);
  });

  testWidgets('nomes longos cabem no cartão em tela estreita', (tester) async {
    final relevo = ThemeModel(
      type: natureza.type,
      title: natureza.title,
      description: natureza.description,
      imagePath: natureza.imagePath,
      color: natureza.color,
      icon: natureza.icon,
      subthemes: [...natureza.subthemes]
        ..sort((a, b) => b.type.name.length.compareTo(a.type.name.length)),
    );
    await pump(tester, [relevo], width: 320);

    expect(tester.takeException(), isNull);
  });
}
