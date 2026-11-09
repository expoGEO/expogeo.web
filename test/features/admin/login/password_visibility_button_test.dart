import 'package:expogeo/features/admin/login/presentation/components/password_visibility_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, {required bool visible, VoidCallback? onPressed}) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PasswordVisibilityButton(visible: visible, onPressed: onPressed ?? () {}),
          ),
        ),
      ),
    );
  }

  testWidgets('nome e estado seguem a senha visível ou não', (tester) async {
    await pump(tester, visible: false);
    var data = tester.getSemantics(find.bySemanticsLabel('Mostrar senha')).getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.hasToggledState, isTrue);
    expect(data.flagsCollection.isToggled, isFalse);

    await pump(tester, visible: true);
    data = tester.getSemantics(find.bySemanticsLabel('Esconder senha')).getSemanticsData();
    expect(data.flagsCollection.isToggled, isTrue);
  });

  testWidgets('clique, Enter e Espaço acionam', (tester) async {
    var presses = 0;
    await pump(tester, visible: false, onPressed: () => presses++);

    await tester.tap(find.byType(PasswordVisibilityButton));
    expect(presses, 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(presses, 3);
  });

  testWidgets('um só nó focável, com alvo de 44 px', (tester) async {
    await pump(tester, visible: false);

    final focusable = find.descendant(
      of: find.byType(PasswordVisibilityButton),
      matching: find.byWidgetPredicate(
        (widget) => widget is Focus && widget.canRequestFocus != false && !widget.skipTraversal,
      ),
    );
    expect(focusable, findsOneWidget);
    expect(tester.getSize(find.byType(InkWell)), const Size.square(44));
  });
}
