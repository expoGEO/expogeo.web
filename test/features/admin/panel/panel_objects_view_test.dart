import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/field/app_filter_select.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_object_row.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_objects_list.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_sidebar.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../catalog/catalog_test_data.dart';
import 'panel_harness.dart';

void main() {
  CatalogRecord dated(
    String subthemeId,
    String code, {
    required int day,
    String? title,
    String type = 'site',
    Object? preservation,
  }) {
    final record = objectWith(subthemeId, code, title: title ?? 'Objeto $code', type: type);
    (record.data['originInfo'] as Map<String, dynamic>)['insertionDate'] = DateTime(
      2025,
      1,
      day,
    ).toIso8601String();
    if (preservation != null) record.data['preservationAction'] = preservation;
    return record;
  }

  List<CatalogRecord> sample() => [
    for (var n = 1; n <= 20; n++)
      dated('NMA_SUS', 'NMA_SUS_${n.toString().padLeft(2, '0')}', day: n),
    dated('NMA_BH', 'NMA_BH_01', day: 21, title: 'Bacias do Brasil'),
    dated(
      'NMA_BH',
      'NMA_BH_03',
      day: 22,
      title: 'Rio São Francisco',
      type: 'video',
      preservation: {'operation': 'Revisar o link a cada ano', 'updateDate': '2026-12-01'},
    ),
    dated('CP_CD', 'CP_CD_01', day: 23, title: 'Censo em São Paulo'),
  ];

  Finder select(String label) => find.byWidgetPredicate(
    (widget) => widget is AppFilterSelect && widget.semanticLabel == label,
  );

  Finder searchField() => find.byType(TextField);

  bool hasFocus(WidgetTester tester, Finder finder) =>
      tester.getSemantics(finder).getSemanticsData().flagsCollection.isFocused;

  bool selectHasFocus(WidgetTester tester, String label) =>
      hasFocus(tester, find.bySemanticsLabel(label));

  Future<PanelHarness> open(
    WidgetTester tester,
    String location, {
    List<CatalogRecord>? records,
    Size size = const Size(1280, 900),
  }) async {
    final panel = PanelHarness();
    await panel.pump(tester, location, size: size);
    await panel.loadCatalog(tester, records ?? sample());
    await tester.pumpAndSettle();
    return panel;
  }

  // Os avisos curtos somem sozinhos; o teste espera para não deixar o relógio pendente.
  Future<void> waitToasts(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
  }

  group('lista', () {
    testWidgets('todos os objetos do catálogo, 12 de cada vez, do mais recente', (tester) async {
      final panel = PanelHarness();
      await panel.pump(tester, '/admin/painel/objetos');
      await panel.loadCatalog(tester);
      await tester.pumpAndSettle();

      expect(find.text('Objetos digitais'), findsWidgets);
      expect(find.text('190 objetos'), findsOneWidget);
      expect(find.byType(PanelObjectRow), findsNWidgets(12));
      expect(find.text('Mostrando 12 de 190'), findsOneWidget);
    });

    testWidgets('ordem por data de inserção, do mais recente', (tester) async {
      await open(tester, '/admin/painel/objetos');

      final rows = tester.widgetList<PanelObjectRow>(find.byType(PanelObjectRow)).toList();
      expect(rows.first.item.content.id, 'CP_CD_01');
      expect(rows[1].item.content.id, 'NMA_BH_03');
    });

    testWidgets('"Mostrar mais" acrescenta 12 e leva o foco ao primeiro item novo', (tester) async {
      await open(tester, '/admin/painel/objetos');

      await tester.ensureVisible(find.text('Mostrar mais'));
      await tester.tap(find.text('Mostrar mais'));
      await tester.pumpAndSettle();

      expect(find.byType(PanelObjectRow), findsNWidgets(23));
      expect(find.text('Mostrando 23 de 23'), findsOneWidget);
      expect(find.text('Mostrar mais'), findsNothing);
      final thirteenth = tester
          .widgetList<PanelObjectRow>(find.byType(PanelObjectRow))
          .elementAt(12);
      expect(hasFocus(tester, find.text(thirteenth.item.content.contentInfo.title)), isTrue);
    });
  });

  group('busca e filtros no endereço', () {
    testWidgets('a busca vai para o endereço e filtra', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos');

      await tester.enterText(searchField(), 'nma_bh');
      await tester.pumpAndSettle();

      expect(panel.location, '/admin/painel/objetos?q=nma_bh');
      expect(find.byType(PanelObjectRow), findsNWidgets(2));
      expect(find.text('2 objetos com os filtros atuais'), findsOneWidget);
      expect(tester.widget<TextField>(searchField()).controller!.text, 'nma_bh');
    });

    testWidgets('recarregar com todos os filtros mostra cada um escolhido', (tester) async {
      await open(
        tester,
        '/admin/painel/objetos?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas'
        '&tipo=video&q=rio',
      );

      expect(tester.widget<TextField>(searchField()).controller!.text, 'rio');
      expect(
        find.descendant(of: select('Tema'), matching: find.text('Natureza e Meio Ambiente')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: select('Subtema'), matching: find.text('Bacias Hidrográficas')),
        findsOneWidget,
      );
      expect(find.descendant(of: select('Tipo'), matching: find.text('Vídeo')), findsOneWidget);
      expect(find.byType(PanelObjectRow), findsOneWidget);
      expect(find.text('1 objeto com os filtros atuais'), findsOneWidget);
    });

    testWidgets('valores desconhecidos são ignorados', (tester) async {
      await open(tester, '/admin/painel/objetos?tipo=xyz&tema=abc');

      expect(find.text('23 objetos'), findsOneWidget);
      expect(find.text('Objetos digitais'), findsWidgets);
    });

    testWidgets('escolher o tema no filtro muda endereço e título sem tirar o foco do seletor', (
      tester,
    ) async {
      final panel = await open(tester, '/admin/painel/objetos?q=objeto');

      await tester.tap(select('Tema'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Natureza e Meio Ambiente').last);
      await tester.pumpAndSettle();

      expect(panel.location, '/admin/painel/objetos?tema=natureza-meio-ambiente&q=objeto');
      final header = tester.widget<PanelSectionHeader>(find.byType(PanelSectionHeader));
      expect(header.title, 'Natureza e Meio Ambiente');
      final sidebar = tester.widget<PanelSidebar>(find.byType(PanelSidebar));
      expect(sidebar.theme, ThemeEnum.naturezaMeioAmbiente);
      expect(selectHasFocus(tester, 'Tema'), isTrue);
    });

    testWidgets('subtema fica desativado sem tema e é limpo ao trocar o tema', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos');
      expect(tester.widget<AppFilterSelect>(select('Subtema')).isDisabled, isTrue);

      panel.router.go('/admin/painel/objetos?tema=natureza-meio-ambiente&subtema=biomas');
      await tester.pumpAndSettle();
      expect(tester.widget<AppFilterSelect>(select('Subtema')).isDisabled, isFalse);

      await tester.tap(select('Tema'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cultura e Política').last);
      await tester.pumpAndSettle();
      expect(panel.location, '/admin/painel/objetos?tema=cultura-politica');
    });

    testWidgets('o tema pelo menu lateral limpa a busca e o tipo', (tester) async {
      final panel = await open(
        tester,
        '/admin/painel/objetos?tema=natureza-meio-ambiente&tipo=site&q=x',
      );

      await tester.tap(
        find.descendant(of: find.byType(PanelSidebar), matching: find.text('Cultura e Política')),
      );
      await tester.pumpAndSettle();

      expect(panel.location, '/admin/painel/objetos?tema=cultura-politica');
      expect(tester.widget<TextField>(searchField()).controller!.text, isEmpty);
    });
  });

  group('estados', () {
    testWidgets('esqueleto até o catálogo chegar, com os filtros à vista', (tester) async {
      final panel = PanelHarness();
      await panel.pump(tester, '/admin/painel/objetos');

      expect(find.byType(PanelObjectsSkeleton), findsOneWidget);
      expect(select('Tema'), findsOneWidget);
      await panel.loadCatalog(tester, sample());
      await tester.pumpAndSettle();
      expect(find.byType(PanelObjectsSkeleton), findsNothing);
    });

    testWidgets('erro com "Tentar de novo", que carrega de novo', (tester) async {
      final panel = PanelHarness();
      await panel.pump(tester, '/admin/painel/objetos');
      panel.catalog.fail();
      await tester.pumpAndSettle();

      expect(find.text('Não conseguimos carregar os objetos'), findsOneWidget);
      await tester.tap(find.text('Tentar de novo'));
      await tester.pump();
      expect(panel.catalog.calls, 2);
      await panel.loadCatalog(tester, sample());
      await tester.pumpAndSettle();
      expect(find.byType(PanelObjectRow), findsNWidgets(12));
    });

    testWidgets('sem nenhum objeto e vazio com filtros', (tester) async {
      await open(tester, '/admin/painel/objetos', records: []);
      expect(find.text('Nenhum objeto cadastrado ainda'), findsOneWidget);
      expect(find.widgetWithText(AppButton, 'Novo objeto'), findsNWidgets(2));
    });

    testWidgets('vazio com filtros', (tester) async {
      await open(tester, '/admin/painel/objetos?q=inexistente');
      expect(find.text('Nenhum objeto com esses filtros'), findsOneWidget);
      expect(find.text('Mude a busca ou os filtros, ou cadastre um objeto novo.'), findsOneWidget);
    });
  });

  group('criar e editar', () {
    testWidgets('"Novo objeto" sem filtros abre o editor vazio', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos');

      await tester.tap(find.widgetWithText(AppButton, 'Novo objeto'));
      await tester.pumpAndSettle();

      expect(panel.location, '/admin/painel/objetos/novo');
      expect(find.text('Novo objeto'), findsOneWidget);
      expect(find.byType(PanelSidebar), findsNothing);
    });

    testWidgets('"Novo objeto" leva o tema e o subtema dos filtros', (tester) async {
      final panel = await open(
        tester,
        '/admin/painel/objetos?tema=natureza-meio-ambiente&subtema=biomas&q=cerrado',
      );

      await tester.tap(find.widgetWithText(AppButton, 'Novo objeto'));
      await tester.pumpAndSettle();

      expect(
        panel.location,
        '/admin/painel/objetos/novo?tema=natureza-meio-ambiente&subtema=biomas',
      );
    });

    testWidgets('"Editar" e o título da linha abrem o editor do objeto', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos?q=nma-bh-03');

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      expect(panel.location, '/admin/painel/objetos/nma-bh-03/editar');
      expect(find.text('Editar objeto'), findsOneWidget);
      expect(find.text('Revisar o link a cada ano'), findsOneWidget);

      panel.router.go('/admin/painel/objetos?q=nma-bh-03');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rio São Francisco'));
      await tester.pumpAndSettle();
      expect(panel.location, '/admin/painel/objetos/nma-bh-03/editar');
    });

    testWidgets('a lista guarda o próprio endereço para o editor voltar a ele', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos?tema=cultura-politica&q=censo');

      expect(panel.listMemory.location, '/admin/painel/objetos?tema=cultura-politica&q=censo');

      await tester.tap(select('Tipo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vídeo').last);
      await tester.pumpAndSettle();
      expect(panel.listMemory.location, panel.location);
    });

    testWidgets('salvar não mostra aviso na lista: o editor mostra o dele', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos?q=censo');

      await panel.contentStore.createContent(
        subtheme: SubthemeEnum.censoDemografico,
        content: panel.content.contents.first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Objeto cadastrado'), findsNothing);
      expect(panel.location, '/admin/painel/objetos?q=censo');
    });
  });

  group('excluir', () {
    Future<void> openDelete(WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();
    }

    testWidgets('confirmação com os textos novos e foco em "Cancelar"; Esc devolve o foco', (
      tester,
    ) async {
      await open(tester, '/admin/painel/objetos?q=censo');
      final delete = find.byIcon(Icons.delete_outline).first;

      Focus.of(tester.element(delete)).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text('Excluir “Censo em São Paulo”?'), findsOneWidget);
      expect(find.text('O objeto sai do site e do painel. Não dá para desfazer.'), findsOneWidget);
      final cancel = tester.widget<AppButton>(find.widgetWithText(AppButton, 'Cancelar'));
      expect(cancel.focusNode!.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Excluir “Censo em São Paulo”?'), findsNothing);
      expect(Focus.of(tester.element(delete)).hasFocus, isTrue);
    });

    testWidgets('confirmar apaga no subtema do objeto, tira a linha e avisa', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos?q=sao paulo');

      await openDelete(tester);
      await tester.tap(find.widgetWithText(AppButton, 'Excluir'));
      await tester.pumpAndSettle();

      expect(panel.content.calls, ['delete:censo-demografico:doc_CP_CD_01']);
      expect(panel.contentStore.savedCount, 1);
      expect(find.text('Censo em São Paulo'), findsNothing);
      expect(find.text('Objeto excluído'), findsOneWidget);
      expect(find.text('Nenhum objeto com esses filtros'), findsOneWidget);
      expect(hasFocus(tester, searchField()), isTrue);
      await waitToasts(tester);
    });

    testWidgets('falha avisa e mantém a linha', (tester) async {
      final panel = await open(tester, '/admin/painel/objetos?q=censo');
      panel.content.failWrites = true;

      await openDelete(tester);
      await tester.tap(find.widgetWithText(AppButton, 'Excluir'));
      await tester.pumpAndSettle();

      expect(find.text('Não deu para excluir. Tente de novo.'), findsOneWidget);
      expect(find.text('Censo em São Paulo'), findsOneWidget);
      await waitToasts(tester);
    });
  });

  for (final size in const [Size(390, 800), Size(768, 1000)]) {
    testWidgets('sem overflow em ${size.width.toInt()}', (tester) async {
      await open(
        tester,
        '/admin/painel/objetos?tema=natureza-meio-ambiente&subtema=estruturas-formas-relevo',
        size: size,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
