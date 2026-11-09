import 'package:expogeo/core/components/button/app_icon_button.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_sidebar.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_top_bar.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/panel_shell.dart';
import 'package:expogeo/features/admin/panel/presentation/pages/panel_objects_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../support/fake_content.dart';
import 'panel_harness.dart';

void main() {
  const mobile = Size(390, 800);

  Finder menuButton() =>
      find.descendant(of: find.byType(PanelTopBar), matching: find.byType(AppIconButton));

  FocusNode menuFocus(WidgetTester tester) => tester
      .widget<IconButton>(find.descendant(of: menuButton(), matching: find.byType(IconButton)))
      .focusNode!;

  testWidgets('/admin/painel leva a objetos, com menu fixo em 1280', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel');
    await panel.loadCatalog(tester);

    expect(panel.location, '/admin/painel/objetos');
    expect(find.byType(PanelSidebar), findsOneWidget);
    expect(find.bySemanticsLabel('Seções do painel'), findsOneWidget);
    expect(find.bySemanticsLabel('Abrir menu do painel'), findsNothing);
    expect(find.bySemanticsLabel('Conectado como $panelEmail'), findsOneWidget);
    expect(find.text(panelEmail), findsOneWidget);
  });

  testWidgets('a gaveta abre pelo botão e fecha ao tocar fora, com o foco de volta', (
    tester,
  ) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/temas', size: mobile);
    await panel.loadCatalog(tester);
    expect(find.byType(PanelSidebar), findsNothing);

    final closed = tester.getSemantics(menuButton()).getSemanticsData();
    expect(closed.label, 'Abrir menu do painel');
    expect(closed.flagsCollection.hasExpandedState, isTrue);
    expect(closed.flagsCollection.isExpanded, isFalse);

    await tester.tap(find.bySemanticsLabel('Abrir menu do painel'));
    await tester.pumpAndSettle();
    expect(find.byType(PanelSidebar), findsOneWidget);
    final open = tester.widget<AppIconButton>(menuButton());
    expect(open.isExpanded, isTrue);
    expect(open.tooltip, 'Fechar menu do painel');

    await tester.tapAt(const Offset(380, 400));
    await tester.pumpAndSettle();
    expect(find.byType(PanelSidebar), findsNothing);
    expect(menuFocus(tester).hasFocus, isTrue);
  });

  testWidgets('Esc fecha a gaveta', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/objetos', size: mobile);
    await panel.loadCatalog(tester);

    await tester.tap(find.bySemanticsLabel('Abrir menu do painel'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.byType(PanelSidebar), findsNothing);
    expect(menuFocus(tester).hasFocus, isTrue);
  });

  testWidgets('escolher na gaveta navega e fecha; no celular, "Ver site" fica no pé', (
    tester,
  ) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/objetos', size: mobile);
    await panel.loadCatalog(tester);

    await tester.tap(find.bySemanticsLabel('Abrir menu do painel'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Ver site, abre em nova aba'), findsOneWidget);

    await tester.tap(find.text('Temas e subtemas'));
    await tester.pumpAndSettle();

    expect(panel.location, '/admin/painel/temas');
    expect(find.byType(PanelSidebar), findsNothing);
  });

  testWidgets('recarrega o catálogo ao abrir e depois de cada gravação', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/objetos');
    expect(panel.catalog.calls, 1);
    await panel.loadCatalog(tester);

    await panel.contentStore.createContent(subtheme: SubthemeEnum.biomas, content: sampleContent());
    await tester.pump();
    expect(panel.catalog.calls, 2);
    await panel.loadCatalog(tester);
  });

  testWidgets('falha ao sair mostra o aviso curto; sair volta ao login', (tester) async {
    final panel = PanelHarness();
    panel.auth.failLogout = true;
    await panel.pump(tester, '/admin/painel/objetos');
    await panel.loadCatalog(tester);

    await tester.tap(find.text('Sair'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Não deu para sair. Tente de novo.'), findsOneWidget);

    panel.auth.failLogout = false;
    panel.auth.current = null;
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    // O redirecionamento assíncrono do roteador só termina com tempo real.
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    expect(panel.location, '/admin');
    expect(find.byType(PanelShell), findsNothing);
  });

  testWidgets('escolher um tema no menu muda o endereço e a área de objetos', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/objetos');
    await panel.loadCatalog(tester);

    await tester.tap(find.text('Cultura e Política'));
    await tester.pumpAndSettle();

    expect(panel.location, '/admin/painel/objetos?tema=cultura-politica');
    final view = tester.widget<PanelObjectsView>(find.byType(PanelObjectsView));
    expect(view.selection.theme, ThemeEnum.culturaPolitica);
  });

  testWidgets('sem sessão, as vistas voltam ao login', (tester) async {
    for (final path in ['/admin/painel/temas', '/admin/painel/objetos?tema=cultura-politica']) {
      final panel = PanelHarness();
      await panel.pump(tester, path, logged: false);
      await tester.pumpAndSettle();
      expect(panel.location, '/admin');
      await GetIt.I.reset();
    }
  });

  testWidgets('outro endereço do painel com sessão mostra a página não encontrada', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/xyz');
    await tester.pumpAndSettle();

    expect(find.byType(NotFoundPage), findsOneWidget);
    expect(find.byType(PanelSidebar), findsNothing);
  });
}
