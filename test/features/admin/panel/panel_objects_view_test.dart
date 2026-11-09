import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/button/primary_button.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'panel_harness.dart';

void main() {
  testWidgets('tema e subtema do endereço chegam escolhidos e ativam "Novo Conteúdo"', (
    tester,
  ) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/objetos?tema=natureza-meio-ambiente&subtema=biomas');
    await panel.loadCatalog(tester);

    expect(find.text('Natureza e Meio Ambiente'), findsWidgets);
    expect(panel.contentStore.selectedTheme, ThemeEnum.naturezaMeioAmbiente);
    expect(panel.contentStore.selectedSubtheme, SubthemeEnum.biomas);
    expect(panel.content.calls, ['subtheme:biomas']);
    expect(find.text('Biomas'), findsWidgets);
    final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(button.isDisabled, isFalse);
  });

  testWidgets('sem tema, o título é "Objetos digitais"; valores desconhecidos são ignorados', (
    tester,
  ) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/objetos?tema=xyz&subtema=biomas');
    await panel.loadCatalog(tester);

    expect(find.text('Objetos digitais'), findsWidgets);
    expect(panel.contentStore.selectedTheme, isNull);
    expect(panel.content.calls, isEmpty);
  });

  testWidgets('excluir abre a confirmação com foco em "Cancelar" e os textos de hoje', (
    tester,
  ) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/objetos?tema=natureza-meio-ambiente&subtema=biomas');
    await panel.loadCatalog(tester);

    await tester.ensureVisible(find.byIcon(Icons.delete_outline));
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Confirmar Exclusão'), findsOneWidget);
    expect(find.textContaining('Tem certeza que deseja deletar o conteúdo'), findsOneWidget);
    final cancel = tester.widget<AppButton>(find.widgetWithText(AppButton, 'Cancelar'));
    expect(cancel.focusNode!.hasFocus, isTrue);

    await tester.tap(find.text('Deletar'));
    await tester.pumpAndSettle();
    expect(panel.content.calls, contains('delete'));
    expect(panel.contentStore.savedCount, 1);
  });
}
