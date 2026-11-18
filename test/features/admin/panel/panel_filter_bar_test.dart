import 'package:expogeo/core/components/field/app_filter_select.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Larguras da área de conteúdo do painel em 390, 768 e 1280 px de janela.
  const phone = 390.0 - 32;
  const tablet = 768.0 - 32;
  const desktop = 1280.0 - 248 - 64;

  Widget select(String label, String value, bool expand) => AppFilterSelect<String>(
    semanticLabel: label,
    options: [AppFilterOption(value, value)],
    value: value,
    expand: expand,
    onSelected: (_) {},
  );

  Future<void> pump(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PanelFilterBar(
            search: const SizedBox(key: Key('busca'), height: 42),
            theme: (expand) => select('Tema', 'Natureza e Meio Ambiente', expand),
            subtheme: (expand) => select('Subtema', 'Estruturas e Formas de Relevo', expand),
            type: (expand) => select('Tipo', 'Todos os tipos', expand),
          ),
        ),
      ),
    );
  }

  Rect rectOf(WidgetTester tester, String text) => tester.getRect(find.text(text));

  test('disposição pela largura disponível', () {
    expect(PanelFilterBar.layoutFor(desktop - 26), PanelFilterLayout.singleRow);
    expect(PanelFilterBar.layoutFor(tablet - 26), PanelFilterLayout.twoRows);
    expect(PanelFilterBar.layoutFor(phone - 26), PanelFilterLayout.grid);
  });

  testWidgets('1280: tudo numa linha, com a busca à esquerda', (tester) async {
    await pump(tester, desktop);

    final search = tester.getRect(find.byKey(const Key('busca')));
    final theme = rectOf(tester, 'Natureza e Meio Ambiente');
    final type = rectOf(tester, 'Todos os tipos');
    expect(theme.center.dy, closeTo(search.center.dy, 1));
    expect(type.center.dy, closeTo(search.center.dy, 1));
    expect(theme.left, greaterThan(search.right));
    expect(tester.takeException(), isNull);
  });

  testWidgets('768: busca numa linha e os três seletores na de baixo', (tester) async {
    await pump(tester, tablet);

    final search = tester.getRect(find.byKey(const Key('busca')));
    final theme = rectOf(tester, 'Natureza e Meio Ambiente');
    final subtheme = rectOf(tester, 'Estruturas e Formas de Relevo');
    final type = rectOf(tester, 'Todos os tipos');
    expect(theme.top, greaterThan(search.bottom));
    expect(subtheme.center.dy, closeTo(theme.center.dy, 1));
    expect(type.center.dy, closeTo(theme.center.dy, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('390: busca e grade de 2 colunas, sem overflow', (tester) async {
    await pump(tester, phone);

    final search = tester.getRect(find.byKey(const Key('busca')));
    final theme = rectOf(tester, 'Natureza e Meio Ambiente');
    final subtheme = rectOf(tester, 'Estruturas e Formas de Relevo');
    final type = rectOf(tester, 'Todos os tipos');
    expect(theme.top, greaterThan(search.bottom));
    expect(subtheme.center.dy, closeTo(theme.center.dy, 1));
    expect(type.top, greaterThan(theme.bottom));
    expect(type.left, closeTo(theme.left, 1));
    expect(tester.takeException(), isNull);
  });
}
