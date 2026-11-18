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

  testWidgets('carregando ignora o toque e mostra o indicador antes do texto', (tester) async {
    var taps = 0;
    await pump(
      tester,
      AppButton.primary(text: 'Entrando…', isLoading: true, onPressed: () => taps++),
    );

    await tester.tap(find.text('Entrando…'));
    expect(taps, 0);

    final spinner = find.byType(CircularProgressIndicator);
    expect(spinner, findsOneWidget);
    expect(tester.getCenter(spinner).dx, lessThan(tester.getTopLeft(find.text('Entrando…')).dx));
  });

  testWidgets('carregando é lido como desativado, sem esmaecer o botão', (tester) async {
    await pump(tester, AppButton.primary(text: 'Entrando…', isLoading: true, onPressed: () {}));

    expect(tester.getSemantics(find.byType(AppButton)), isNot(matchesSemantics(isEnabled: true)));
    final opacity = tester.widget<Opacity>(
      find.ancestor(of: find.text('Entrando…'), matching: find.byType(Opacity)),
    );
    expect(opacity.opacity, 1);
  });

  testWidgets('sem isLoading nada muda: sem indicador e com toque', (tester) async {
    var taps = 0;
    await pump(tester, AppButton.primary(text: 'Entrar', onPressed: () => taps++));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.text('Entrar'));
    expect(taps, 1);
    expect(
      tester.getSemantics(find.byType(AppButton)),
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
        label: 'Entrar',
      ),
    );
  });

  testWidgets('a altura não muda ao começar a carregar', (tester) async {
    await pump(tester, AppButton.primary(text: 'Entrar', onPressed: () {}));
    final before = tester.getSize(find.byType(AppButton)).height;

    await pump(tester, AppButton.primary(text: 'Entrando…', isLoading: true, onPressed: () {}));
    expect(tester.getSize(find.byType(AppButton)).height, before);
  });
}
