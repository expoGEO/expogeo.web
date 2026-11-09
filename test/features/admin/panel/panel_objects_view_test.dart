import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/button/primary_button.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/presentation/components/theme_subtheme_selector.dart';
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

  testWidgets('escolher no seletor mantém o seletor e o foco do teclado nele', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/objetos');
    await panel.loadCatalog(tester);

    final before = tester.state(find.byType(ThemeSubthemeSelector));
    Focus.of(tester.element(find.text('Selecione um tema'))).requestFocus();
    await tester.pump();

    await tester.tap(find.text('Selecione um tema'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Natureza e Meio Ambiente').last);
    await tester.pumpAndSettle();

    expect(panel.contentStore.selectedTheme, ThemeEnum.naturezaMeioAmbiente);
    expect(tester.state(find.byType(ThemeSubthemeSelector)), same(before));
    final themeField = find.byType(DropdownButtonFormField<String>).first;
    final focusedInThemeField = find.descendant(
      of: themeField,
      matching: find.byWidgetPredicate(
        (widget) => widget is Focus && (widget.focusNode?.hasPrimaryFocus ?? false),
      ),
    );
    expect(focusedInThemeField, findsOneWidget);
  });
}
