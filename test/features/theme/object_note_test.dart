import 'package:expogeo/features/theme/components/object_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, String text) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: ObjectNote(text: text)),
    ),
  );

  testWidgets('mostra o rótulo e o texto', (tester) async {
    await pump(tester, 'Atenção ao contexto');

    expect(find.text('NOTA DE CONTEÚDO'), findsOneWidget);
    expect(find.text('Atenção ao contexto'), findsOneWidget);
  });

  testWidgets('o rótulo não é cabeçalho', (tester) async {
    await pump(tester, 'Atenção ao contexto');

    final data = tester.getSemantics(find.bySemanticsLabel('Nota de conteúdo')).getSemanticsData();
    expect(data.flagsCollection.isHeader, isFalse);
  });

  for (final text in ['', '   ']) {
    testWidgets('vazio ("$text") não mostra nada', (tester) async {
      await pump(tester, text);

      expect(find.text('NOTA DE CONTEÚDO'), findsNothing);
    });
  }
}
