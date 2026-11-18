import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_objects_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );

  testWidgets('rodapé com "Mostrar mais" quando há mais', (tester) async {
    var calls = 0;
    await pump(
      tester,
      PanelObjectsList(
        rows: const [Text('Linha 1'), Text('Linha 2')],
        footer: 'Mostrando 12 de 190',
        onShowMore: () => calls++,
      ),
    );

    expect(find.text('Linha 1'), findsOneWidget);
    expect(find.text('Mostrando 12 de 190'), findsOneWidget);
    await tester.tap(find.text('Mostrar mais'));
    expect(calls, 1);
  });

  testWidgets('sem mais itens, sem o botão', (tester) async {
    await pump(tester, const PanelObjectsList(rows: [Text('Linha 1')], footer: 'Mostrando 1 de 1'));

    expect(find.text('Mostrando 1 de 1'), findsOneWidget);
    expect(find.text('Mostrar mais'), findsNothing);
  });

  testWidgets('esqueleto com 4 linhas de círculo e duas barras, lido como carregando', (
    tester,
  ) async {
    await pump(tester, const PanelObjectsSkeleton());

    expect(find.byType(AppSkeleton), findsNWidgets(12));
    expect(find.bySemanticsLabel('Carregando…'), findsOneWidget);
  });
}
