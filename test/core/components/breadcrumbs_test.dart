import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Future<void> pump(WidgetTester tester, {double width = 1280, double textScale = 1}) {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/sobre',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Text('página inicial')),
        GoRoute(
          path: '/sobre',
          builder: (context, state) => MediaQuery(
            data: MediaQueryData(size: Size(width, 800), textScaler: TextScaler.linear(textScale)),
            child: const Scaffold(
              body: Breadcrumbs(
                items: [
                  BreadcrumbItem('Início', route: '/'),
                  BreadcrumbItem('Um item intermediário com nome bem comprido', route: '/'),
                  BreadcrumbItem('Sobre'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('grupo "Você está em", página atual e links', (tester) async {
    await pump(tester);

    expect(find.bySemanticsLabel('Você está em'), findsOneWidget);
    final current = tester.getSemantics(find.text('Sobre')).getSemanticsData();
    expect(current.label, 'Sobre, página atual');
    expect(current.flagsCollection.isLink, isFalse);
    final home = tester.getSemantics(find.text('Início')).getSemanticsData();
    expect(home.flagsCollection.isLink, isTrue);
    expect(home.label, 'Início');
    expect(find.bySemanticsLabel(RegExp('chevron')), findsNothing);
  });

  testWidgets('"Início" leva à página inicial', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Início'));
    await tester.pumpAndSettle();
    expect(find.text('página inicial'), findsOneWidget);
  });

  testWidgets('quebra sem overflow em 390 px com texto a 200%', (tester) async {
    await pump(tester, width: 390, textScale: 2);
    expect(tester.takeException(), isNull);
  });
}
