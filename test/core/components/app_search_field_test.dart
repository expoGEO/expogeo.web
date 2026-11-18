import 'package:expogeo/core/components/field/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController controller;
  late FocusNode focusNode;
  late List<String> changes;
  late int clears;

  setUp(() {
    controller = TextEditingController();
    focusNode = FocusNode();
    changes = [];
    clears = 0;
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
  });

  Future<void> pump(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchField(
            controller: controller,
            focusNode: focusNode,
            hint: 'Buscar por título',
            semanticLabel: 'Buscar neste subtema',
            onChanged: changes.add,
            onClear: () => clears++,
          ),
        ),
      ),
    );
  }

  testWidgets('avisa a cada caractere, sem espera', (tester) async {
    await pump(tester);

    await tester.enterText(find.byType(TextField), 'm');
    await tester.enterText(find.byType(TextField), 'ma');

    expect(changes, ['m', 'ma']);
  });

  testWidgets('Enter mantém o foco no campo', (tester) async {
    await pump(tester);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('"Limpar" só aparece com texto', (tester) async {
    await pump(tester);
    expect(find.text('Limpar'), findsNothing);

    await tester.enterText(find.byType(TextField), 'mapa');
    await tester.pump();
    expect(find.text('Limpar'), findsOneWidget);
    expect(find.bySemanticsLabel('Limpar busca'), findsOneWidget);
  });

  testWidgets('"Limpar" apaga, avisa e devolve o foco ao campo', (tester) async {
    await pump(tester);
    await tester.enterText(find.byType(TextField), 'mapa');
    await tester.pump();
    focusNode.unfocus();
    await tester.pump();

    await tester.tap(find.text('Limpar'));
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(clears, 1);
    expect(focusNode.hasFocus, isTrue);
    expect(find.text('Limpar'), findsNothing);
  });

  testWidgets('o campo tem rótulo próprio na leitura de tela', (tester) async {
    await pump(tester);

    expect(find.bySemanticsLabel(RegExp('Buscar neste subtema')), findsOneWidget);
  });

  testWidgets('altura de 48 e sem overflow em largura pequena', (tester) async {
    tester.view.physicalSize = const Size(200, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pump(tester);

    expect(tester.getSize(find.byType(AppSearchField)).height, 48);
    expect(tester.takeException(), isNull);
  });
}
