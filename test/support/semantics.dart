import 'package:flutter_test/flutter_test.dart';

/// Confere que o texto encontrado é um título do nível dado.
void expectHeading(WidgetTester tester, Finder finder, int level) {
  final data = tester.getSemantics(finder).getSemanticsData();
  expect(data.flagsCollection.isHeader, isTrue);
  expect(data.headingLevel, level);
}

// Em versões novas do Flutter, `isFocused` e `isSelected` de `flagsCollection` viram `Tristate`
// e `isFocusable` sai; o matcher tem a mesma forma em todas.

/// Diz se o nó (ou seus dados) de semântica está com o foco.
bool hasFocus(Object semantics) => containsSemantics(isFocused: true).matches(semantics, {});

/// Diz se o nó (ou seus dados) de semântica pode receber foco.
bool canFocus(Object semantics) => containsSemantics(isFocusable: true).matches(semantics, {});

/// Diz se o nó (ou seus dados) de semântica está marcado como selecionado.
bool isMarked(Object semantics) => containsSemantics(isSelected: true).matches(semantics, {});
