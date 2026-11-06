import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/theme_header_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../catalog/catalog_test_data.dart';

void main() {
  late FakeCatalogRepository repository;
  late CatalogStore store;

  setUp(() {
    repository = FakeCatalogRepository();
    store = CatalogStore(repository);
  });

  final natureza = ThemeDataModel.themes[1];

  ThemeModel withSubthemes(int count) => ThemeModel(
    type: natureza.type,
    title: natureza.title,
    description: natureza.description,
    imagePath: natureza.imagePath,
    color: natureza.color,
    icon: natureza.icon,
    subthemes: natureza.subthemes.take(count).toList(),
  );

  Future<void> pump(WidgetTester tester, ThemeModel theme) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ThemeHeaderStats(theme: theme, store: store),
      ),
    ),
  );

  testWidgets('carregando: esqueleto e leitura só dos subtemas', (tester) async {
    await pump(tester, natureza);

    expect(find.byType(AppSkeleton), findsOneWidget);
    expect(find.bySemanticsLabel('12 subtemas'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('objeto')), findsNothing);
  });

  testWidgets('com os dados do dev, mostra subtemas e objetos', (tester) async {
    final load = store.ensureLoaded();
    await pump(tester, natureza);
    repository.succeed();
    await load;
    await tester.pump();

    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.bySemanticsLabel('12 subtemas'), findsOneWidget);
    expect(find.bySemanticsLabel('74 objetos digitais'), findsOneWidget);
  });

  testWidgets('erro: omite os objetos e mantém os subtemas', (tester) async {
    final load = store.ensureLoaded();
    repository.fail();
    await load;
    await pump(tester, natureza);

    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.bySemanticsLabel('12 subtemas'), findsOneWidget);
    expect(find.textContaining('objeto', findRichText: true), findsNothing);
  });

  testWidgets('singular com um subtema e um objeto', (tester) async {
    final load = store.ensureLoaded();
    repository.succeed([recordAt('NMA_BIO', 'um')]);
    await load;
    await pump(tester, withSubthemes(1));

    expect(find.bySemanticsLabel('1 subtema'), findsOneWidget);
    expect(find.bySemanticsLabel('1 objeto digital'), findsOneWidget);
  });

  testWidgets('catálogo vazio mostra 0 objetos digitais', (tester) async {
    final load = store.ensureLoaded();
    repository.succeed([]);
    await load;
    await pump(tester, natureza);

    expect(find.bySemanticsLabel('0 objetos digitais'), findsOneWidget);
  });
}
