import 'package:expogeo/core/components/state/state_message_box.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, StateMessageBox box, {double width = 800}) {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: box)),
      ),
    );
  }

  testWidgets('mostra título, texto e ação', (tester) async {
    await pump(
      tester,
      StateMessageBox(
        icon: Icons.search_off,
        title: 'Nenhum objeto encontrado',
        message: 'Tente outra palavra.',
        action: TextButton(onPressed: () {}, child: const Text('Limpar busca')),
      ),
    );

    expect(find.text('Nenhum objeto encontrado'), findsOneWidget);
    expect(find.text('Tente outra palavra.'), findsOneWidget);
    expect(find.text('Limpar busca'), findsOneWidget);
  });

  testWidgets('texto e ação são opcionais', (tester) async {
    await pump(tester, const StateMessageBox(icon: Icons.inbox_outlined, title: 'Vazio'));

    expect(find.text('Vazio'), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('ícone muda por tom', (tester) async {
    await pump(tester, const StateMessageBox(icon: Icons.inbox_outlined, title: 'Vazio'));
    expect(tester.widget<Icon>(find.byType(Icon)).color, AppTheme.colors.inkSecondary);

    await pump(
      tester,
      const StateMessageBox(
        icon: Icons.cloud_off_outlined,
        title: 'Erro',
        tone: StateMessageTone.error,
      ),
    );
    expect(tester.widget<Icon>(find.byType(Icon)).color, AppTheme.colors.error);
  });

  testWidgets('texto limitado à largura de leitura da caixa', (tester) async {
    final message = 'Uma mensagem longa. ' * 10;
    await pump(tester, StateMessageBox(icon: Icons.inbox_outlined, title: 'T', message: message));

    expect(
      tester.getSize(find.text(message)).width,
      lessThanOrEqualTo(AppTheme.dimensions.components.stateBoxTextMaxWidth),
    );
  });

  testWidgets('sem overflow em 320', (tester) async {
    await pump(
      tester,
      StateMessageBox(
        icon: Icons.inbox_outlined,
        title: 'Não conseguimos carregar os objetos',
        message: 'Confira sua conexão com a internet e tente de novo.',
        action: TextButton(onPressed: () {}, child: const Text('Tentar de novo')),
      ),
      width: 320,
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('título vira cabeçalho do nível pedido', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      const StateMessageBox(icon: Icons.inbox_outlined, title: 'Título', headingLevel: 1),
    );

    final data = tester.getSemantics(find.text('Título')).getSemanticsData();
    expect(data.flagsCollection.isHeader, isTrue);
    expect(data.headingLevel, 1);
    handle.dispose();
  });

  testWidgets('sem nível, o título não é cabeçalho', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, const StateMessageBox(icon: Icons.inbox_outlined, title: 'Título'));

    expect(
      tester.getSemantics(find.text('Título')).getSemanticsData().flagsCollection.isHeader,
      isFalse,
    );
    handle.dispose();
  });

  SemanticsRole roleOf(WidgetTester tester) {
    final node = tester.getSemantics(find.text('Título')).parent!;
    return node.getSemanticsData().role;
  }

  testWidgets('erro tem papel de alerta e neutro, de status', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      const StateMessageBox(
        icon: Icons.error_outline,
        title: 'Título',
        tone: StateMessageTone.error,
      ),
    );
    expect(roleOf(tester), SemanticsRole.alert);

    await pump(tester, const StateMessageBox(icon: Icons.inbox_outlined, title: 'Título'));
    await tester.pump();
    expect(roleOf(tester), SemanticsRole.status);
    handle.dispose();
  });

  testWidgets('anuncia o título ao aparecer, com urgência no erro', (tester) async {
    final announcements = <Map<Object?, Object?>>[];
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

    await pump(
      tester,
      const StateMessageBox(
        icon: Icons.error_outline,
        title: 'Falhou',
        tone: StateMessageTone.error,
      ),
    );
    await tester.pump();

    final data = announcements.single['data']! as Map<Object?, Object?>;
    expect(data['message'], 'Falhou');
    expect(data['assertiveness'], Assertiveness.assertive.index);
  });

  testWidgets('sem anúncio quando pedido', (tester) async {
    final announcements = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(
      SystemChannels.accessibility,
      (message) async {
        announcements.add(message);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(
        SystemChannels.accessibility,
        null,
      ),
    );

    await pump(
      tester,
      const StateMessageBox(icon: Icons.inbox_outlined, title: 'Página', announce: false),
    );
    await tester.pump();

    expect(announcements, isEmpty);
  });

  testWidgets('topo substitui o ícone e fica fora da leitura', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, const StateMessageBox(leading: Text('404'), title: 'Título'));

    expect(find.byType(Icon), findsNothing);
    expect(find.text('404'), findsOneWidget);
    expect(find.bySemanticsLabel('404'), findsNothing);
    handle.dispose();
  });
}
