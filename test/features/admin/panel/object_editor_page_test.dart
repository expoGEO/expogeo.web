import 'package:expogeo/core/components/card/object_card.dart';
import 'package:expogeo/core/components/form/form_select_field.dart';
import 'package:expogeo/core/components/form/form_text_field.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_card.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_missing_alert.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_side.dart';
import 'package:expogeo/features/admin/panel/presentation/components/editor/object_editor_skeleton.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../catalog/catalog_test_data.dart';
import 'panel_harness.dart';

/// Objeto gravado como os do ambiente de testes: siglas do caminho também nos campos.
CatalogRecord stored(
  String subthemeId,
  String code, {
  String? title,
  Object? preservation,
  int? year,
  String? rules,
}) {
  final record = objectWith(
    subthemeId,
    code,
    title: title ?? 'Objeto $code',
    year: year,
    subjects: const ['Bacias hidrográficas'],
  );
  record.data
    ..['themeId'] = subthemeId.split('_').first
    ..['subthemeId'] = subthemeId;
  if (preservation != null) record.data['preservationAction'] = preservation;
  if (rules != null) {
    (record.data['registrationInfo'] as Map<String, dynamic>)['registrationRules'] = rules;
  }
  return record;
}

List<CatalogRecord> devSample() => [
  for (var n = 1; n <= 5; n++)
    stored(
      'NMA_BH',
      'NMA_BH_0$n',
      title: n == 3 ? 'Sistema de Informações de Águas Subterrâneas' : null,
      preservation: n == 3
          ? {'operation': 'Atualização do link ao longo do tempo', 'updateDate': '2026-12-01'}
          : null,
      rules: n == 3 ? 'Descrição de acordo com a curadoria ExpoGEO' : null,
    ),
  for (var n = 1; n <= 6; n++) stored('NMA_PA', 'NMA_PAG_0$n'),
  stored('CP_CD', 'CP_CD_01', title: 'Censo em São Paulo'),
];

void main() {
  Finder textField(String label) => find.descendant(
    of: find.byWidgetPredicate((widget) => widget is FormTextField && widget.label == label),
    matching: find.byType(TextField),
  );

  Finder selectField(String label) => find.descendant(
    of: find.byWidgetPredicate((widget) => widget is FormSelectField && widget.label == label),
    matching: find.byType(InkWell),
  );

  String textOf(WidgetTester tester, String label) =>
      tester.widget<TextField>(textField(label)).controller!.text;

  Future<void> choose(WidgetTester tester, String label, String option) async {
    await tester.ensureVisible(selectField(label));
    await tester.tap(selectField(label));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(option).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, String label, String text) async {
    await tester.ensureVisible(textField(label));
    await tester.enterText(textField(label), text);
    await tester.pump();
  }

  Future<PanelHarness> open(
    WidgetTester tester,
    String location, {
    List<CatalogRecord>? records,
    Size size = const Size(1280, 900),
  }) async {
    final panel = PanelHarness();
    final data = records ?? devSample();
    panel.content.contents
      ..clear()
      ..addAll(CatalogModel.fromRecords(data).items.map((item) => item.content));
    await panel.pump(tester, location, size: size);
    await panel.loadCatalog(tester, data);
    await tester.pumpAndSettle();
    return panel;
  }

  Future<void> waitToasts(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
  }

  Future<void> fillRequired(WidgetTester tester) async {
    await type(tester, 'Título', 'Atlas das águas');
    await type(tester, 'Descrição', 'Mapa das bacias.');
    await type(tester, 'Assuntos', 'Bacias, Rios, Bacias');
    await type(tester, 'Criador', 'ANA');
    await type(tester, 'Endereço do recurso', 'https://www.ana.gov.br');
    await choose(tester, 'Tipo', 'Vídeo');
    await choose(tester, 'Formato', 'HTML');
    await type(tester, 'Direitos', 'Licença livre');
  }

  Future<void> save(WidgetTester tester) async {
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
  }

  group('código gerado (dados do ambiente de testes)', () {
    for (final (query, code) in [
      ('tema=natureza-meio-ambiente&subtema=bacias-hidrograficas', 'NMA_BH_06'),
      ('tema=natureza-meio-ambiente&subtema=poluicao-agua', 'NMA_PAG_07'),
      ('tema=natureza-meio-ambiente&subtema=queimadas', 'NMA_QUE_01'),
    ]) {
      testWidgets('$query mostra $code na barra e na lateral', (tester) async {
        await open(tester, '/admin/painel/objetos/novo?$query');

        expect(find.text(code), findsNWidgets(2));
        expect(find.bySemanticsLabel('Código de referência: $code'), findsWidgets);
      });
    }

    testWidgets('sem tema e subtema, sem pílula e com "Escolha o tema e o subtema"', (
      tester,
    ) async {
      await open(tester, '/admin/painel/objetos/novo');

      expect(find.text('Escolha o tema e o subtema'), findsOneWidget);
      expect(find.textContaining('NMA_'), findsNothing);
    });

    testWidgets('trocar o tema limpa o subtema e o código; o código segue o subtema', (
      tester,
    ) async {
      await open(
        tester,
        '/admin/painel/objetos/novo?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas',
      );

      await choose(tester, 'Tema', 'Cultura e Política');
      expect(find.text('NMA_BH_06'), findsNothing);
      expect(find.text('Escolha o tema e o subtema'), findsOneWidget);

      await choose(tester, 'Subtema', 'Censo Demográfico');
      expect(find.text('CP_CD_02'), findsNWidgets(2));
    });
  });

  group('valores iniciais', () {
    testWidgets('novo: barra, quatro cartões, padrões e opcionais', (tester) async {
      await open(tester, '/admin/painel/objetos/novo');

      expect(find.text('Novo objeto'), findsOneWidget);
      for (final title in ['CONTEÚDO', 'AUTORIA', 'ORIGEM E REGISTRO', 'DIREITOS E PRESERVAÇÃO']) {
        expect(find.text(title), findsOneWidget);
      }
      expect(textOf(tester, 'Idioma'), 'Português');
      expect(textOf(tester, 'Requisitos'), 'Acesso à internet');
      expect(textOf(tester, 'Ação de preservação'), 'Atualização do link ao longo do tempo');
      expect(find.text('Escolha'), findsNWidgets(4));
      expect(find.bySemanticsLabel(RegExp('^Nota de conteúdo, opcional')), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('^Regras de registro, opcional')), findsOneWidget);
      expect(find.text('Separe por vírgula. Viram filtros na página do subtema.'), findsOneWidget);
    });

    testWidgets('editar abre como gravado e mantém o código', (tester) async {
      await open(tester, '/admin/painel/objetos/nma-bh-03/editar');

      expect(find.text('Editar objeto'), findsOneWidget);
      expect(textOf(tester, 'Título'), 'Sistema de Informações de Águas Subterrâneas');
      expect(textOf(tester, 'Regras de registro'), 'Descrição de acordo com a curadoria ExpoGEO');
      expect(find.text('Dezembro'), findsOneWidget);
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('NMA_BH_03'), findsNWidgets(2));

      await choose(tester, 'Subtema', 'Biomas');
      expect(find.text('NMA_BIO_01'), findsNWidgets(2));
      await choose(tester, 'Subtema', 'Bacias Hidrográficas');
      expect(find.text('NMA_BH_03'), findsNWidgets(2));
    });

    testWidgets('o código original no endereço passa para a forma com hífen', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos/NMA_BH_03/editar');

      expect(panel.location, '/admin/painel/objetos/nma-bh-03/editar');
      expect(find.text('Editar objeto'), findsOneWidget);
    });
  });

  group('prévia', () {
    testWidgets('acompanha a digitação, com exemplos, sem ser link', (tester) async {
      await open(
        tester,
        '/admin/painel/objetos/novo?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas',
      );

      final card = find.byType(ObjectCard);
      expect(find.descendant(of: card, matching: find.text('Título do objeto')), findsOneWidget);
      expect(
        find.descendant(of: card, matching: find.text('A descrição aparece aqui.')),
        findsOneWidget,
      );

      await type(tester, 'Título', 'Atlas das águas');
      expect(find.descendant(of: card, matching: find.text('Atlas das águas')), findsOneWidget);

      final preview = find.ancestor(of: card, matching: find.byType(ObjectEditorCard));
      final data = tester.getSemantics(preview.first).getSemanticsData();
      expect(data.flagsCollection.isLink, isFalse);
      expect(find.bySemanticsLabel('Atlas das águas'), findsNothing);
    });
  });

  group('pendências', () {
    testWidgets('salvar vazio lista tudo na ordem e cada link leva ao campo', (tester) async {
      await open(tester, '/admin/painel/objetos/novo');

      await save(tester);

      final alert = tester.widget<ObjectEditorMissingAlert>(find.byType(ObjectEditorMissingAlert));
      expect(alert.problems.map((problem) => problem.label), [
        'o tema',
        'o subtema',
        'o título',
        'a descrição',
        'os assuntos',
        'o criador',
        'o endereço do recurso',
        'o tipo',
        'o formato',
        'os direitos',
      ]);
      expect(alert.focusNode.hasFocus, isTrue);

      await tester.tap(find.text('•  o criador', findRichText: true));
      await tester.pumpAndSettle();
      final creator = tester.widget<TextField>(textField('Criador'));
      expect(creator.focusNode!.hasFocus, isTrue);
    });

    testWidgets('endereço sem https, ano curto e revisão só com mês', (tester) async {
      await open(
        tester,
        '/admin/painel/objetos/novo?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas',
      );
      await fillRequired(tester);
      await type(tester, 'Endereço do recurso', 'www.ana.gov.br');
      await type(tester, 'Ano de emissão', '20a2');
      expect(textOf(tester, 'Ano de emissão'), '202');
      await choose(tester, 'Mês', 'Março');

      await save(tester);

      expect(
        find.text('•  o endereço do recurso (comece com https://)', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.text('•  o ano de emissão (use 4 algarismos)', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.text('•  a próxima revisão do link (escolha o mês e o ano)', findRichText: true),
        findsOneWidget,
      );
    });
  });

  group('salvar', () {
    testWidgets('novo grava no formato dos dados e volta à lista com o aviso', (tester) async {
      final panel = await open(
        tester,
        '/admin/painel/objetos/novo?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas',
      );
      panel.listMemory.remember('/admin/painel/objetos?tema=natureza-meio-ambiente');
      await fillRequired(tester);

      await save(tester);

      expect(panel.content.calls, ['create:bacias-hidrograficas']);
      final json = panel.content.written.single.toJson();
      expect(json['id'], 'NMA_BH_06');
      expect(json['themeId'], 'NMA');
      expect(json['subthemeId'], 'NMA_BH');
      expect(json['themeTitle'], 'Natureza e Meio Ambiente');
      expect(json['subthemeTitle'], 'Bacias Hidrográficas');
      expect(json['contentInfo'], containsPair('subjects', ['Bacias', 'Rios']));
      final origin = json['originInfo'] as Map<String, dynamic>;
      expect(origin['type'], 'video');
      expect(origin['format'], 'html');
      expect(origin['insertionDate'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      expect(panel.location, '/admin/painel/objetos?tema=natureza-meio-ambiente');
      expect(find.text('Objeto cadastrado'), findsOneWidget);
      await waitToasts(tester);
    });

    testWidgets('código ocupado na hora de salvar: aviso com o código gravado', (tester) async {
      final panel = await open(
        tester,
        '/admin/painel/objetos/novo?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas',
      );
      panel.content.takenCodes.add('NMA_BH_06');
      await fillRequired(tester);

      await save(tester);

      expect(find.text('Objeto cadastrado com o código NMA_BH_07'), findsOneWidget);
      await waitToasts(tester);
    });

    testWidgets('editar atualiza o mesmo documento e mantém a data de inserção', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos/nma-bh-03/editar');
      final before = CatalogModel.fromRecords(
        devSample(),
      ).findByCode('NMA_BH_03')!.content.originInfo.insertionDate;

      await type(tester, 'Título', 'Águas subterrâneas');
      await save(tester);

      expect(panel.content.calls, ['update:bacias-hidrograficas:doc_NMA_BH_03']);
      final written = panel.content.written.single;
      expect(written.id, 'NMA_BH_03');
      expect(written.originInfo.insertionDate, before);
      expect(written.toJson()['originInfo'], containsPair('type', 'site'));
      expect(find.text('Alterações salvas'), findsOneWidget);
      expect(panel.location, '/admin/painel/objetos');
      await waitToasts(tester);
    });

    testWidgets('mudar de subtema pede confirmação com o código novo e move', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos/nma-bh-03/editar');

      await choose(tester, 'Subtema', 'Biomas');
      await save(tester);

      expect(find.text('Mudar de subtema?'), findsOneWidget);
      expect(
        find.text(
          'O objeto vai para Biomas e recebe o código NMA_BIO_01. '
          'O endereço antigo deixa de funcionar.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Cancelar').last);
      await tester.pumpAndSettle();
      expect(panel.content.calls, isEmpty);

      await save(tester);
      await tester.tap(find.text('Mudar e salvar'));
      await tester.pumpAndSettle();
      expect(panel.content.calls, ['move:bacias-hidrograficas:doc_NMA_BH_03:biomas']);
      expect(panel.content.written.single.id, 'NMA_BIO_01');
      await waitToasts(tester);
    });

    testWidgets('mudar de subtema com o código já ocupado avisa o código gravado', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos/nma-bh-03/editar');
      panel.content.takenCodes.add('NMA_BIO_01');

      await choose(tester, 'Subtema', 'Biomas');
      await save(tester);
      await tester.tap(find.text('Mudar e salvar'));
      await tester.pumpAndSettle();

      expect(panel.content.written.single.id, 'NMA_BIO_02');
      expect(find.text('Alterações salvas. O objeto recebeu o código NMA_BIO_02'), findsOneWidget);
      await waitToasts(tester);
    });

    testWidgets('falha mantém o editor e o que foi digitado', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos/nma-bh-03/editar');
      panel.content.failWrites = true;

      await type(tester, 'Título', 'Águas subterrâneas');
      await save(tester);

      expect(find.text('Não deu para salvar. Confira a conexão e tente de novo.'), findsOneWidget);
      expect(panel.location, '/admin/painel/objetos/nma-bh-03/editar');
      expect(textOf(tester, 'Título'), 'Águas subterrâneas');
      expect(find.text('Salvar'), findsOneWidget);
      await waitToasts(tester);
    });
  });

  group('sair', () {
    testWidgets('sem alterações, "Cancelar" volta direto à lista guardada', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos/nma-bh-03/editar');
      panel.listMemory.remember('/admin/painel/objetos?q=bacias');

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Sair sem salvar?'), findsNothing);
      expect(panel.location, '/admin/painel/objetos?q=bacias');
    });

    testWidgets('com alterações pergunta; Esc e "Continuar editando" ficam; sair sai', (
      tester,
    ) async {
      final panel = await open(tester, '/admin/painel/objetos/nma-bh-03/editar');
      await type(tester, 'Título', 'Outro título');

      await tester.tap(find.text('Objetos digitais'));
      await tester.pumpAndSettle();
      expect(find.text('Sair sem salvar?'), findsOneWidget);
      expect(find.text('As alterações feitas aqui serão perdidas.'), findsOneWidget);
      final keep = find.text('Continuar editando');
      expect(Focus.of(tester.element(keep)).hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(panel.location, '/admin/painel/objetos/nma-bh-03/editar');

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continuar editando'));
      await tester.pumpAndSettle();
      expect(panel.location, '/admin/painel/objetos/nma-bh-03/editar');
      expect(textOf(tester, 'Título'), 'Outro título');

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sair sem salvar'));
      await tester.pumpAndSettle();
      expect(panel.location, '/admin/painel/objetos');
    });
  });

  group('estados', () {
    testWidgets('esqueleto enquanto o catálogo não chega, com a barra visível', (tester) async {
      final panel = PanelHarness();
      await panel.pump(tester, '/admin/painel/objetos/novo');

      expect(find.byType(ObjectEditorSkeleton), findsOneWidget);
      expect(find.text('Novo objeto'), findsOneWidget);
      expect(find.text('Salvar'), findsNothing);

      await panel.loadCatalog(tester, devSample());
      await tester.pumpAndSettle();
      expect(find.byType(ObjectEditorSkeleton), findsNothing);
    });

    testWidgets('erro ao carregar com "Tentar de novo" e "Voltar aos objetos"', (tester) async {
      final panel = PanelHarness();
      await panel.pump(tester, '/admin/painel/objetos/novo');
      panel.catalog.fail();
      await tester.pumpAndSettle();

      expect(find.text('Não conseguimos carregar o editor'), findsOneWidget);
      await tester.tap(find.text('Tentar de novo'));
      await tester.pump();
      expect(panel.catalog.calls, 2);
      await panel.loadCatalog(tester, devSample());
      await tester.pumpAndSettle();
      expect(find.text('CONTEÚDO'), findsOneWidget);
    });

    testWidgets('objeto não encontrado', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos/nma-bh-99/editar');

      expect(find.text('Não encontramos este objeto'), findsOneWidget);
      expect(
        find.text('Ele pode ter sido excluído ou o endereço está incompleto.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Voltar aos objetos'));
      await tester.pumpAndSettle();
      expect(panel.location, '/admin/painel/objetos');
    });
  });

  group('teclado', () {
    testWidgets('do último campo, o Tab leva ao tema e rola a lateral para a vista', (
      tester,
    ) async {
      await open(
        tester,
        '/admin/painel/objetos/novo?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas',
        size: const Size(1280, 500),
      );
      await tester.ensureVisible(selectField('Ano').first);
      await tester.pumpAndSettle();
      final tema = selectField('Tema');
      expect(tester.getTopLeft(tema).dy, lessThan(0));

      tester.widget<InkWell>(selectField('Ano').first).focusNode!.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(Focus.of(tester.element(tema)).hasFocus, isTrue);
      expect(tester.getTopLeft(tema).dy, greaterThan(0));
    });
  });

  group('responsivo', () {
    double top(WidgetTester tester, String text) => tester.getTopLeft(find.text(text)).dy;

    for (final width in [390.0, 768.0]) {
      testWidgets('$width: uma coluna, "Onde aparece" no topo e a prévia no fim', (tester) async {
        await open(
          tester,
          '/admin/painel/objetos/novo?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas',
          size: Size(width, 900),
        );

        await tester.ensureVisible(find.text('ONDE APARECE'));
        expect(top(tester, 'ONDE APARECE'), lessThan(top(tester, 'CONTEÚDO')));
        await tester.ensureVisible(find.text('PRÉVIA DO CARTÃO'));
        expect(top(tester, 'DIREITOS E PRESERVAÇÃO'), lessThan(top(tester, 'PRÉVIA DO CARTÃO')));
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('1280: lateral de 340 px à direita', (tester) async {
      await open(tester, '/admin/painel/objetos/novo');

      final side = tester.getRect(find.byType(ObjectEditorWhere));
      final main = tester.getRect(find.text('CONTEÚDO'));
      expect(side.width, 340);
      expect(side.left, greaterThan(main.left));
    });

    testWidgets('390 com título longo: sem overflow e botões em largura total', (tester) async {
      await open(tester, '/admin/painel/objetos/nma-bh-03/editar', size: const Size(390, 800));
      await type(tester, 'Título', 'Um título muito longo ' * 8);

      expect(tester.takeException(), isNull);
      final save = tester.getRect(find.text('Salvar'));
      final cancel = tester.getRect(find.text('Cancelar'));
      expect(save.top, cancel.top);
    });
  });
}
