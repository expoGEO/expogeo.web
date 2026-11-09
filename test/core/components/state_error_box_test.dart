import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/state/state_error_box.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, VoidCallback onRetry) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: StateErrorBox(title: 'Não conseguimos carregar o objeto', onRetry: onRetry),
          ),
        ),
      ),
    );
  }

  testWidgets('título, texto padrão e ícone de alerta no tom de erro', (tester) async {
    await pump(tester, () {});

    expect(find.text('Não conseguimos carregar o objeto'), findsOneWidget);
    expect(find.text('Confira sua conexão com a internet e tente de novo.'), findsOneWidget);
    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.icon, Icons.error_outline);
    expect(icon.color, AppTheme.colors.error);
  });

  testWidgets('"Tentar de novo" é primário e chama a nova tentativa', (tester) async {
    var calls = 0;
    await pump(tester, () => calls++);

    final button = tester.widget<AppButton>(find.byType(AppButton));
    expect(button.kind, AppButtonKind.primary);
    await tester.tap(find.text('Tentar de novo'));
    expect(calls, 1);
  });

  testWidgets('papel de alerta', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, () {});

    final node = tester.getSemantics(find.text('Não conseguimos carregar o objeto')).parent!;
    expect(node.getSemanticsData().role, SemanticsRole.alert);
    handle.dispose();
  });
}
