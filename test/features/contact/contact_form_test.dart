import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/features/contact/components/contact_confirmation.dart';
import 'package:expogeo/features/contact/components/contact_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_url_launcher.dart';

void main() {
  const errors = [
    'Escreva seu nome.',
    'Escreva um e-mail válido, como nome@exemplo.com.',
    'Diga em poucas palavras o assunto.',
    'Escreva a mensagem.',
  ];

  Future<void> pump(WidgetTester tester, {double width = 1280}) async {
    tester.view.physicalSize = Size(width, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: ContactForm())),
      ),
    );
  }

  Finder field(int index) => find.byType(TextField).at(index);

  Future<void> fill(WidgetTester tester, List<String> values) async {
    for (final (index, value) in values.indexed) {
      await tester.enterText(field(index), value);
    }
    await tester.pump();
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.tap(find.text('Abrir no meu e-mail'));
    await tester.pumpAndSettle();
  }

  TextField fieldWidget(WidgetTester tester, int index) => tester.widget<TextField>(field(index));

  void expectFocusOn(WidgetTester tester, int index) {
    expect(fieldWidget(tester, index).focusNode?.hasFocus, isTrue);
  }

  testWidgets('quatro campos, botão com envelope, apoio e sugestões do navegador', (tester) async {
    await pump(tester);

    for (final label in ['Nome', 'E-mail', 'Assunto', 'Mensagem']) {
      expect(find.text(label), findsOneWidget);
    }
    final button = tester.widget<AppButton>(find.byType(AppButton));
    expect(button.leadingIcon, Icons.mail_outline);
    expect(
      find.text(
        'Vamos abrir o seu programa de e-mail com a mensagem já preenchida. Falta só você apertar '
        'Enviar por lá.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(fieldWidget(tester, 0).autofillHints, [AutofillHints.name]);
    expect(fieldWidget(tester, 1).autofillHints, [AutofillHints.email]);
    expect(fieldWidget(tester, 1).keyboardType, TextInputType.emailAddress);
  });

  testWidgets('nenhum erro antes da primeira tentativa', (tester) async {
    await pump(tester);
    await tester.enterText(field(1), 'errado');
    await tester.pump();

    for (final error in errors) {
      expect(find.text(error), findsNothing);
    }
  });

  testWidgets('envio vazio mostra as mensagens, foca o Nome e não abre nada', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);

    await submit(tester);

    for (final error in errors) {
      expect(find.text(error), findsOneWidget);
    }
    expectFocusOn(tester, 0);
    expect(opened, isEmpty);
    expect(find.byType(ContactConfirmation), findsNothing);
  });

  testWidgets('o foco vai ao primeiro inválido', (tester) async {
    await pump(tester);
    await fill(tester, ['Ana', 'ana@exemplo.com', '', 'Oi']);

    await submit(tester);

    expectFocusOn(tester, 2);
  });

  testWidgets('o erro some enquanto se digita', (tester) async {
    await pump(tester);
    await submit(tester);

    await tester.enterText(field(2), 'Assunto');
    await tester.pump();

    expect(find.text(errors[2]), findsNothing);
    expect(find.text(errors[0]), findsOneWidget);
  });

  testWidgets('só espaços conta como vazio; e-mail com espaço no meio é inválido', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);
    await fill(tester, ['   ', 'ana @exemplo.com', '  ', '  ']);

    await submit(tester);

    for (final error in errors) {
      expect(find.text(error), findsOneWidget);
    }
    expect(opened, isEmpty);
  });

  testWidgets('tudo válido abre o e-mail com valores aparados e corpo no formato', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);
    await fill(tester, [
      ' Ana ',
      '  ana@exemplo.com ',
      ' Link quebrado & outros ',
      ' Primeira linha\nSegunda ',
    ]);

    await submit(tester);

    expect(opened, hasLength(1));
    expect(
      opened.single,
      'mailto:expogeoufu@gmail.com?subject=${Uri.encodeComponent('Link quebrado & outros')}'
      '&body=${Uri.encodeComponent('Primeira linha\nSegunda\n\nAna\nana@exemplo.com').replaceAll('%0A', '%0D%0A')}',
    );
    expect(find.byType(ContactConfirmation), findsOneWidget);
    expect(find.text('Abrir no meu e-mail'), findsNothing);
  });

  testWidgets('voltar mantém os campos, sem erros, com foco no Nome; novo envio', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);
    await submit(tester);
    await fill(tester, ['Ana', 'ana@exemplo.com', 'Oi', 'Mensagem']);
    await submit(tester);

    await tester.tap(find.text('Voltar ao formulário'));
    await tester.pumpAndSettle();

    expect(find.byType(ContactConfirmation), findsNothing);
    expect(fieldWidget(tester, 0).controller?.text, 'Ana');
    expect(fieldWidget(tester, 3).controller?.text, 'Mensagem');
    expect(find.text(errors[0]), findsNothing);
    expectFocusOn(tester, 0);

    await submit(tester);
    expect(opened, hasLength(2));
    expect(find.byType(ContactConfirmation), findsOneWidget);
  });

  testWidgets('Enter passa de campo nas linhas simples', (tester) async {
    await pump(tester);
    await tester.tap(field(0));
    await tester.pump();

    for (final index in [1, 2, 3]) {
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      expectFocusOn(tester, index);
    }
  });

  testWidgets('Enter na mensagem não envia', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);
    await fill(tester, ['Ana', 'ana@exemplo.com', 'Oi', 'Mensagem']);
    await tester.tap(field(3));
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(opened, isEmpty);
    expect(find.byType(ContactConfirmation), findsNothing);
  });

  testWidgets('o botão ocupa a largura toda só no celular', (tester) async {
    await pump(tester, width: 390);
    expect(tester.getSize(find.byType(AppButton)).width, 390);

    await pump(tester, width: 768);
    expect(tester.getSize(find.byType(AppButton)).width, lessThan(400));
  });
}
