import 'package:expogeo/core/components/reading/reference_code.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: ReferenceCode('NMA_TPCL_04'))),
      ),
    );
  }

  testWidgets('usa Figtree 600 com algarismos tabulares', (tester) async {
    await pump(tester, 390);

    final style = tester.widget<Text>(find.text('NMA_TPCL_04')).style!;
    expect(style.fontFamily, 'Figtree');
    expect(style.fontWeight, FontWeight.w600);
    expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
  });

  testWidgets('fica numa pílula com borda', (tester) async {
    await pump(tester, 390);

    final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = box.decoration as BoxDecoration;
    expect(decoration.border, isNotNull);
    expect(decoration.border!.top.color, AppTheme.colors.line);
  });

  testWidgets('sem overflow em 320', (tester) async {
    await pump(tester, 320);

    expect(tester.takeException(), isNull);
  });
}
