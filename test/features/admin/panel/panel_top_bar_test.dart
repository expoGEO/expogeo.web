import 'package:expogeo/core/components/button/app_icon_button.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/fake_url_launcher.dart';

void main() {
  Future<void> pump(WidgetTester tester, double width, {String email = 'ana.souza@exemplo.org'}) {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final focus = FocusNode();
    addTearDown(focus.dispose);
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PanelTopBar(
            email: email,
            showMenuButton: width < 900,
            isMenuOpen: false,
            onMenuPressed: () {},
            menuFocusNode: focus,
            onBrandPressed: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('390: menu, só o símbolo e as iniciais', (tester) async {
    await pump(tester, 390);

    expect(find.byType(AppIconButton), findsOneWidget);
    expect(find.bySemanticsLabel('Abrir menu do painel'), findsOneWidget);
    expect(find.text('Painel'), findsNothing);
    expect(find.text('Ver site'), findsNothing);
    expect(find.text('AS'), findsOneWidget);
    expect(find.text('ana.souza@exemplo.org'), findsNothing);
    expect(find.bySemanticsLabel('Conectado como ana.souza@exemplo.org'), findsOneWidget);
  });

  testWidgets('768: menu, marca completa, "Ver site" e iniciais sem e-mail', (tester) async {
    await pump(tester, 768);

    expect(find.byType(AppIconButton), findsOneWidget);
    expect(find.text('Painel'), findsOneWidget);
    expect(find.text('Ver site'), findsOneWidget);
    expect(find.text('ana.souza@exemplo.org'), findsNothing);
  });

  testWidgets('1280: sem menu, com o e-mail', (tester) async {
    await pump(tester, 1280);

    expect(find.byType(AppIconButton), findsNothing);
    expect(find.text('Ver site'), findsOneWidget);
    expect(find.text('ana.souza@exemplo.org'), findsOneWidget);
  });

  testWidgets('e-mail de 80 caracteres não estoura a barra', (tester) async {
    final email = '${'a' * 68}@exemplo.org';
    expect(email.length, 80);
    for (final width in [390.0, 768.0, 1280.0]) {
      await pump(tester, width, email: email);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('"Ver site" abre a Home em aba nova', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester, 1280);

    expect(find.bySemanticsLabel('Ver site, abre em nova aba'), findsOneWidget);
    await tester.tap(find.text('Ver site'));
    await tester.pump();

    expect(opened, hasLength(1));
    expect(Uri.parse(opened.single).path, '/');
  });
}
