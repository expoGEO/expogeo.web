import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/home/components/hero_counts.dart';
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

  Future<void> pump(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: HeroCounts(store: store)),
      ),
    );
  }

  testWidgets('carregando mostra esqueleto no número de objetos e os outros na hora', (
    tester,
  ) async {
    store.ensureLoaded();
    await pump(tester);

    expect(find.byType(AppSkeleton), findsOneWidget);
    expect(find.bySemanticsLabel('31 subtemas'), findsOneWidget);
    expect(find.bySemanticsLabel('4 temas'), findsOneWidget);
    expect(find.text('objetos digitais'), findsOneWidget);
  });

  testWidgets('sucesso mostra o total lido como frase', (tester) async {
    final load = store.ensureLoaded();
    repository.succeed();
    await load;
    await pump(tester);

    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.text('190'), findsOneWidget);
    expect(find.bySemanticsLabel('190 objetos digitais'), findsOneWidget);
  });

  testWidgets('erro esconde os objetos e mantém subtemas e temas', (tester) async {
    await pump(tester);
    final load = store.ensureLoaded();
    repository.fail();
    await load;
    await tester.pump();

    expect(find.text('objetos digitais'), findsNothing);
    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.text('31'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });
}
