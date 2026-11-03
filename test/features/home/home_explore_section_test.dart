import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/home/components/home_explore_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../catalog/catalog_test_data.dart';

void main() {
  late FakeCatalogRepository repository;
  late CatalogStore store;

  setUp(() {
    repository = FakeCatalogRepository();
    store = CatalogStore(repository);
  });

  Future<void> pump(WidgetTester tester, {double width = 1280}) {
    tester.view.physicalSize = Size(width, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: SingleChildScrollView(child: HomeExploreSection(store: store)),
          ),
        ),
        GoRoute(
          path: '/:theme',
          builder: (context, state) => Text('tema ${state.pathParameters['theme']}'),
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

  Future<void> fail() async {
    final future = store.ensureLoaded();
    repository.fail();
    await future;
  }

  testWidgets('mostra o rótulo, o título e os três passos com os textos', (tester) async {
    await load(biomasRecords());
    await pump(tester);

    expect(find.text('COMO EXPLORAR'), findsOneWidget);
    expect(find.text('Do tema ao recurso, em três passos'), findsOneWidget);
    expect(find.text('Escolha um tema'), findsOneWidget);
    expect(
      find.text('Quatro grandes temas da Geografia escolar, do mapa à política.'),
      findsOneWidget,
    );
    expect(find.text('Entre num subtema'), findsOneWidget);
    expect(
      find.text('Cada subtema reúne objetos sobre um assunto, com busca e filtro por tipo.'),
      findsOneWidget,
    );
    expect(find.text('Acesse o recurso'), findsOneWidget);
    expect(
      find.text('Veja a ficha da curadoria e abra o site, vídeo ou aplicativo na fonte original.'),
      findsOneWidget,
    );
  });

  testWidgets('h2 na seção e h3 em cada passo', (tester) async {
    await load(biomasRecords());
    await pump(tester);

    final h2 = tester.getSemantics(find.text('Do tema ao recurso, em três passos'));
    expect(h2.getSemanticsData().headingLevel, 2);
    for (final title in ['Escolha um tema', 'Entre num subtema', 'Acesse o recurso']) {
      final data = tester.getSemantics(find.text(title)).getSemanticsData();
      expect(data.flagsCollection.isHeader, isTrue);
      expect(data.headingLevel, 3);
    }
  });

  testWidgets('contagem de Biomas e título do primeiro objeto vêm do catálogo', (tester) async {
    await load([...devRecords(), ...biomasRecords()]);
    await pump(tester);

    // 7 do ambiente de testes e mais os 7 com código próprio.
    expect(find.text(' · 14 objetos'), findsOneWidget);
    expect(find.text('aVoar Cerrado'), findsOneWidget);
  });

  testWidgets('um objeto só fica no singular', (tester) async {
    await load([objectAt('NMA_BIO', 'NMA_BIO_01', date: DateTime(2024))]);
    await pump(tester);

    expect(find.text(' · 1 objeto'), findsOneWidget);
  });

  for (final (label, expected) in [
    ('Meio Ambiente e Natureza', 'tema natureza-meio-ambiente'),
    ('Biomas', 'subtema natureza-meio-ambiente/biomas'),
    ('aVoar Cerrado', 'subtema natureza-meio-ambiente/biomas'),
  ]) {
    testWidgets('o exemplo "$label" leva ao destino certo', (tester) async {
      await load(biomasRecords());
      await pump(tester);

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(find.text(expected), findsOneWidget);
    });
  }

  testWidgets('carregando mostra esqueleto na contagem e no exemplo 3', (tester) async {
    store.ensureLoaded();
    await pump(tester);

    expect(find.byType(AppSkeleton), findsNWidgets(2));
    expect(find.text('Biomas'), findsOneWidget);
    expect(find.text('Meio Ambiente e Natureza'), findsOneWidget);
  });

  testWidgets('no erro, Biomas fica sem contagem e o exemplo 3 some', (tester) async {
    await fail();
    await pump(tester);

    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.textContaining(' · '), findsNothing);
    expect(find.text('Ex.: '), findsNWidgets(2));
  });

  testWidgets('sem objetos, Biomas mostra 0 e o exemplo 3 some', (tester) async {
    await load(const []);
    await pump(tester);

    expect(find.text(' · 0 objetos'), findsOneWidget);
    expect(find.text('Ex.: '), findsNWidgets(2));
  });

  for (final width in [390.0, 768.0, 1280.0]) {
    testWidgets('em ${width.toInt()} px, sem overflow', (tester) async {
      await load(biomasRecords());
      await pump(tester, width: width);

      expect(tester.takeException(), isNull);
      final first = tester.getTopLeft(find.text('Escolha um tema'));
      final second = tester.getTopLeft(find.text('Entre num subtema'));
      expect(first.dy == second.dy, width >= 1024);
    });
  }
}
