import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/subtheme_subjects.dart';
import 'package:expogeo/features/theme/presentation/stores/subtheme_objects_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../catalog/catalog_test_data.dart';

import '../../support/semantics.dart';

void main() {
  Future<SubthemeObjectsStore> storeWith(List<CatalogRecord> records) async {
    final repository = FakeCatalogRepository();
    final catalog = CatalogStore(repository);
    final loading = catalog.ensureLoaded();
    repository.succeed(records);
    await loading;
    return SubthemeObjectsStore(SubthemeEnum.biomas, catalog);
  }

  Future<void> pump(
    WidgetTester tester,
    SubthemeObjectsStore store, {
    ValueChanged<String>? onSelected,
    double width = 1280,
  }) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SubthemeSubjects(store: store, onSelected: onSelected ?? (_) {}),
        ),
      ),
    );
  }

  final record = objectWith('NMA_BIO', 'A_01', subjects: ['Cerrado', 'Mata Atlântica']);

  testWidgets('rótulo em caixa alta com leitura normal, e assuntos como botões', (tester) async {
    await pump(tester, await tester.runAsync(() => storeWith([record])) as SubthemeObjectsStore);

    expect(find.text('ASSUNTOS FREQUENTES'), findsOneWidget);
    expect(find.bySemanticsLabel('Assuntos frequentes'), findsOneWidget);
    final data = tester.getSemantics(find.bySemanticsLabel('Cerrado')).getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(canFocus(data), isTrue);
  });

  testWidgets('tocar avisa o assunto', (tester) async {
    final selected = <String>[];
    await pump(
      tester,
      await tester.runAsync(() => storeWith([record])) as SubthemeObjectsStore,
      onSelected: selected.add,
    );

    await tester.tap(find.text('Mata Atlântica'));
    expect(selected, ['Mata Atlântica']);
  });

  testWidgets('some sem assuntos', (tester) async {
    await pump(
      tester,
      await tester.runAsync(() => storeWith([objectWith('NMA_BIO', 'A_01')]))
          as SubthemeObjectsStore,
    );

    expect(find.text('ASSUNTOS FREQUENTES'), findsNothing);
  });

  testWidgets('um ponto de foco por assunto', (tester) async {
    await pump(tester, await tester.runAsync(() => storeWith([record])) as SubthemeObjectsStore);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final first = FocusManager.instance.primaryFocus;
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final second = FocusManager.instance.primaryFocus;
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(first, isNot(same(second)));
    expect(FocusManager.instance.primaryFocus, same(first));
  });

  testWidgets('sem overflow com 8 assuntos em 320', (tester) async {
    final subjects = [for (var i = 0; i < 8; i++) 'Assunto bem comprido número $i'];
    await pump(
      tester,
      await tester.runAsync(() => storeWith([objectWith('NMA_BIO', 'A_01', subjects: subjects)]))
          as SubthemeObjectsStore,
      width: 320,
    );

    expect(tester.takeException(), isNull);
  });
}
