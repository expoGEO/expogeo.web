import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/gestures.dart';
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

  testWidgets('nome acessível próprio substitui o texto', (tester) async {
    await pump(
      tester,
      AppButton.ghost(text: 'Biomas', semanticLabel: 'Voltar para Biomas', onPressed: () {}),
    );

    expect(find.bySemanticsLabel('Voltar para Biomas'), findsOneWidget);
    expect(find.bySemanticsLabel('Biomas'), findsNothing);
  });

  testWidgets('nome acessível próprio mantém o aviso de nova aba', (tester) async {
    await pump(
      tester,
      const AppButton.secondary(
        text: 'Acessar',
        semanticLabel: 'Acessar o mapa',
        externalUrl: 'https://example.com',
      ),
    );

    expect(find.bySemanticsLabel('Acessar o mapa, abre em nova aba'), findsOneWidget);
  });

  group('hover', () {
    Future<(Color?, Color?)> colorsOnHover(
      WidgetTester tester,
      Widget button, {
      required bool hover,
    }) async {
      await pump(tester, button);
      if (hover) {
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);
        await mouse.moveTo(tester.getCenter(find.byType(AppButton)));
        await tester.pump();
      }
      final material = tester.widget<Material>(
        find.descendant(of: find.byType(AppButton), matching: find.byType(Material)),
      );
      final text = tester.widget<Text>(find.text('Enviar'));
      return (material.color, text.style?.color);
    }

    final colors = AppTheme.colors;

    testWidgets('primário escurece o fundo', (tester) async {
      final button = AppButton.primary(text: 'Enviar', onPressed: () {});
      expect((await colorsOnHover(tester, button, hover: false)).$1, colors.accent);
      expect((await colorsOnHover(tester, button, hover: true)).$1, colors.accentStrong);
    });

    testWidgets('secundário inverte fundo e texto', (tester) async {
      final button = AppButton.secondary(text: 'Enviar', onPressed: () {});
      expect(await colorsOnHover(tester, button, hover: false), (Colors.transparent, colors.ink));
      expect(await colorsOnHover(tester, button, hover: true), (colors.ink, colors.white));
    });

    testWidgets('discreto ganha fundo suave', (tester) async {
      final button = AppButton.ghost(text: 'Enviar', onPressed: () {});
      expect(await colorsOnHover(tester, button, hover: false), (
        Colors.transparent,
        colors.accentStrong,
      ));
      expect(await colorsOnHover(tester, button, hover: true), (
        colors.accentSoft,
        colors.accentStrong,
      ));
    });

    testWidgets('desativado não muda no hover', (tester) async {
      final button = AppButton.primary(text: 'Enviar', isDisabled: true, onPressed: () {});
      expect((await colorsOnHover(tester, button, hover: true)).$1, colors.accent);
    });
  });
}
