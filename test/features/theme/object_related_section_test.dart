import 'package:expogeo/core/components/card/object_card.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/theme/components/object_related_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/semantics.dart';
import '../catalog/catalog_test_data.dart';

void main() {
  Future<void> pump(WidgetTester tester, int count, {double width = 1280}) async {
    tester.view.physicalSize = Size(width, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final catalog = CatalogModel.fromRecords(biomasRecords().take(count).toList());
    final current = catalog.items.first;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: SingleChildScrollView(
              child: ObjectRelatedSection(item: current, catalog: catalog),
            ),
          ),
        ),
        GoRoute(
          path: SubthemeEnum.biomas.route,
          builder: (context, state) => const Text('subtema'),
        ),
        GoRoute(
          path: '${SubthemeEnum.biomas.route}/:code',
          builder: (context, state) => Text('objeto ${state.pathParameters['code']}'),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  List<String> shown(WidgetTester tester) => [
    for (final card in tester.widgetList<ObjectCard>(find.byType(ObjectCard))) card.content.id,
  ];

  // biomasRecords: chegam na ordem 4, 2, 7, 1, 6, 3, 5; o atual é o 4.
  testWidgets('com 7 objetos, mostra 3 na ordem do código, sem o atual', (tester) async {
    await pump(tester, 7);

    expect(shown(tester), ['NMA_BIO_01', 'NMA_BIO_02', 'NMA_BIO_03']);
  });

  testWidgets('com 3 objetos, mostra os outros 2', (tester) async {
    await pump(tester, 3);

    expect(shown(tester), ['NMA_BIO_02', 'NMA_BIO_07']);
  });

  testWidgets('com 2 objetos, mostra o outro', (tester) async {
    await pump(tester, 2);

    expect(shown(tester), ['NMA_BIO_02']);
  });

  testWidgets('com 1 objeto, a seção some', (tester) async {
    await pump(tester, 1);

    expect(find.textContaining('Outros objetos'), findsNothing);
    expect(find.text('Ver todos'), findsNothing);
  });

  testWidgets('título h2 e cartões h3', (tester) async {
    await pump(tester, 7);

    expectHeading(tester, find.text('Outros objetos de Biomas'), 2);
    expectHeading(tester, find.text('Objeto NMA_BIO_02'), 3);
  });

  testWidgets('"Ver todos" leva ao subtema, com nome próprio', (tester) async {
    await pump(tester, 7);

    expect(find.bySemanticsLabel('Ver todos os objetos de Biomas'), findsOneWidget);
    await tester.tap(find.text('Ver todos'));
    await tester.pumpAndSettle();
    expect(find.text('subtema'), findsOneWidget);
  });

  testWidgets('o cartão abre a página daquele objeto', (tester) async {
    await pump(tester, 7);

    await tester.tap(find.byType(ObjectCard).at(1));
    await tester.pumpAndSettle();
    expect(find.text('objeto nma-bio-02'), findsOneWidget);
  });

  for (final width in [320.0, 390.0, 768.0, 1280.0]) {
    testWidgets('sem overflow em $width', (tester) async {
      await pump(tester, 7, width: width);

      expect(tester.takeException(), isNull);
    });
  }
}
