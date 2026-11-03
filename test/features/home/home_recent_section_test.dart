import 'package:expogeo/core/components/card/object_card.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/home/components/home_recent_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../catalog/catalog_test_data.dart';

List<CatalogRecord> _records(int count) => [
  for (var day = 1; day <= count; day++)
    objectAt('NMA_BIO', 'NMA_BIO_0$day', date: DateTime(2025, 1, day)),
];

void main() {
  late FakeCatalogRepository repository;
  late CatalogStore store;

  setUp(() {
    repository = FakeCatalogRepository();
    store = CatalogStore(repository);
  });

  Future<void> pump(WidgetTester tester, {double width = 1280}) {
    tester.view.physicalSize = Size(width, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: SingleChildScrollView(child: HomeRecentSection(store: store)),
          ),
        ),
        GoRoute(
          path: '/:theme/:subtheme',
          builder: (context, state) =>
              Text('subtema ${state.pathParameters['theme']}/${state.pathParameters['subtheme']}'),
        ),
      ],
    );
    return tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  Future<void> load(List<CatalogRecord> records) async {
    final future = store.ensureLoaded();
    repository.succeed(records);
    await future;
  }

  testWidgets('carregando mostra 6 esqueletos', (tester) async {
    store.ensureLoaded();
    await pump(tester);

    expect(find.text('Adicionados recentemente'), findsOneWidget);
    expect(find.byType(ObjectCardSkeleton), findsNWidgets(6));
  });

  testWidgets('mostra os 6 mais recentes em ordem', (tester) async {
    await load(_records(8));
    await pump(tester);

    final titles = tester
        .widgetList<ObjectCard>(find.byType(ObjectCard))
        .map((card) => card.content.id);
    expect(titles, [
      'NMA_BIO_08',
      'NMA_BIO_07',
      'NMA_BIO_06',
      'NMA_BIO_05',
      'NMA_BIO_04',
      'NMA_BIO_03',
    ]);
  });

  testWidgets('com 4 objetos, mostra 4 cartões', (tester) async {
    await load(_records(4));
    await pump(tester);

    expect(find.byType(ObjectCard), findsNWidgets(4));
  });

  testWidgets('sem objetos, a seção some', (tester) async {
    await load(const []);
    await pump(tester);

    expect(find.text('Adicionados recentemente'), findsNothing);
    expect(find.byType(ObjectCard), findsNothing);
  });

  testWidgets('erro mostra a frase e "Tentar de novo" traz os cartões', (tester) async {
    final future = store.ensureLoaded();
    repository.fail();
    await future;
    await pump(tester);

    expect(find.text('Não conseguimos carregar os objetos recentes'), findsOneWidget);
    expect(find.byType(ObjectCard), findsNothing);

    await tester.tap(find.text('Tentar de novo'));
    await tester.pump();
    expect(repository.calls, 2);
    expect(find.byType(ObjectCardSkeleton), findsNWidgets(6));

    repository.succeed(_records(8));
    await tester.pumpAndSettle();
    expect(find.byType(ObjectCard), findsNWidgets(6));
    expect(find.text('Não conseguimos carregar os objetos recentes'), findsNothing);
  });

  for (final (width, columns) in [(390.0, 1), (768.0, 2), (1280.0, 3)]) {
    testWidgets('em ${width.toInt()} px, $columns coluna(s) sem overflow', (tester) async {
      await load(_records(8));
      await pump(tester, width: width);

      expect(tester.takeException(), isNull);
      final cards = find.byType(ObjectCard);
      final top = tester.getTopLeft(cards.first).dy;
      final inFirstRow = List.generate(
        6,
        (i) => tester.getTopLeft(cards.at(i)).dy,
      ).where((dy) => dy == top).length;
      expect(inFirstRow, columns);
    });
  }

  testWidgets('cartões da mesma linha têm a mesma altura', (tester) async {
    final records = _records(3);
    records[0] = objectAt(
      'NMA_BIO',
      'NMA_BIO_01',
      date: DateTime(2025, 1, 1),
      title: 'Um título bem mais longo que os outros, que ocupa mais de uma linha no cartão',
    );
    await load(records);
    await pump(tester);

    final cards = find.byType(ObjectCard);
    final heights = List.generate(3, (i) => tester.getSize(cards.at(i)).height);
    expect(heights.toSet(), hasLength(1));
  });

  testWidgets('tocar num cartão leva ao subtema do objeto', (tester) async {
    await load(_records(1));
    await pump(tester);

    await tester.tap(find.byType(ObjectCard));
    await tester.pumpAndSettle();

    expect(find.text('subtema natureza-meio-ambiente/biomas'), findsOneWidget);
  });
}
