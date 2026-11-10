import 'package:expogeo/core/components/button/app_icon_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget button, {VoidCallback? onOuterEscape}) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Focus(
            canRequestFocus: false,
            skipTraversal: true,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
                onOuterEscape?.call();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: Center(child: button),
          ),
        ),
      ),
    );
  }

  AppIconButton button({VoidCallback? onPressed, bool disabled = false}) => AppIconButton(
    icon: Icons.delete_outline,
    color: Colors.black,
    label: 'Excluir',
    tooltip: 'Excluir: pede confirmação antes de apagar',
    isDisabled: disabled,
    onPressed: onPressed ?? () {},
  );

  testWidgets('tem nome e dica acessíveis', (tester) async {
    await pump(tester, button());

    final data = tester.getSemantics(find.byType(AppIconButton)).getSemanticsData();
    expect(data.label, 'Excluir');
    expect(data.tooltip, 'Excluir: pede confirmação antes de apagar');
  });

  testWidgets('a dica aparece no hover', (tester) async {
    await pump(tester, button());

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.byType(IconButton)));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Excluir: pede confirmação antes de apagar'), findsOneWidget);
  });

  // Com leitor de tela a dica fica só no nome, e os testes ligam a semântica por padrão.
  testWidgets('a dica aparece no foco por Tab e Esc fecha só ela', (tester) async {
    var outerEscapes = 0;
    await pump(tester, button(), onOuterEscape: () => outerEscapes++);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Excluir: pede confirmação antes de apagar'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump(const Duration(milliseconds: 200));
    expect(outerEscapes, 0);
    expect(find.text('Excluir: pede confirmação antes de apagar'), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(outerEscapes, 1);
  }, semanticsEnabled: false);

  testWidgets('com o Tab seguro, só fica aberta a dica do botão com foco', (tester) async {
    await pump(
      tester,
      const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconButton(
            icon: Icons.edit_outlined,
            color: Colors.black,
            tooltip: 'Editar a ficha',
            onPressed: _noop,
          ),
          AppIconButton(
            icon: Icons.delete_outline,
            color: Colors.black,
            tooltip: 'Excluir o objeto',
            onPressed: _noop,
          ),
        ],
      ),
    );

    // Dois Tabs no mesmo quadro: o primeiro botão perde o foco antes de a dica dele abrir.
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Editar a ficha'), findsNothing);
    expect(find.text('Excluir o objeto'), findsOneWidget);
  }, semanticsEnabled: false);

  testWidgets('desativado continua focável e não age', (tester) async {
    var taps = 0;
    await pump(tester, button(disabled: true, onPressed: () => taps++));

    await tester.tap(find.byType(IconButton));
    expect(taps, 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final iconButton = tester.widget<IconButton>(find.byType(IconButton));
    expect(iconButton.focusNode!.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(taps, 0);
  });
}

void _noop() {}
