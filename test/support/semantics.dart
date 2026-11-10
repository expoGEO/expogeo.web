// ignore_for_file: deprecated_member_use
// O SDK fixado ainda usa `containsSemantics`; o substituto `isSemantics` não existe nele.

import 'package:flutter_test/flutter_test.dart';

/// Confere que o texto encontrado é um título do nível dado.
void expectHeading(WidgetTester tester, Finder finder, int level) {
  final data = tester.getSemantics(finder).getSemanticsData();
  expect(data.flagsCollection.isHeader, isTrue);
  expect(data.headingLevel, level);
}

// Se o SDK trocar `isFocused` e `isSelected` de `flagsCollection` por `Tristate` e tirar
// `isFocusable`, só estes matchers mudam.

/// Diz se o nó (ou seus dados) de semântica está com o foco.
bool hasFocus(Object semantics) => containsSemantics(isFocused: true).matches(semantics, {});

/// Diz se o nó (ou seus dados) de semântica pode receber foco.
bool canFocus(Object semantics) => containsSemantics(isFocusable: true).matches(semantics, {});

/// Diz se o nó (ou seus dados) de semântica está marcado como selecionado.
bool isMarked(Object semantics) => containsSemantics(isSelected: true).matches(semantics, {});

/// Diz se o nó (ou seus dados) declara estado de habilitado e se está habilitado.
bool isEnabledAs(Object semantics, bool enabled) =>
    containsSemantics(hasEnabledState: true, isEnabled: enabled).matches(semantics, {});

/// Diz se o nó (ou seus dados) declara estado de ligado/desligado e se está ligado.
bool isToggledAs(Object semantics, bool toggled) =>
    containsSemantics(hasToggledState: true, isToggled: toggled).matches(semantics, {});

/// Diz se o nó (ou seus dados) declara estado de expandido e se está expandido.
bool isExpandedAs(Object semantics, bool expanded) =>
    containsSemantics(hasExpandedState: true, isExpanded: expanded).matches(semantics, {});
