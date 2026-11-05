import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/theme/components/other_themes_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/failing_asset_bundle.dart';

void main() {
  final themes = ThemeDataModel.themes;

  Future<void> pump(WidgetTester tester, int current, {double width = 1280, AssetBundle? bundle}) {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            final page = Scaffold(body: OtherThemesSection(current: themes[current]));
            return bundle == null ? page : DefaultAssetBundle(bundle: bundle, child: page);
          },
        ),
        GoRoute(path: '/:theme', builder: (context, state) => Text('rota ${state.uri.path}')),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  for (final (index, theme) in themes.indexed) {
    testWidgets('3 chips sem o tema atual: ${theme.title}', (tester) async {
      await pump(tester, index);

      expect(find.text(theme.title), findsNothing);
      for (final other in themes.where((t) => t != theme)) {
        expect(find.text(other.title), findsOneWidget);
      }
    });
  }

  for (final other in themes.skip(1)) {
    testWidgets('o chip abre ${other.type.route}', (tester) async {
      await pump(tester, 0);

      await tester.tap(find.text(other.title));
      await tester.pumpAndSettle();

      expect(find.text('rota ${other.type.route}'), findsOneWidget);
    });
  }

  testWidgets('um ponto de foco por chip e Enter abre', (tester) async {
    await pump(tester, 0);

    Finder link(String label) => find.bySemanticsLabel(label);
    bool focused(String label) =>
        tester.getSemantics(link(label)).getSemanticsData().flagsCollection.isFocused;

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(focused(themes[1].title), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(focused(themes[1].title), isFalse);
    expect(focused(themes[2].title), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('rota ${themes[2].type.route}'), findsOneWidget);
  });

  testWidgets('chip é link com altura mínima de toque', (tester) async {
    await pump(tester, 0);

    final chip = tester.getSemantics(find.bySemanticsLabel(themes[1].title));
    expect(chip.getSemanticsData().flagsCollection.isLink, isTrue);
    expect(tester.getSize(find.byType(InkWell).first).height, greaterThanOrEqualTo(44));
  });

  testWidgets('rótulo é h2 "Outros temas" e aparece em caixa alta', (tester) async {
    await pump(tester, 0);

    expect(find.text('OUTROS TEMAS'), findsOneWidget);
    final label = tester.getSemantics(find.bySemanticsLabel('Outros temas')).getSemanticsData();
    expect(label.flagsCollection.isHeader, isTrue);
    expect(label.headingLevel, 2);
  });

  testWidgets('mini-medalhão que falha mostra o placeholder', (tester) async {
    await pump(tester, 0, bundle: FailingImageBundle());
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();

    expect(find.byIcon(Icons.map_outlined), findsNWidgets(3));
  });

  testWidgets('chips quebram linha em 390 sem overflow', (tester) async {
    await pump(tester, 3, width: 390);

    expect(tester.takeException(), isNull);
    final first = tester.getTopLeft(find.text(themes[0].title)).dy;
    final last = tester.getTopLeft(find.text(themes[2].title)).dy;
    expect(last, greaterThan(first));
  });
}
