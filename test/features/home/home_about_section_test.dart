import 'package:expogeo/features/home/components/home_about_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/semantics.dart';

void main() {
  Future<void> pump(WidgetTester tester, {double width = 1280}) {
    tester.view.physicalSize = Size(width, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: SingleChildScrollView(child: HomeAboutSection())),
        ),
        GoRoute(path: '/sobre', builder: (context, state) => const Text('página sobre')),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('textos, h2 e três públicos em h3', (tester) async {
    await pump(tester);

    expect(find.text('SOBRE A EXPOGEO'), findsOneWidget);
    expectHeading(
      tester,
      find.text('Uma curadoria feita na universidade, pensada para a escola.'),
      2,
    );
    expect(find.textContaining('Reunimos materiais confiáveis'), findsOneWidget);
    for (final (_, title, text) in HomeAboutSection.audiences) {
      expectHeading(tester, find.text(title), 3);
      expect(find.text(text), findsOneWidget);
    }
  });

  testWidgets('"Saiba mais sobre o projeto" leva a /sobre', (tester) async {
    await pump(tester);

    expect(find.bySemanticsLabel('Saiba mais sobre o projeto'), findsOneWidget);
    await tester.tap(find.text('Saiba mais sobre o projeto'));
    await tester.pumpAndSettle();
    expect(find.text('página sobre'), findsOneWidget);
  });

  for (final (width, columns) in [(390.0, 1), (768.0, 1), (1280.0, 2)]) {
    testWidgets('$columns coluna(s) em ${width.toInt()} px', (tester) async {
      await pump(tester, width: width);

      final linkTop = tester.getTopLeft(find.text('Saiba mais sobre o projeto')).dy;
      final firstAudienceTop = tester.getTopLeft(find.text('Estudantes')).dy;
      expect(firstAudienceTop < linkTop, columns == 2);
      expect(tester.takeException(), isNull);
    });
  }
}
