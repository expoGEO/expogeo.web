import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_nav_item.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_sidebar.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../catalog/catalog_test_data.dart';

void main() {
  late FakeCatalogRepository repository;
  late CatalogStore store;
  late List<String> navigated;

  setUp(() {
    repository = FakeCatalogRepository();
    store = CatalogStore(repository);
    navigated = [];
  });

  Future<void> pump(WidgetTester tester, {PanelView? view = PanelView.objects, ThemeEnum? theme}) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 248,
            child: PanelSidebar(
              catalogStore: store,
              view: view,
              theme: theme,
              onNavigate: navigated.add,
              onLogout: () {},
            ),
          ),
        ),
      ),
    );
  }

  Future<void> load(WidgetTester tester) async {
    final loading = store.ensureLoaded();
    repository.succeed();
    await loading;
    await tester.pump();
  }

  group('item', () {
    testWidgets('a contagem é lida junto do nome e o atual fica marcado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PanelNavItem(
              title: 'Objetos digitais',
              count: 190,
              isCurrent: true,
              onTap: () {},
            ),
          ),
        ),
      );

      final data = tester.getSemantics(find.byType(PanelNavItem)).getSemanticsData();
      expect(data.label, 'Objetos digitais, 190');
      expect(data.flagsCollection.isSelected, isTrue);
    });

    testWidgets('sem contagem, só o nome', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PanelNavItem(title: 'Objetos digitais', onTap: () {}),
          ),
        ),
      );

      final data = tester.getSemantics(find.byType(PanelNavItem)).getSemanticsData();
      expect(data.label, 'Objetos digitais');
      expect(data.flagsCollection.isSelected, isFalse);
    });
  });

  testWidgets('números iguais aos do catálogo e 31 subtemas', (tester) async {
    await pump(tester);
    await load(tester);

    final catalog = CatalogModel.fromRecords(devRecords());
    expect(find.bySemanticsLabel('Objetos digitais, ${catalog.total}'), findsOneWidget);
    for (final theme in ThemeEnum.values) {
      expect(
        find.bySemanticsLabel('${theme.name}, ${catalog.countByTheme(theme)}'),
        findsOneWidget,
      );
    }
    expect(find.bySemanticsLabel('Temas e subtemas, 31'), findsOneWidget);
    expect(find.bySemanticsLabel('Seções do painel'), findsOneWidget);
  });

  testWidgets('carregando mostra esqueleto no lugar dos números', (tester) async {
    await pump(tester);
    store.ensureLoaded();
    await tester.pump();

    expect(find.byType(AppSkeleton), findsNWidgets(5));
    expect(find.bySemanticsLabel('Objetos digitais'), findsOneWidget);
    repository.succeed();
    await tester.pump();
  });

  testWidgets('erro mostra os itens sem números', (tester) async {
    await pump(tester);
    final loading = store.ensureLoaded();
    repository.fail();
    await loading;
    await tester.pump();

    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.bySemanticsLabel('Objetos digitais'), findsOneWidget);
    expect(find.bySemanticsLabel('Cultura e Política'), findsOneWidget);
  });

  testWidgets('com um tema, ele é o atual e "Objetos digitais" fica como pai', (tester) async {
    await pump(tester, theme: ThemeEnum.culturaPolitica);
    await load(tester);

    final items = tester.widgetList<PanelNavItem>(find.byType(PanelNavItem));
    final objects = items.firstWhere((item) => item.title == 'Objetos digitais');
    final culture = items.firstWhere((item) => item.title == 'Cultura e Política');
    expect(objects.isCurrent, isFalse);
    expect(objects.isParentOfCurrent, isTrue);
    expect(culture.isCurrent, isTrue);
  });

  testWidgets('tocar num tema navega com ?tema=', (tester) async {
    await pump(tester, view: PanelView.themes);
    await load(tester);

    await tester.tap(find.text('Natureza e Meio Ambiente'));
    await tester.tap(find.text('Temas e subtemas'));

    expect(navigated, ['/admin/painel/objetos?tema=natureza-meio-ambiente', '/admin/painel/temas']);
  });
}
