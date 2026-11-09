import 'package:expogeo/core/components/button/app_icon_button.dart';
import 'package:expogeo/core/components/reading/reference_code.dart';
import 'package:expogeo/features/admin/panel/presentation/components/panel_object_row.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/fake_url_launcher.dart';
import '../../catalog/catalog_test_data.dart';

void main() {
  CatalogItem itemWith({
    String title = 'Rio São Francisco',
    String creator = 'Agência Nacional de Águas',
    String location = 'https://www.exemplo.org/recurso',
    String type = 'Documento',
  }) {
    final record = objectWith(
      'NMA_BH',
      'NMA_BH_03',
      title: title,
      creator: creator,
      location: location,
      type: type,
    );
    (record.data['originInfo'] as Map<String, dynamic>)['insertionDate'] = '2025-03-12';
    return CatalogModel.fromRecords([record]).items.single;
  }

  Future<void> pump(
    WidgetTester tester,
    CatalogItem item, {
    double width = 1280,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PanelObjectRow(item: item, onEdit: onEdit ?? () {}, onDelete: onDelete ?? () {}),
          ),
        ),
      ),
    );
  }

  AppIconButton action(WidgetTester tester, String prefix) => tester
      .widgetList<AppIconButton>(find.byType(AppIconButton))
      .firstWhere((button) => button.label!.startsWith(prefix));

  testWidgets('mostra título, código, subtema, criador, data e tipo', (tester) async {
    await pump(tester, itemWith());

    expect(find.text('Rio São Francisco'), findsOneWidget);
    expect(find.byType(ReferenceCode), findsOneWidget);
    expect(find.text('NMA_BH_03'), findsOneWidget);
    expect(find.text('Bacias Hidrográficas'), findsOneWidget);
    expect(find.text('Agência Nacional de Águas'), findsOneWidget);
    expect(find.text('inserido em 12 mar 2025'), findsOneWidget);
    expect(find.text('Documento'), findsOneWidget);
  });

  testWidgets('ações com o título no nome e as dicas', (tester) async {
    await pump(tester, itemWith());

    expect(action(tester, 'Abrir').label, 'Abrir o recurso de “Rio São Francisco”');
    expect(action(tester, 'Abrir').tooltip, 'Abrir o recurso numa aba nova');
    expect(action(tester, 'Editar').label, 'Editar “Rio São Francisco”');
    expect(action(tester, 'Editar').tooltip, 'Editar a ficha deste objeto');
    expect(action(tester, 'Excluir').label, 'Excluir “Rio São Francisco”');
    expect(action(tester, 'Excluir').tooltip, 'Excluir: pede confirmação antes de apagar');
  });

  testWidgets('a dica aparece no hover', (tester) async {
    await pump(tester, itemWith());

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.byIcon(Icons.edit_outlined)));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Editar a ficha deste objeto'), findsOneWidget);
  });

  testWidgets('título é link e, como "Editar", abre a edição; "Excluir" pede exclusão', (
    tester,
  ) async {
    var edits = 0;
    var deletes = 0;
    await pump(tester, itemWith(), onEdit: () => edits++, onDelete: () => deletes++);

    final title = tester.getSemantics(find.text('Rio São Francisco')).getSemanticsData();
    expect(title.flagsCollection.isLink, isTrue);
    await tester.tap(find.text('Rio São Francisco'));
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.tap(find.byIcon(Icons.delete_outline));
    expect(edits, 2);
    expect(deletes, 1);
  });

  testWidgets('"Abrir o recurso" abre o endereço', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester, itemWith());

    await tester.tap(find.byIcon(Icons.open_in_new));
    await tester.pump();

    expect(opened, ['https://www.exemplo.org/recurso']);
  });

  for (final location in ['', 'ftp://exemplo.org/arquivo']) {
    testWidgets('endereço "$location" desativa "Abrir o recurso"', (tester) async {
      final opened = fakeUrlLauncher();
      await pump(tester, itemWith(location: location));

      final open = action(tester, 'Abrir');
      expect(open.isDisabled, isTrue);
      expect(open.tooltip, 'Este objeto não tem endereço válido');
      await tester.tap(find.byIcon(Icons.open_in_new));
      await tester.pump();
      expect(opened, isEmpty);
    });
  }

  for (final width in [390.0, 768.0, 1280.0]) {
    testWidgets('título e criador longos não estouram em ${width.toInt()}', (tester) async {
      await pump(
        tester,
        itemWith(title: 'Título muito comprido ' * 6, creator: 'Instituição de pesquisa ' * 5),
        width: width,
      );

      expect(tester.takeException(), isNull);
      final title = tester.widget<Text>(find.textContaining('Título muito comprido'));
      expect(title.maxLines, 2);
    });
  }
}
