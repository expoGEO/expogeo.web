import 'package:expogeo/core/components/form/form_error_alert.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<Map<Object?, Object?>> announcements;

  setUp(() => announcements = []);

  Future<void> pump(WidgetTester tester, String message) {
    tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(
      SystemChannels.accessibility,
      (message) async {
        announcements.add(message! as Map<Object?, Object?>);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(
        SystemChannels.accessibility,
        null,
      ),
    );
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FormErrorAlert(message: message)),
      ),
    );
  }

  List<Object?> announced() => [
    for (final item in announcements) (item['data']! as Map<Object?, Object?>)['message'],
  ];

  testWidgets('texto e ícone na cor de erro, sobre o fundo de erro', (tester) async {
    await pump(tester, 'Algo deu errado.');

    final text = tester.widget<Text>(find.text('Algo deu errado.'));
    expect(text.style?.color, AppTheme.colors.error);
    expect(tester.widget<Icon>(find.byIcon(Icons.error_outline)).color, AppTheme.colors.error);
    final box = tester.widget<DecoratedBox>(
      find.ancestor(of: find.text('Algo deu errado.'), matching: find.byType(DecoratedBox)).first,
    );
    expect((box.decoration as BoxDecoration).color, AppTheme.colors.errorSurface);
  });

  testWidgets('anuncia ao aparecer, com urgência', (tester) async {
    await pump(tester, 'Algo deu errado.');
    await tester.pump();

    expect(announced(), ['Algo deu errado.']);
    final data = announcements.single['data']! as Map<Object?, Object?>;
    expect(data['assertiveness'], Assertiveness.assertive.index);
  });

  testWidgets('um anúncio por mensagem: só volta a anunciar quando o texto muda', (tester) async {
    await pump(tester, 'Primeira.');
    await tester.pump();
    await pump(tester, 'Primeira.');
    await tester.pump();
    expect(announced(), ['Primeira.']);

    await pump(tester, 'Segunda.');
    await tester.pump();
    expect(announced(), ['Primeira.', 'Segunda.']);
  });
}
