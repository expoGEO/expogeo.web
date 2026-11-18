import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/messenger/messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<Object?> announced;

  Future<BuildContext> pump(WidgetTester tester) async {
    announced = [];
    tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(
      SystemChannels.accessibility,
      (message) async {
        final data = (message! as Map<Object?, Object?>)['data']! as Map<Object?, Object?>;
        announced.add(data['message']);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(
        SystemChannels.accessibility,
        null,
      ),
    );

    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (inner) {
              context = inner;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    return context;
  }

  testWidgets('sucesso em fundo escuro, com o texto e o anúncio', (tester) async {
    final context = await pump(tester);

    Messenger.showSuccess(context, 'Alterações salvas');
    await tester.pumpAndSettle();

    expect(find.text('Alterações salvas'), findsOneWidget);
    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, AppTheme.colors.ink);
    expect(snackBar.behavior, SnackBarBehavior.floating);
    expect(snackBar.width, lessThanOrEqualTo(AppTheme.dimensions.components.toastMaxWidth));
    final icon = tester.widget<Icon>(find.byIcon(Icons.check_circle_outline));
    expect(icon.color, AppTheme.colors.toastIcon);
    expect(announced, ['Alterações salvas']);
  });

  testWidgets('erro na cor de erro, com fechar', (tester) async {
    final context = await pump(tester);

    Messenger.showError(context, 'Não deu para sair. Tente de novo.');
    await tester.pumpAndSettle();

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, AppTheme.colors.error);
    expect(snackBar.showCloseIcon, isTrue);
    expect(announced, ['Não deu para sair. Tente de novo.']);
  });

  testWidgets('o segundo aviso substitui o primeiro', (tester) async {
    final context = await pump(tester);

    Messenger.showInfo(context, 'Primeiro');
    await tester.pumpAndSettle();
    Messenger.showInfo(context, 'Segundo');
    await tester.pumpAndSettle();

    expect(find.text('Primeiro'), findsNothing);
    expect(find.text('Segundo'), findsOneWidget);
  });
}
