import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:expogeo/core/components/reading/page_header.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  const trailingKey = Key('trailing');
  const detailsKey = Key('details');
  const actionKey = Key('action');

  Future<void> pump(
    WidgetTester tester, {
    double width = 1280,
    bool slots = true,
    String lead = 'Uma descrição curta.',
    bool action = false,
  }) {
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
                lead: lead,
                topAction: action ? const SizedBox(key: actionKey, width: 200, height: 40) : null,
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

  testWidgets('ação no topo fica à esquerda das migalhas, na mesma linha, em 1280', (tester) async {
    await pump(tester, action: true);

    final action = tester.getRect(find.byKey(actionKey));
    final crumbs = tester.getRect(find.byType(Breadcrumbs));
    expect(crumbs.left, greaterThan(action.right));
    expect(crumbs.center.dy, closeTo(action.center.dy, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ação no topo: em 390, as migalhas descem à esquerda', (tester) async {
    await pump(tester, width: 390, action: true);

    final action = tester.getRect(find.byKey(actionKey));
    final crumbs = tester.getRect(find.byType(Breadcrumbs));
    expect(crumbs.top, greaterThanOrEqualTo(action.bottom));
    expect(crumbs.left, action.left);
    expect(tester.takeException(), isNull);
  });

  for (final width in [768.0, 390.0]) {
    testWidgets('ação no topo: em $width, o medalhão fica acima da faixa', (tester) async {
      await pump(tester, width: width, action: true);

      final trailing = tester.getRect(find.byKey(trailingKey));
      expect(trailing.bottom, lessThanOrEqualTo(tester.getRect(find.byKey(actionKey)).top));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('descrição longa não passa da largura de leitura', (tester) async {
    final lead = 'Uma descrição bem longa. ' * 20;
    await pump(tester, slots: false, lead: lead);

    final width = tester.getSize(find.text(lead)).width;
    expect(width, AppTheme.dimensions.components.readingMaxWidth);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detalhes entram abaixo da descrição', (tester) async {
    await pump(tester);

    final lead = tester.getRect(find.text('Uma descrição curta.'));
    expect(tester.getRect(find.byKey(detailsKey)).top, greaterThanOrEqualTo(lead.bottom));
  });
}
