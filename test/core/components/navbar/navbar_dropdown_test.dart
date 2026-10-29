import 'package:expogeo/core/components/structure/navbar/navbar_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpMenu(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: NavbarDropdown(
              label: 'Temas',
              menuBuilder: (context, close) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(onPressed: close, child: const Text('Primeira')),
                  TextButton(onPressed: close, child: const Text('Segunda')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FocusNode? focused() => FocusManager.instance.primaryFocus;

  bool focusIsOn(WidgetTester tester, String text) {
    final node = focused();
    if (node?.context == null) return false;
    return find
        .descendant(of: find.byWidget(node!.context!.widget), matching: find.text(text))
        .evaluate()
        .isNotEmpty;
  }

  testWidgets('seta para baixo abre e foca a primeira opção; Esc fecha e devolve o foco', (
    tester,
  ) async {
    await pumpMenu(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(focusIsOn(tester, 'Temas'), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(find.text('Primeira'), findsOneWidget);
    expect(focusIsOn(tester, 'Primeira'), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(focusIsOn(tester, 'Segunda'), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Primeira'), findsNothing);
    expect(focusIsOn(tester, 'Temas'), isTrue);
  });

  testWidgets('Enter também abre o menu', (tester) async {
    await pumpMenu(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.text('Primeira'), findsOneWidget);
  });
}
