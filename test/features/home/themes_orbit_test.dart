import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/home/components/themes_orbit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/failing_asset_bundle.dart';

void main() {
  Future<void> pump(WidgetTester tester, {AssetBundle? bundle}) {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            const orbit = Scaffold(body: Center(child: ThemesOrbit()));
            return bundle == null ? orbit : DefaultAssetBundle(bundle: bundle, child: orbit);
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

  testWidgets('os 4 temas são links com o nome do tema', (tester) async {
    await pump(tester);

    for (final theme in ThemeDataModel.themes) {
      expect(
        tester.getSemantics(find.bySemanticsLabel(theme.title)),
        matchesSemantics(
          label: theme.title,
          isLink: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
    }
  });

  testWidgets('tocar no medalhão leva à rota do tema', (tester) async {
    await pump(tester);

    final theme = ThemeDataModel.themes[1];
    await tester.tap(find.bySemanticsLabel(theme.title));
    await tester.pumpAndSettle();

    expect(find.text('rota ${theme.type.value}'), findsOneWidget);
  });

  testWidgets('Tab passa pelos 4 medalhões', (tester) async {
    await pump(tester);

    final focused = <String>[];
    for (var i = 0; i < 4; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      for (final theme in ThemeDataModel.themes) {
        final data = tester.getSemantics(find.bySemanticsLabel(theme.title)).getSemanticsData();
        if (data.flagsCollection.isFocused) focused.add(theme.title);
      }
    }

    expect(focused, ThemeDataModel.themes.map((t) => t.title).toList());
  });

  testWidgets('ilustração que falha mostra o placeholder', (tester) async {
    await pump(tester, bundle: FailingImageBundle());
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();

    expect(find.byIcon(Icons.map_outlined), findsNWidgets(4));
  });
}
