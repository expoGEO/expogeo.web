import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/subtheme_overview_card.dart';
import 'package:expogeo/features/theme/components/theme_subthemes_section.dart';
import 'package:flutter/material.dart';
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

  final natureza = ThemeDataModel.themes[1];

  ThemeModel withSubthemes(int count) => ThemeModel(
    type: natureza.type,
    title: natureza.title,
    description: natureza.description,
    imagePath: natureza.imagePath,
    color: natureza.color,
    icon: natureza.icon,
    subthemes: natureza.subthemes.take(count).toList(),
  );

  Future<void> pump(
    WidgetTester tester,
    ThemeModel theme, {
    double width = 1280,
    double textScale = 1,
    AssetBundle? bundle,
  }) {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            final page = MediaQuery(
              data: MediaQueryData(
                size: Size(width, 900),
                textScaler: TextScaler.linear(textScale),
              ),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: ThemeSubthemesSection(theme: theme, store: store),
                ),
              ),
            );
            return bundle == null ? page : DefaultAssetBundle(bundle: bundle, child: page);
          },
        ),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  Finder cards() => find.byType(SubthemeOverviewCard, skipOffstage: false);

  int firstRowColumns(WidgetTester tester) {
    final top = tester.getTopLeft(cards().first).dy;
    return cards().evaluate().where((e) {
      return tester.getTopLeft(find.byWidget(e.widget, skipOffstage: false)).dy == top;
    }).length;
  }

  for (final theme in ThemeDataModel.themes) {
    testWidgets('título com ${theme.subthemes.length} subtemas: ${theme.title}', (tester) async {
      await pump(tester, theme);

      final title = '${theme.subthemes.length} subtemas';
      expect(find.text(title), findsOneWidget);
      expectHeading(tester, find.text(title), 2);
    });
  }

  testWidgets('singular com um subtema', (tester) async {
    await pump(tester, withSubthemes(1));

    expect(find.text('1 subtema'), findsOneWidget);
  });

  for (final (width, columns) in [(390.0, 2), (768.0, 3), (1280.0, 4)]) {
    testWidgets('$columns colunas em $width', (tester) async {
      await pump(tester, natureza, width: width);

      expect(firstRowColumns(tester), columns);
    });
  }

  testWidgets('cartões da mesma linha têm a mesma altura com o nome longo', (tester) async {
    final theme = ThemeModel(
      type: natureza.type,
      title: natureza.title,
      description: natureza.description,
      imagePath: natureza.imagePath,
      color: natureza.color,
      icon: natureza.icon,
      subthemes: [
        natureza.subthemes.firstWhere((s) => s.type == SubthemeEnum.estruturasFormasRelevo),
        natureza.subthemes.firstWhere((s) => s.type == SubthemeEnum.biomas),
      ],
    );
    await pump(tester, theme, width: 390);

    expect(tester.getSize(cards().at(0)).height, tester.getSize(cards().at(1)).height);
  });

  testWidgets('última linha incompleta não alarga o cartão', (tester) async {
    await pump(tester, withSubthemes(5), width: 390);

    expect(tester.getSize(cards().at(4)).width, tester.getSize(cards().at(0)).width);
  });

  for (final (index, theme) in ThemeDataModel.themes.indexed) {
    testWidgets('soma dos cartões bate com o total do tema $index', (tester) async {
      final load = store.ensureLoaded();
      repository.succeed();
      await load;
      await pump(tester, theme);

      final sum = theme.subthemes.fold<int>(
        0,
        (total, s) => total + store.catalog!.countBySubtheme(s.type),
      );
      expect(sum, store.catalog!.countByTheme(theme.type));
      for (final subtheme in theme.subthemes) {
        final count = store.catalog!.countBySubtheme(subtheme.type);
        expect(
          find.descendant(
            of: find.widgetWithText(SubthemeOverviewCard, subtheme.type.name, skipOffstage: false),
            matching: find.text('$count objetos', skipOffstage: false),
          ),
          findsOneWidget,
        );
      }
    });
  }

  testWidgets('imagem falhando na grade não lança exceção', (tester) async {
    await pump(tester, natureza, bundle: FailingImageBundle());
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.map_outlined), findsWidgets);
  });

  for (final width in [320.0, 390.0, 600.0, 768.0, 1024.0, 1280.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('sem overflow em $width com texto a ${scale * 100}%', (tester) async {
        final load = store.ensureLoaded();
        repository.succeed();
        await load;
        await pump(tester, natureza, width: width, textScale: scale);

        expect(tester.takeException(), isNull);
      });
    }
  }
}
