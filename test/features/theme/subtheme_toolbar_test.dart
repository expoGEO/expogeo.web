import 'package:expogeo/core/components/chip/filter_chip_button.dart';
import 'package:expogeo/core/components/field/app_search_field.dart';
import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/subtheme_toolbar.dart';
import 'package:expogeo/features/theme/presentation/stores/subtheme_objects_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../catalog/catalog_test_data.dart';

void main() {
  const allTypes = ['site', 'video', 'documento', 'aplicativo', 'imagem', 'outro'];

  Future<SubthemeObjectsStore> storeWith(List<CatalogRecord> records) async {
    final repository = FakeCatalogRepository();
    final catalog = CatalogStore(repository);
    final loading = catalog.ensureLoaded();
    repository.succeed(records);
    await loading;
    return SubthemeObjectsStore(SubthemeEnum.biomas, catalog);
  }

  List<CatalogRecord> oneOfEach() => [
    for (final (index, type) in allTypes.indexed)
      objectWith('NMA_BIO', 'A_0$index', title: 'objeto $type', type: type),
  ];

  Future<void> pump(WidgetTester tester, SubthemeObjectsStore store, {double width = 1280}) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SubthemeToolbar(store: store, controller: controller),
          ),
        ),
      ),
    );
  }

  testWidgets('em 1280, busca e chips na mesma faixa, chips à direita', (tester) async {
    await pump(tester, await tester.runAsync(() => storeWith(oneOfEach())) as SubthemeObjectsStore);

    final search = tester.getRect(find.byType(AppSearchField));
    final chip = tester.getRect(find.byType(FilterChipButton).last);
    expect(search.width, 520);
    expect(chip.left, greaterThan(search.left));
    expect(chip.right, closeTo(1280, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('em 768, busca até 520 e chips abaixo', (tester) async {
    await pump(
      tester,
      await tester.runAsync(() => storeWith(oneOfEach())) as SubthemeObjectsStore,
      width: 768,
    );

    final search = tester.getRect(find.byType(AppSearchField));
    expect(search.width, 520);
    expect(tester.getRect(find.byType(FilterChipButton).first).top, greaterThan(search.bottom));
  });

  testWidgets('em 390, busca em largura total e chips sem overflow', (tester) async {
    await pump(
      tester,
      await tester.runAsync(() => storeWith(oneOfEach())) as SubthemeObjectsStore,
      width: 390,
    );

    expect(tester.getSize(find.byType(AppSearchField)).width, 390);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chips na ordem da spec, com contagem e nomes', (tester) async {
    await pump(tester, await tester.runAsync(() => storeWith(oneOfEach())) as SubthemeObjectsStore);

    final labels = [
      for (final chip in tester.widgetList<FilterChipButton>(find.byType(FilterChipButton)))
        chip.label,
    ];
    expect(labels, ['Todos', 'Site', 'Vídeo', 'Documento', 'Aplicativo', 'Imagem', 'Outro']);
    expect(find.bySemanticsLabel('Todos, 6 objetos'), findsOneWidget);
    expect(find.bySemanticsLabel('Site, 1 objeto'), findsOneWidget);
    expect(find.bySemanticsLabel('Filtrar por tipo'), findsOneWidget);
  });

  testWidgets('tipo sem resultado não aparece', (tester) async {
    await pump(
      tester,
      await tester.runAsync(() => storeWith([objectWith('NMA_BIO', 'A_01')]))
          as SubthemeObjectsStore,
    );

    expect(find.byType(FilterChipButton), findsNWidgets(2));
    expect(find.text('Vídeo'), findsNothing);
  });

  testWidgets('tocar no chip escolhe o tipo; "Todos" volta', (tester) async {
    final store = await tester.runAsync(() => storeWith(oneOfEach())) as SubthemeObjectsStore;
    await pump(tester, store);

    await tester.tap(find.text('Vídeo'));
    await tester.pump();
    expect(store.type, ContentType.video);

    await tester.tap(find.text('Todos'));
    await tester.pump();
    expect(store.type, isNull);
  });

  testWidgets('digitar filtra e os chips acompanham', (tester) async {
    final store = await tester.runAsync(() => storeWith(oneOfEach())) as SubthemeObjectsStore;
    await pump(tester, store);

    await tester.enterText(find.byType(TextField), 'video');
    await tester.pump();

    expect(store.query, 'video');
    expect(find.byType(FilterChipButton), findsNWidgets(2));
    expect(find.bySemanticsLabel('Todos, 1 objeto'), findsOneWidget);
  });

  testWidgets('sem nada encontrado, "Todos 0"', (tester) async {
    final store = await tester.runAsync(() => storeWith(oneOfEach())) as SubthemeObjectsStore;
    await pump(tester, store);

    await tester.enterText(find.byType(TextField), 'permafrost');
    await tester.pump();

    expect(find.bySemanticsLabel('Todos, 0 objetos'), findsOneWidget);
  });
}
