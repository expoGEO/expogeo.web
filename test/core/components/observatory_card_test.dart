import 'package:expogeo/core/components/structure/observatory_card.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_url_launcher.dart';
import '../../support/semantics.dart';

void main() {
  Future<void> pump(WidgetTester tester, {double width = 1280, double textScale = 1}) {
    tester.view.physicalSize = Size(width, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    return tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 1600), textScaler: TextScaler.linear(textScale)),
          child: const Scaffold(
            body: SingleChildScrollView(
              child: Padding(padding: EdgeInsets.all(20), child: ObservatoryCard()),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('textos, título h2 e botão externo', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);

    expect(find.text('A EXPOGEO FAZ PARTE DO'), findsOneWidget);
    expectHeading(tester, find.text('Observatório do Ensino de História e Geografia'), 2);
    expect(find.textContaining('biblioteca de teses e dissertações'), findsOneWidget);
    expect(find.bySemanticsLabel('Visitar o Observatório, abre em nova aba'), findsOneWidget);

    await tester.tap(find.text('Visitar o Observatório'));
    await tester.pumpAndSettle();
    expect(opened, [AppLinks.observatory]);
  });

  double symbolTop(WidgetTester tester) => tester.getTopLeft(find.byType(SvgPicture)).dy;
  double buttonTop(WidgetTester tester) =>
      tester.getTopLeft(find.text('Visitar o Observatório')).dy;

  testWidgets('em linha em 1280', (tester) async {
    await pump(tester);
    expect((buttonTop(tester) - symbolTop(tester)).abs(), lessThan(40));
  });

  for (final width in [390.0, 768.0]) {
    testWidgets('empilhado em ${width.toInt()} px', (tester) async {
      await pump(tester, width: width);
      expect(buttonTop(tester), greaterThan(symbolTop(tester) + 100));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('sem overflow em 390 px com texto a 200%', (tester) async {
    await pump(tester, width: 390, textScale: 2);
    expect(tester.takeException(), isNull);
  });
}
