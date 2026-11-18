import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/structure/footer.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_dropdown.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_mobile_menu.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Future<GoRouter> pump(
    WidgetTester tester,
    String location, {
    double width = 1280,
    double height = 1200,
  }) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: location,
      errorBuilder: (context, state) => const NotFoundPage(),
      routes: [GoRoute(path: '/', builder: (context, state) => const Text('início'))],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    return router;
  }

  String pathOf(GoRouter router) => router.routeInformationProvider.value.uri.toString();

  testWidgets('"404", título, texto, botão, navbar e rodapé, com o endereço mantido', (
    tester,
  ) async {
    final router = await pump(tester, '/nao-existe');

    expect(find.text('404'), findsOneWidget);
    expect(find.text('Este lugar não está no mapa'), findsOneWidget);
    expect(
      find.text(
        'O endereço pode ter mudado ou o conteúdo saiu da curadoria. '
        'Volte aos temas para continuar explorando.',
      ),
      findsOneWidget,
    );
    final button = tester.widget<AppButton>(find.byType(AppButton).last);
    expect(button.kind, AppButtonKind.primary);
    expect(find.text('Ir para o início'), findsOneWidget);
    expect(find.byType(NavbarDropdown), findsOneWidget);
    expect(find.byType(Footer), findsOneWidget);
    expect(pathOf(router), '/nao-existe');
  });

  testWidgets('"Ir para o início" leva à Home', (tester) async {
    final router = await pump(tester, '/nao-existe');

    await tester.tap(find.text('Ir para o início'));
    await tester.pumpAndSettle();

    expect(find.text('início'), findsOneWidget);
    expect(pathOf(router), '/');
  });

  testWidgets('o título é o único h1 e o "404" não é lido', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, '/nao-existe');

    final h1 = [
      for (final widget in tester.widgetList<Semantics>(find.byType(Semantics)))
        if (widget.properties.headingLevel == 1) widget,
    ];
    expect(h1, hasLength(1));
    expect(
      find.descendant(
        of: find.byWidget(h1.single),
        matching: find.text('Este lugar não está no mapa'),
      ),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('404'), findsNothing);
    handle.dispose();
  });

  testWidgets('em endereço de tema, "Temas" não fica ativo', (tester) async {
    await pump(tester, '/natureza-meio-ambiente/nao-existe');

    expect(tester.widget<NavbarDropdown>(find.byType(NavbarDropdown)).isActive, isFalse);
  });

  testWidgets('no celular, o menu abre sem item ativo', (tester) async {
    await pump(tester, '/natureza-meio-ambiente/nao-existe', width: 390);

    await tester.tap(find.bySemanticsLabel(RegExp('menu', caseSensitive: false)).first);
    await tester.pumpAndSettle();

    expect(tester.widget<NavbarMobileMenu>(find.byType(NavbarMobileMenu)).location.section, isNull);
  });

  for (final width in [390.0, 768.0, 1280.0]) {
    testWidgets('sem overflow em ${width.toInt()}, inclusive com endereço muito longo', (
      tester,
    ) async {
      await pump(tester, '/${'a' * 300}', width: width, height: 900);

      expect(find.text('Este lugar não está no mapa'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
