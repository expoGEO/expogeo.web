import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/button/inline_link.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/features/contact/components/contact_form.dart';
import 'package:expogeo/features/contact/components/contact_info_card.dart';
import 'package:expogeo/features/contact/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/semantics.dart';

void main() {
  void setWidth(WidgetTester tester, double width) {
    tester.view.physicalSize = Size(width, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> pump(WidgetTester tester, double width) {
    setWidth(tester, width);
    final router = GoRouter(
      initialLocation: '/contato',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Text('página inicial')),
        GoRoute(path: '/contato', builder: (context, state) => const ContactPage()),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('migalhas, título h1 e texto de apoio', (tester) async {
    await pump(tester, 1280);

    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Contato'), findsWidgets);
    expectHeading(tester, find.text('Fale com a gente').first, 1);
    expect(
      find.text(
        'Sugira um conteúdo, avise sobre um link quebrado ou conte como você usa a expoGEO.',
      ),
      findsOneWidget,
    );
  });

  for (final width in [390.0, 768.0, 1280.0]) {
    testWidgets('sem exceção de layout em $width, vazio, com erros e na confirmação', (
      tester,
    ) async {
      await pump(tester, width);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Abrir no meu e-mail'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Ana ' * 80);
      await tester.enterText(fields.at(1), 'ana@exemplo.com');
      await tester.enterText(fields.at(2), 'Assunto ' * 80);
      await tester.enterText(fields.at(3), 'Mensagem ' * 400);
      await tester.pump();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Abrir no meu e-mail'));
      await tester.pumpAndSettle();
      expect(find.text('Seu e-mail está pronto'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('colunas lado a lado só no desktop', (tester) async {
    await pump(tester, 1280);
    final formLeft = tester.getTopLeft(find.byType(ContactForm));
    final infoLeft = tester.getTopLeft(find.byType(ContactInfoCard));
    expect(infoLeft.dx, greaterThan(formLeft.dx));
    expect(infoLeft.dy, formLeft.dy);
    expect(
      tester.getSize(find.byType(ContactForm)).width /
          tester.getSize(find.byType(ContactInfoCard)).width,
      closeTo(1.5, 0.01),
    );

    await pump(tester, 768);
    await tester.pump();
    expect(
      tester.getTopLeft(find.byType(ContactInfoCard)).dy,
      greaterThan(tester.getBottomLeft(find.byType(ContactForm)).dy),
    );
  });

  testWidgets('Tab percorre o formulário e depois "Outros meios", sem alternar colunas', (
    tester,
  ) async {
    await pump(tester, 1280);
    final fields = find.byType(TextField);
    await tester.tap(fields.first);
    await tester.pump();

    Future<void> tab() async {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
    }

    for (final index in [1, 2, 3]) {
      await tab();
      expect(tester.widget<TextField>(fields.at(index)).focusNode?.hasFocus, isTrue);
    }

    await tab();
    final button = FocusManager.instance.primaryFocus?.context
        ?.findAncestorWidgetOfExactType<AppButton>();
    expect(button?.text, 'Abrir no meu e-mail');

    await tab();
    final link = FocusManager.instance.primaryFocus?.context
        ?.findAncestorWidgetOfExactType<InlineLink>();
    expect(link?.url, AppLinks.emailUrl);

    await tab();
    final next = FocusManager.instance.primaryFocus?.context
        ?.findAncestorWidgetOfExactType<InlineLink>();
    expect(next?.url, AppLinks.observatory);
  });

  testWidgets('mudar a largura mantém o que foi digitado', (tester) async {
    await pump(tester, 768);
    await tester.enterText(find.byType(TextField).first, 'Ana');

    setWidth(tester, 1280);
    await tester.pump();

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text(AppLinks.email), findsWidgets);
  });
}
