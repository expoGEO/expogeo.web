import 'package:expogeo/core/components/chip/filter_chip_button.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const unit = (singular: 'objeto', plural: 'objetos');

  Future<void> pump(
    WidgetTester tester, {
    int? count = 4,
    bool selected = false,
    VoidCallback? onPressed,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FilterChipButton(
              label: 'Site',
              count: count,
              countUnit: unit,
              selected: selected,
              onPressed: onPressed ?? () {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('selecionado fica em tinta com texto branco', (tester) async {
    await pump(tester, selected: true);

    final material = tester.widget<Material>(
      find.ancestor(of: find.text('Site'), matching: find.byType(Material)).first,
    );
    expect(material.color, AppTheme.colors.ink);
    expect(tester.widget<Text>(find.text('Site')).style?.color, AppTheme.colors.white);
    expect(tester.widget<Text>(find.text('4')).style?.color, AppTheme.colors.white);
  });

  testWidgets('leitura com plural e singular', (tester) async {
    await pump(tester);
    expect(find.bySemanticsLabel('Site, 4 objetos'), findsOneWidget);

    await pump(tester, count: 1);
    expect(find.bySemanticsLabel('Site, 1 objeto'), findsOneWidget);
  });

  testWidgets('estado de pressionado', (tester) async {
    await pump(tester, selected: true);
    final node = tester.getSemantics(find.bySemanticsLabel('Site, 4 objetos'));
    expect(node.getSemanticsData().flagsCollection.isToggled, isNotNull);
    expect(
      node,
      matchesSemantics(
        isButton: true,
        hasToggledState: true,
        isToggled: true,
        hasEnabledState: false,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
        label: 'Site, 4 objetos',
      ),
    );
  });

  testWidgets('altura mínima de toque', (tester) async {
    await pump(tester);

    expect(
      tester.getSize(find.byType(FilterChipButton)).height,
      greaterThanOrEqualTo(AppTheme.dimensions.components.minTapTarget),
    );
  });

  testWidgets('toque chama a ação', (tester) async {
    var taps = 0;
    await pump(tester, onPressed: () => taps++);

    await tester.tap(find.text('Site'));
    expect(taps, 1);
  });

  testWidgets('um único ponto de foco e anel visível no teclado', (tester) async {
    await pump(tester);
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final first = FocusManager.instance.primaryFocus;
    expect(first?.context?.findAncestorWidgetOfExactType<FilterChipButton>(), isNotNull);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(FocusManager.instance.primaryFocus, same(first));

    final ring = find.byWidgetPredicate(
      (w) =>
          w is DecoratedBox &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).border != null,
    );
    expect(ring, findsOneWidget);
  });
}
