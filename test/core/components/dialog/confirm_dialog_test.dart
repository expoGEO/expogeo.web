import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<List<bool>> pump(WidgetTester tester, FocusNode opener) async {
    final results = <bool>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) => AppButton.primary(
                text: 'Excluir objeto',
                focusNode: opener,
                onPressed: () async {
                  results.add(
                    await showConfirmDialog(
                      context,
                      title: 'Confirmar Exclusão',
                      message: 'Tem certeza?',
                      confirmText: 'Deletar',
                      destructive: true,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    return results;
  }

  FocusNode focusedNode() => FocusManager.instance.primaryFocus!;

  testWidgets('abre com foco em "Cancelar" e a ação de perigo', (tester) async {
    final opener = FocusNode();
    addTearDown(opener.dispose);
    await pump(tester, opener);

    await tester.tap(find.text('Excluir objeto'));
    await tester.pumpAndSettle();

    final cancel = tester.widget<AppButton>(find.widgetWithText(AppButton, 'Cancelar'));
    expect(cancel.focusNode!.hasFocus, isTrue);
    final confirm = tester.widget<AppButton>(find.widgetWithText(AppButton, 'Deletar'));
    expect(confirm.kind, AppButtonKind.danger);
  });

  testWidgets('Esc devolve false e o foco volta ao botão que abriu', (tester) async {
    final opener = FocusNode();
    addTearDown(opener.dispose);
    final results = await pump(tester, opener);

    opener.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Confirmar Exclusão'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Confirmar Exclusão'), findsNothing);
    expect(results, [false]);
    expect(focusedNode(), opener);
  });

  testWidgets('clique fora devolve false; confirmar devolve true', (tester) async {
    final opener = FocusNode();
    addTearDown(opener.dispose);
    final results = await pump(tester, opener);

    await tester.tap(find.text('Excluir objeto'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Excluir objeto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deletar'));
    await tester.pumpAndSettle();

    expect(results, [false, true]);
  });
}
