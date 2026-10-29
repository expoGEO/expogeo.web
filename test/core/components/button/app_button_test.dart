import 'package:expogeo/core/components/button/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget button) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(child: button)),
      ),
    );
  }

  testWidgets('desativado não responde ao toque e reduz a opacidade', (tester) async {
    var taps = 0;
    await pump(
      tester,
      AppButton.primary(text: 'Enviar', isDisabled: true, onPressed: () => taps++),
    );

    await tester.tap(find.text('Enviar'));
    expect(taps, 0);

    final opacity = tester.widget<Opacity>(
      find.ancestor(of: find.text('Enviar'), matching: find.byType(Opacity)),
    );
    expect(opacity.opacity, lessThan(1));
    expect(tester.getSemantics(find.byType(AppButton)), isNot(matchesSemantics(isEnabled: true)));
  });

  testWidgets('ativo responde ao toque', (tester) async {
    var taps = 0;
    await pump(tester, AppButton.secondary(text: 'Enviar', onPressed: () => taps++));

    await tester.tap(find.text('Enviar'));
    expect(taps, 1);
  });

  testWidgets('link externo avisa a nova aba no nome acessível', (tester) async {
    await pump(
      tester,
      const AppButton.ghost(text: 'Observatório', externalUrl: 'https://example.com'),
    );

    expect(find.bySemanticsLabel('Observatório, abre em nova aba'), findsOneWidget);
  });
}
