import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/features/theme/components/object_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_url_launcher.dart';

void main() {
  const address = 'https://www.ibge.gov.br/biomas';
  final longAddress = 'https://www.exemplo.org/${'caminho' * 22}';

  Future<void> pump(
    WidgetTester tester, {
    String location = address,
    double width = 1280,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
            child: Scaffold(
              body: SelectionArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ObjectActions(address: location),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

  AppButton buttonOf(WidgetTester tester, String text) => tester.widget<AppButton>(
    find.ancestor(of: find.text(text), matching: find.byType(AppButton)),
  );

  testWidgets('"Acessar o recurso" abre o endereço e avisa a nova aba', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester);

    expect(find.bySemanticsLabel('Acessar o recurso, abre em nova aba'), findsOneWidget);
    await tester.tap(find.text('Acessar o recurso'));
    await tester.pumpAndSettle();
    expect(opened, [address]);
  });

  testWidgets('copia o endereço, avisa e volta ao texto depois de 1,8 s', (tester) async {
    final copied = mockClipboard(tester);
    await pump(tester, location: '  $address  ');

    await tester.tap(find.text('Copiar link'));
    await tester.pump();
    await tester.pump();

    expect(copied, [address]);
    expect(find.text('Link copiado'), findsOneWidget);
    expect(tester.takeAnnouncements().map((a) => a.message), ['Link copiado']);

    await tester.pump(const Duration(milliseconds: 1700));
    expect(find.text('Link copiado'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Copiar link'), findsOneWidget);
  });

  testWidgets('sair da tela com o retorno à vista não deixa temporizador', (tester) async {
    mockClipboard(tester);
    await pump(tester);

    await tester.tap(find.text('Copiar link'));
    await tester.pump();
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('falha ao copiar mostra o aviso e seleciona o endereço', (tester) async {
    mockClipboard(tester, fail: true);
    await pump(tester);

    await tester.tap(find.text('Copiar link'));
    await tester.pump();
    await tester.pump();
    await tester.pump();

    const message = 'Não deu para copiar. Selecione o endereço abaixo.';
    expect(find.text(message), findsOneWidget);
    expect(find.text('Copiar link'), findsOneWidget);
    expect(tester.takeAnnouncements().map((a) => a.message), [message]);

    final paragraph = tester.renderObject<RenderParagraph>(
      find.descendant(of: find.text(address), matching: find.byType(RichText)),
    );
    expect(paragraph.selections.single.textInside(address), address);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text(message), findsOneWidget);
  });

  for (final (label, location) in [
    ('sem esquema', 'ibge.gov.br/biomas'),
    ('com espaço no meio', 'https://www.ibge gov.br'),
  ]) {
    testWidgets('endereço inválido ($label) desativa e mostra o texto gravado', (tester) async {
      await pump(tester, location: location);

      expect(buttonOf(tester, 'Acessar o recurso').isDisabled, isTrue);
      expect(buttonOf(tester, 'Copiar link').isDisabled, isTrue);
      expect(find.text('Endereço indisponível'), findsOneWidget);
      expect(find.text(location), findsOneWidget);
    });
  }

  testWidgets('endereço vazio desativa e não deixa linha solta', (tester) async {
    await pump(tester, location: '   ');

    expect(buttonOf(tester, 'Acessar o recurso').isDisabled, isTrue);
    expect(find.text('Endereço indisponível'), findsOneWidget);
    expect(find.byType(SelectionArea), findsOneWidget);
  });

  testWidgets('endereço válido com espaços nas pontas funciona', (tester) async {
    await pump(tester, location: ' $address ');

    expect(buttonOf(tester, 'Acessar o recurso').isDisabled, isFalse);
    expect(buttonOf(tester, 'Acessar o recurso').externalUrl, address);
    expect(find.text(address), findsOneWidget);
    expect(find.text('Endereço indisponível'), findsNothing);
  });

  testWidgets('no celular, botões em largura total, um embaixo do outro', (tester) async {
    await pump(tester, width: 390);

    Rect fill(String text) =>
        tester.getRect(find.ancestor(of: find.text(text), matching: find.byType(Material)).first);
    final open = fill('Acessar o recurso');
    final copy = fill('Copiar link');
    expect(open.width, 350);
    expect(copy.width, 350);
    expect(copy.top, greaterThan(open.bottom));
  });

  for (final width in [768.0, 1280.0]) {
    testWidgets('em $width, botões lado a lado', (tester) async {
      await pump(tester, width: width);

      final open = tester.getRect(find.byType(AppButton).first);
      final copy = tester.getRect(find.byType(AppButton).last);
      expect(copy.top, open.top);
      expect(copy.left, greaterThan(open.right));
    });
  }

  for (final scale in [1.0, 2.0]) {
    testWidgets('endereço longo sem overflow em 320 a ${scale * 100}%', (tester) async {
      await pump(tester, location: longAddress, width: 320, textScale: scale);

      expect(tester.takeException(), isNull);
    });
  }
}
