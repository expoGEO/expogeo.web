import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/chip/filter_chip_button.dart';
import 'package:expogeo/core/components/state/state_message_box.dart';
import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/object_row.dart';
import 'package:expogeo/features/theme/components/subtheme_objects_section.dart';
import 'package:expogeo/features/theme/presentation/stores/subtheme_objects_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../catalog/catalog_test_data.dart';

void main() {
  late FakeCatalogRepository repository;
  late CatalogStore catalog;
  late SubthemeObjectsStore store;
  late TextEditingController controller;
  late FocusNode searchFocus;

  final natureza = ThemeDataModel.themes.firstWhere(
    (theme) => theme.type == ThemeEnum.naturezaMeioAmbiente,
  );

  setUp(() {
    repository = FakeCatalogRepository();
    catalog = CatalogStore(repository);
    store = SubthemeObjectsStore(SubthemeEnum.biomas, catalog);
    controller = TextEditingController();
    searchFocus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(searchFocus.dispose);
  });

  List<CatalogRecord> seven() => [
    for (var n = 1; n <= 7; n++)
      objectWith(
        'NMA_BIO',
        'NMA_BIO_0$n',
        title: n == 1 ? 'Mapa dos biomas' : 'Objeto $n',
        type: n.isEven ? 'video' : 'site',
        subjects: const ['Cerrado'],
      ),
  ];

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: SingleChildScrollView(
              child: SubthemeObjectsSection(
                theme: natureza,
                store: store,
                controller: controller,
                searchFocusNode: searchFocus,
              ),
            ),
          ),
        ),
        GoRoute(path: natureza.type.route, builder: (context, state) => const Text('tema')),
        GoRoute(
          path: '${SubthemeEnum.biomas.route}/:code',
          builder: (context, state) => Text('objeto ${state.pathParameters['code']}'),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  Future<void> load(WidgetTester tester, [List<CatalogRecord>? records]) async {
    await pump(tester);
    catalog.ensureLoaded();
    await tester.pump();
    repository.succeed(records ?? seven());
    await tester.pump();
    await tester.pump();
  }

  testWidgets('esqueleto sem campo nem chips', (tester) async {
    await pump(tester);
    catalog.ensureLoaded();
    await tester.pump();

    expect(find.byType(ObjectRowSkeleton), findsNWidgets(3));
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(FilterChipButton), findsNothing);
    repository.succeed(seven());
    await tester.pump();
  });

  testWidgets('erro e nova tentativa com sucesso', (tester) async {
    await pump(tester);
    catalog.ensureLoaded();
    await tester.pump();
    repository.fail();
    await tester.pump();
    await tester.pump();

    expect(find.text('Não conseguimos carregar os objetos'), findsOneWidget);
    expect(find.text('Confira sua conexão com a internet e tente de novo.'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.text('Tentar de novo'));
    await tester.pump();
    expect(find.byType(ObjectRowSkeleton), findsNWidgets(3));
    expect(repository.calls, 2);

    repository.succeed(seven());
    await tester.pump();
    await tester.pump();
    expect(find.byType(ObjectRow), findsNWidgets(6));
  });

  testWidgets('tentar de novo durante a carga não empilha consultas', (tester) async {
    await pump(tester);
    catalog.ensureLoaded();
    await tester.pump();
    repository.fail();
    await tester.pump();
    await tester.pump();

    store.retry();
    store.retry();
    await tester.pump();

    expect(repository.calls, 2);
    repository.succeed(seven());
    await tester.pump();
  });

  testWidgets('subtema vazio: caixa com volta ao tema, sem campo, chips e assuntos', (
    tester,
  ) async {
    await load(tester, [objectWith('NMA_SUS', 'NMA_SUS_01')]);

    expect(find.text('Nenhum objeto neste subtema ainda'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(FilterChipButton), findsNothing);
    expect(find.text('ASSUNTOS FREQUENTES'), findsNothing);

    await tester.tap(find.text('Voltar a ${natureza.title}'));
    await tester.pumpAndSettle();
    expect(find.text('tema'), findsOneWidget);
  });

  testWidgets('busca sem resultado e "Limpar busca"', (tester) async {
    await load(tester);
    store.selectType(ContentType.video);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'permafrost');
    await tester.pump();

    expect(find.text('Nenhum objeto encontrado'), findsOneWidget);
    expect(
      find.text(
        'Nada em Biomas combina com “permafrost”. Tente outra palavra ou veja todos os tipos.',
      ),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.bySemanticsLabel('Todos, 0 objetos'), findsOneWidget);
    expect(find.text('ASSUNTOS FREQUENTES'), findsOneWidget);
    expect(find.textContaining('Mostrando'), findsNothing);

    searchFocus.unfocus();
    await tester.pump();
    await tester.tap(
      find.descendant(of: find.byType(StateMessageBox), matching: find.text('Limpar busca')),
    );
    await tester.pump();
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(store.type, isNull);
    expect(find.byType(ObjectRow), findsNWidgets(6));
    expect(searchFocus.hasFocus, isTrue);
  });

  testWidgets('contagem: plural, singular e busca', (tester) async {
    await load(tester);
    expect(find.text('Mostrando 6 de 7 objetos'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'mapa');
    await tester.pump();
    expect(find.text('Mostrando 1 de 1 objeto para “mapa”'), findsOneWidget);
  });

  testWidgets('contagem é região anunciada', (tester) async {
    await load(tester);

    final data = tester
        .getSemantics(find.bySemanticsLabel('Mostrando 6 de 7 objetos'))
        .getSemanticsData();
    expect(data.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('"Ver ficha" leva à página do objeto', (tester) async {
    await load(tester);

    expect(find.text('Ver ficha'), findsNWidgets(6));
    await tester.tap(find.text('Ver ficha').first);
    await tester.pumpAndSettle();
    expect(find.text('objeto nma-bio-01'), findsOneWidget);
  });

  testWidgets('o título é link e leva à página do objeto', (tester) async {
    await load(tester);

    final link = tester.getSemantics(find.bySemanticsLabel('Mapa dos biomas').first);
    expect(link.getSemanticsData().flagsCollection.isLink, isTrue);
    await tester.tap(find.text('Mapa dos biomas'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('objeto nma-bio-01'), findsOneWidget);
  });

  testWidgets('"Carregar mais" acrescenta, some e leva o foco ao título do sétimo', (tester) async {
    await load(tester);
    expect(find.byType(ObjectRow), findsNWidgets(6));

    await tester.tap(find.text('Carregar mais'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(ObjectRow), findsNWidgets(7));
    expect(find.text('Carregar mais'), findsNothing);
    expect(find.text('Mostrando 7 de 7 objetos'), findsOneWidget);

    final focused = FocusManager.instance.primaryFocus?.context;
    final row = focused?.findAncestorWidgetOfExactType<ObjectRow>();
    expect(row?.item.content.id, 'NMA_BIO_07');
    expect(focused?.findAncestorWidgetOfExactType<AppButton>(), isNull);
  });

  testWidgets('subtema com até 6 objetos não mostra "Carregar mais"', (tester) async {
    await load(tester, seven().take(6).toList());

    expect(find.text('Carregar mais'), findsNothing);
  });

  testWidgets('assunto preenche a busca e volta a "Todos"', (tester) async {
    await load(tester);
    store.selectType(ContentType.video);
    await tester.pump();

    await tester.tap(find.text('Cerrado').first);
    await tester.pump();

    expect(controller.text, 'Cerrado');
    expect(store.query, 'Cerrado');
    expect(store.type, isNull);
  });
}
