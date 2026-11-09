import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/features/admin/panel/presentation/components/subtheme_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../catalog/catalog_test_data.dart';
import 'panel_harness.dart';

void main() {
  testWidgets('4 blocos na ordem do site, com subtemas e objetos', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/temas');
    await panel.loadCatalog(tester);

    expect(
      find.text('Só para consulta. Os temas e subtemas não são criados nem apagados pelo painel.'),
      findsOneWidget,
    );
    final titles = [
      'Representações Espaciais',
      'Natureza e Meio Ambiente',
      'Espaços Urbanos e Rurais',
      'Cultura e Política',
    ];
    final tops = [
      for (final title in titles) tester.getTopLeft(find.bySemanticsLabel(title).last).dy,
    ];
    expect([...tops]..sort(), tops);
    expect(find.text('12 subtemas · 74 objetos'), findsOneWidget);
    expect(find.byType(SubthemeRow), findsNWidgets(31));
    expect(find.text('/natureza-meio-ambiente/biomas'), findsOneWidget);
    expect(find.bySemanticsLabel('Ver objetos de Biomas'), findsOneWidget);
  });

  testWidgets('"1 objeto" no singular e "0 objetos" sem nenhum', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/temas');
    panel.catalog.succeed([recordAt('NMA_BIO', 'um')]);
    await tester.pump();
    await tester.pump();

    expect(find.text('1 objeto'), findsOneWidget);
    expect(find.text('0 objetos'), findsNWidgets(30));
  });

  testWidgets('carregando, esqueleto no lugar das contagens', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/temas');

    expect(find.byType(AppSkeleton), findsWidgets);
    expect(find.text('/natureza-meio-ambiente/biomas'), findsOneWidget);
    await panel.loadCatalog(tester);
  });

  testWidgets('erro mostra nomes sem contagens e "Tentar de novo" recarrega', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/temas');
    panel.catalog.fail();
    await tester.pump();
    await tester.pump();

    expect(find.text('Não conseguimos carregar as contagens.'), findsOneWidget);
    expect(find.textContaining('objetos'), findsNothing);
    expect(find.text('12 subtemas'), findsOneWidget);

    await tester.tap(find.text('Tentar de novo'));
    await tester.pump();
    expect(panel.catalog.calls, 2);
    await panel.loadCatalog(tester);
    expect(find.text('Não conseguimos carregar as contagens.'), findsNothing);
  });

  testWidgets('"Ver objetos" abre objetos com tema e subtema', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/temas');
    await panel.loadCatalog(tester);

    await tester.ensureVisible(find.bySemanticsLabel('Ver objetos de Biomas'));
    await tester.tap(find.bySemanticsLabel('Ver objetos de Biomas'));
    await tester.pumpAndSettle();

    expect(panel.location, '/admin/painel/objetos?tema=natureza-meio-ambiente&subtema=biomas');
  });

  testWidgets('em 390 as linhas empilham sem estourar', (tester) async {
    final panel = PanelHarness();
    await panel.pump(tester, '/admin/painel/temas', size: const Size(390, 800));
    await panel.loadCatalog(tester);

    expect(tester.takeException(), isNull);
    final row = find.byType(SubthemeRow).first;
    expect(find.descendant(of: row, matching: find.byType(Column)), findsWidgets);
    expect(tester.getSize(row).width, lessThanOrEqualTo(390));
  });
}
