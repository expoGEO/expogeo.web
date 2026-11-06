import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/subtheme_lead.dart';
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

  Future<void> pump(WidgetTester tester, SubthemeEnum subtheme) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SubthemeLead(subtheme: subtheme, store: store),
        ),
      ),
    );
  }

  testWidgets('plural com a contagem do subtema', (tester) async {
    await pump(tester, SubthemeEnum.biomas);
    store.ensureLoaded();
    repository.succeed();
    await tester.pump();

    expect(find.text('7 objetos digitais selecionados sobre biomas.'), findsOneWidget);
  });

  testWidgets('singular', (tester) async {
    await pump(tester, SubthemeEnum.biomas);
    store.ensureLoaded();
    repository.succeed([recordAt('NMA_BIO', 'um')]);
    await tester.pump();

    expect(find.text('1 objeto digital selecionado sobre biomas.'), findsOneWidget);
  });

  testWidgets('subtema com acentos, em minúsculas', (tester) async {
    await pump(tester, SubthemeEnum.historiaCartografia);
    store.ensureLoaded();
    repository.succeed();
    await tester.pump();

    expect(
      find.text('5 objetos digitais selecionados sobre história da cartografia.'),
      findsOneWidget,
    );
  });

  testWidgets('esqueleto antes e durante a carga', (tester) async {
    await pump(tester, SubthemeEnum.biomas);
    expect(find.byType(AppSkeleton), findsOneWidget);

    store.ensureLoaded();
    await tester.pump();
    expect(find.byType(AppSkeleton), findsOneWidget);
    repository.succeed();
    await tester.pump();
  });

  testWidgets('com erro, nada', (tester) async {
    await pump(tester, SubthemeEnum.biomas);
    store.ensureLoaded();
    repository.fail();
    await tester.pump();

    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('com zero objetos, nada', (tester) async {
    await pump(tester, SubthemeEnum.biomas);
    store.ensureLoaded();
    repository.succeed([recordAt('NMA_SUS', 'outro')]);
    await tester.pump();

    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.byType(Text), findsNothing);
  });
}
