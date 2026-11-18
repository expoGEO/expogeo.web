import 'package:expogeo/core/components/button/inline_link.dart';
import 'package:expogeo/core/utils/url/mail_draft.dart';
import 'package:expogeo/features/contact/components/contact_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/semantics.dart';

void main() {
  const draft = MailDraft(
    to: 'expogeoufu@gmail.com',
    subject: 'Link quebrado',
    body: 'O link caiu.\n\nAna\nana@exemplo.com',
  );

  Future<void> pump(WidgetTester tester, {VoidCallback? onBack}) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ContactConfirmation(draft: draft, onBack: onBack ?? () {}),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  List<String> mockClipboard(WidgetTester tester, {bool fail = false}) {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (
      call,
    ) async {
      if (call.method != 'Clipboard.setData') return null;
      if (fail) throw PlatformException(code: 'copy_fail');
      copied.add((call.arguments as Map)['text'] as String);
      return null;
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    return copied;
  }

  testWidgets('textos, link e botões', (tester) async {
    await pump(tester);

    expectHeading(tester, find.text('Seu e-mail está pronto'), 2);
    expect(
      find.text(
        'Abrimos o seu programa de e-mail com a mensagem preenchida. Aperte Enviar por lá para '
        'concluir.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Não abriu? Copie a mensagem', findRichText: true), findsOneWidget);
    expect(tester.widget<InlineLink>(find.byType(InlineLink)).url, 'mailto:expogeoufu@gmail.com');
    expect(find.text('Copiar mensagem'), findsOneWidget);
    expect(find.text('Voltar ao formulário'), findsOneWidget);
  });

  testWidgets('o link do texto mantém nó próprio', (tester) async {
    await pump(tester);

    final data = tester.getSemantics(find.bySemanticsLabel(draft.to)).getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
  });

  testWidgets('recebe o foco no título e é anunciada ao aparecer', (tester) async {
    await pump(tester);

    final focused = FocusManager.instance.primaryFocus;
    expect(focused?.context?.findAncestorWidgetOfExactType<ContactConfirmation>(), isNotNull);
    expect(tester.takeAnnouncements().map((a) => a.message), ['Seu e-mail está pronto']);
  });

  testWidgets('copia, anuncia e volta ao rótulo inicial', (tester) async {
    final copied = mockClipboard(tester);
    await pump(tester);

    await tester.tap(find.text('Copiar mensagem'));
    await tester.pump();
    await tester.pump();

    expect(copied, ['Assunto: Link quebrado\n\nO link caiu.\n\nAna\nana@exemplo.com']);
    expect(find.text('Mensagem copiada'), findsOneWidget);
    expect(tester.takeAnnouncements().map((a) => a.message).last, 'Mensagem copiada');

    await tester.pump(const Duration(milliseconds: 1900));
    expect(find.text('Copiar mensagem'), findsOneWidget);
  });

  testWidgets('falha ao copiar mostra o erro, anuncia e volta', (tester) async {
    mockClipboard(tester, fail: true);
    await pump(tester);

    await tester.tap(find.text('Copiar mensagem'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Erro ao copiar'), findsOneWidget);
    expect(tester.takeAnnouncements().map((a) => a.message).last, 'Erro ao copiar');

    await tester.pump(const Duration(milliseconds: 1900));
    expect(find.text('Copiar mensagem'), findsOneWidget);
  });

  testWidgets('"Voltar ao formulário" chama o retorno', (tester) async {
    var backs = 0;
    await pump(tester, onBack: () => backs++);

    await tester.tap(find.text('Voltar ao formulário'));
    await tester.pump();

    expect(backs, 1);
  });

  testWidgets('sair da tela com o retorno à vista não deixa temporizador', (tester) async {
    mockClipboard(tester);
    await pump(tester);

    await tester.tap(find.text('Copiar mensagem'));
    await tester.pump();
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
  });
}
