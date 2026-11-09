import 'package:expogeo/core/components/field/app_filter_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const options = [
    AppFilterOption<String?>(null, 'Todos os tipos'),
    AppFilterOption<String?>('site', 'Site'),
    AppFilterOption<String?>('video', 'Vídeo'),
  ];

  Future<List<String?>> pump(WidgetTester tester, {bool disabled = false, String? value}) async {
    final chosen = <String?>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppFilterSelect<String?>(
              semanticLabel: 'Tipo',
              options: options,
              value: value,
              isDisabled: disabled,
              onSelected: chosen.add,
            ),
          ),
        ),
      ),
    );
    return chosen;
  }

  testWidgets('mostra a opção escolhida, abre e escolhe outra', (tester) async {
    final chosen = await pump(tester);
    expect(find.text('Todos os tipos'), findsOneWidget);

    await tester.tap(find.text('Todos os tipos'));
    await tester.pumpAndSettle();
    expect(find.text('Vídeo'), findsOneWidget);

    await tester.tap(find.text('Vídeo'));
    await tester.pumpAndSettle();
    expect(chosen, ['video']);
    expect(find.text('Site'), findsNothing);
  });

  testWidgets('Esc fecha o menu e devolve o foco ao botão', (tester) async {
    await pump(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Vídeo'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Vídeo'), findsNothing);
    final data = tester.getSemantics(find.bySemanticsLabel('Tipo')).getSemanticsData();
    expect(data.flagsCollection.isFocused, isTrue);
  });

  testWidgets('nome e valor lidos pelo leitor de tela', (tester) async {
    await pump(tester, value: 'site');

    final data = tester.getSemantics(find.bySemanticsLabel('Tipo')).getSemanticsData();
    expect(data.label, 'Tipo');
    expect(data.value, 'Site');
    expect(data.flagsCollection.isButton, isTrue);
  });

  testWidgets('desativado não abre, fica fora do Tab e é lido como indisponível', (tester) async {
    await pump(tester, disabled: true);

    await tester.tap(find.text('Todos os tipos'));
    await tester.pumpAndSettle();
    expect(find.text('Vídeo'), findsNothing);

    final data = tester.getSemantics(find.bySemanticsLabel('Tipo')).getSemanticsData();
    expect(data.flagsCollection.hasEnabledState, isTrue);
    expect(data.flagsCollection.isEnabled, isFalse);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final after = tester.getSemantics(find.bySemanticsLabel('Tipo')).getSemanticsData();
    expect(after.flagsCollection.isFocused, isFalse);
  });
}
