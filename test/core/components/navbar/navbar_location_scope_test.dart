import 'package:expogeo/core/components/structure/navbar/navbar_dropdown.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_location.dart';
import 'package:expogeo/core/components/structure/navbar/navbar_mobile_menu.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Future<void> pump(WidgetTester tester, {required bool scoped, required double width}) {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    const page = SiteScaffold(slivers: [SliverToBoxAdapter(child: SizedBox(height: 200))]);
    final router = GoRouter(
      initialLocation: '/natureza-meio-ambiente/nao-existe',
      routes: [
        GoRoute(
          path: '/natureza-meio-ambiente/:subthemeId',
          builder: (context, state) => scoped ? const NavbarLocationScope.none(child: page) : page,
        ),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  bool themesActive(WidgetTester tester) =>
      tester.widget<NavbarDropdown>(find.byType(NavbarDropdown)).isActive;

  testWidgets('dentro do escopo vazio, nenhum item ativo na navbar larga', (tester) async {
    await pump(tester, scoped: true, width: 1280);

    expect(themesActive(tester), isFalse);
  });

  testWidgets('fora do escopo, "Temas" continua ativo em endereço de tema', (tester) async {
    await pump(tester, scoped: false, width: 1280);

    expect(themesActive(tester), isTrue);
  });

  for (final (scoped, expected) in [(true, null), (false, NavbarSection.themes)]) {
    testWidgets('menu do celular ${scoped ? 'sem' : 'com'} item ativo', (tester) async {
      await pump(tester, scoped: scoped, width: 390);

      await tester.tap(find.bySemanticsLabel(RegExp('menu', caseSensitive: false)).first);
      await tester.pumpAndSettle();

      final menu = tester.widget<NavbarMobileMenu>(find.byType(NavbarMobileMenu));
      expect(menu.location.section, expected);
    });
  }
}
