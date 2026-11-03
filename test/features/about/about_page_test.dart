import 'package:expogeo/core/components/reading/reading_column.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/features/about/components/reference_code_example.dart';
import 'package:expogeo/features/about/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/fake_url_launcher.dart';

void main() {
  Future<void> pump(WidgetTester tester, {double width = 1280, double textScale = 1}) {
    tester.view.physicalSize = Size(width, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/sobre',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Text('página inicial')),
        GoRoute(
          path: '/sobre',
          builder: (context, state) => MediaQuery(
            data: MediaQueryData(size: Size(width, 4000), textScaler: TextScaler.linear(textScale)),
            child: const AboutPage(),
          ),
        ),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('conteúdo do texto e do código', (tester) async {
    await pump(tester);

    expect(
      find.text('Conhecimento, tecnologia e interatividade a serviço do ensino de Geografia.'),
      findsOneWidget,
    );
    for (final paragraph in AboutPage.paragraphs) {
      expect(find.text(paragraph), findsOneWidget);
    }
    expect(find.textContaining('Todo objeto digital recebe uma ficha'), findsOneWidget);
    for (final (code, title, detail) in ReferenceCodeExample.parts) {
      expect(find.text(code), findsOneWidget);
      expect(find.text('$title\n$detail'), findsOneWidget);
    }
    expect(find.bySemanticsLabel('Exemplo de código de referência'), findsOneWidget);
    expect(
      find.text('Os links são revisados ao longo do tempo para que continuem funcionando.'),
      findsOneWidget,
    );
    expect(find.textContaining('Para começar sua experiência'), findsNothing);
  });

  testWidgets('um único h1 e os h2 das seções', (tester) async {
    await pump(tester);

    final headings = {
      for (final widget in tester.widgetList<Semantics>(find.byType(Semantics)))
        if (widget.properties.headingLevel case final level? when level > 0)
          (widget.child is Text ? (widget.child! as Text).data! : '?'): level,
    };
    expect(headings.entries.where((e) => e.value == 1).map((e) => e.key), ['Sobre a expoGEO']);
    expect(headings['Como cada objeto é descrito'], 2);
    expect(headings['Realização e apoio'], 2);
    expect(headings['Observatório do Ensino de História e Geografia'], 2);
  });

  testWidgets('botões de metadados e tese abrem em nova aba', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);
    Finder inText(Finder finder) =>
        find.descendant(of: find.byType(ReadingColumn), matching: finder);
    expect(
      inText(find.bySemanticsLabel('Metadados da curadoria, abre em nova aba')),
      findsOneWidget,
    );
    expect(inText(find.bySemanticsLabel('Tese de doutorado, abre em nova aba')), findsOneWidget);

    await tester.tap(inText(find.text('Metadados da curadoria')));
    await tester.tap(inText(find.text('Tese de doutorado')));
    await tester.pumpAndSettle();
    expect(opened, [AppLinks.curationMetadata, AppLinks.thesis]);
  });

  testWidgets('"Início" das migalhas leva à página inicial', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Início'));
    await tester.pumpAndSettle();
    expect(find.text('página inicial'), findsOneWidget);
  });

  for (final (width, columns) in [(390.0, 1), (768.0, 3), (1280.0, 3)]) {
    testWidgets('código em $columns coluna(s) e sem overflow em ${width.toInt()} px', (
      tester,
    ) async {
      await pump(tester, width: width);

      final tops = {
        for (final code in ['RE', 'LM', '01']) tester.getTopLeft(find.text(code)).dy,
      };
      expect(tops.length, columns == 1 ? 3 : 1);
      expect(tester.takeException(), isNull);
    });
  }

  // A navbar tem altura fixa e não entra aqui; a 200% conferem-se os blocos novos da página.
  testWidgets('blocos do código quebram sem overflow em 390 px com texto a 200%', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(390, 1200), textScaler: TextScaler.linear(2)),
          child: Scaffold(body: ReferenceCodeExample()),
        ),
      ),
    );
    expect(find.text('Número de referência\nna curadoria'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
