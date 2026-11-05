import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:expogeo/core/components/reading/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  const trailingKey = Key('trailing');
  const detailsKey = Key('details');

  Future<void> pump(WidgetTester tester, {double width = 1280, bool slots = true}) {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: SingleChildScrollView(
              child: PageHeader(
                breadcrumbs: const [
                  BreadcrumbItem('Início', route: '/'),
                  BreadcrumbItem('Tema'),
                ],
                title: 'Título da página',
                lead: 'Uma descrição curta.',
                details: slots ? const SizedBox(key: detailsKey, height: 20) : null,
                trailing: slots ? const SizedBox.square(key: trailingKey, dimension: 96) : null,
              ),
            ),
          ),
        ),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('sem os espaços opcionais, só migalhas, título e descrição', (tester) async {
    await pump(tester, slots: false);

    expect(find.byType(Breadcrumbs), findsOneWidget);
    expect(find.text('Título da página'), findsOneWidget);
    expect(find.text('Uma descrição curta.'), findsOneWidget);
    expect(find.byKey(trailingKey), findsNothing);
    expect(find.byKey(detailsKey), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('no desktop, o espaço lateral fica à direita do título', (tester) async {
    await pump(tester);

    final trailing = tester.getRect(find.byKey(trailingKey));
    final title = tester.getRect(find.text('Título da página'));
    expect(trailing.left, greaterThanOrEqualTo(title.right));
    expect(trailing.top, lessThan(title.bottom));
    expect(tester.takeException(), isNull);
  });

  for (final width in [768.0, 390.0]) {
    testWidgets('em $width, o espaço lateral fica acima das migalhas, à esquerda', (tester) async {
      await pump(tester, width: width);

      final trailing = tester.getRect(find.byKey(trailingKey));
      final crumbs = tester.getRect(find.byType(Breadcrumbs));
      expect(trailing.bottom, lessThanOrEqualTo(crumbs.top));
      expect(trailing.left, crumbs.left);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('detalhes entram abaixo da descrição', (tester) async {
    await pump(tester);

    final lead = tester.getRect(find.text('Uma descrição curta.'));
    expect(tester.getRect(find.byKey(detailsKey)).top, greaterThanOrEqualTo(lead.bottom));
  });
}
