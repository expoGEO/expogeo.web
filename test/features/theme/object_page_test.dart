import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/card/object_card.dart';
import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/components/state/state_message_box.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/pages/not_found_page.dart';
import 'package:expogeo/features/catalog/presentation/stores/catalog_store.dart';
import 'package:expogeo/features/theme/components/object_sheet.dart';
import 'package:expogeo/features/theme/pages/object_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../catalog/catalog_test_data.dart';

import '../../support/semantics.dart';

void main() {
  late FakeCatalogRepository repository;
  late CatalogStore store;

  const biomasObject = '/natureza-meio-ambiente/biomas/nma-bio-01';

  setUp(() {
    repository = FakeCatalogRepository();
    store = CatalogStore(repository);
  });

  GoRouter routerAt(String location) => GoRouter(
    initialLocation: location,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Text('início')),
      for (final theme in ThemeDataModel.themes)
        GoRoute(
          path: '${theme.type.route}/:subthemeId/:code',
          builder: (context, state) => ObjectPage(
            themeId: theme.type.value,
            subthemeId: state.pathParameters['subthemeId']!,
            code: state.pathParameters['code']!,
            store: store,
          ),
        ),
    ],
  );

  Future<void> pump(WidgetTester tester, GoRouter router, {double width = 1280}) async {
    tester.view.physicalSize = Size(width, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('entrada direta faz uma consulta e mostra a página inteira', (tester) async {
    await pump(tester, routerAt(biomasObject));
    expect(repository.calls, 1);

    repository.succeed(biomasRecords());
    await settle(tester);

    expect(repository.calls, 1);
    expect(find.text('aVoar Cerrado'), findsOneWidget);
    expect(find.text('Acessar o recurso'), findsOneWidget);
    expect(find.byType(ObjectSheet), findsOneWidget);
    expect(find.text('Outros objetos de Biomas'), findsOneWidget);
    expect(find.byType(ObjectCard), findsNWidgets(3));
  });

  testWidgets('a nota aparece só quando existe', (tester) async {
    final router = routerAt('/natureza-meio-ambiente/biomas/nma-bio-02');
    await pump(tester, router);
    repository.succeed([
      objectWith('NMA_BIO', 'NMA_BIO_01', note: 'Atenção ao contexto'),
      objectWith('NMA_BIO', 'NMA_BIO_02'),
    ]);
    await settle(tester);
    expect(find.text('NOTA DE CONTEÚDO'), findsNothing);

    router.go(biomasObject);
    await settle(tester);
    expect(find.text('Atenção ao contexto'), findsOneWidget);
  });

  testWidgets('carregando: esqueleto, com voltar e migalhas, sem "Outros objetos"', (tester) async {
    await pump(tester, routerAt(biomasObject));

    expect(find.byType(AppSkeleton), findsWidgets);
    expect(find.bySemanticsLabel('Voltar para Biomas'), findsOneWidget);
    expect(find.bySemanticsLabel('Você está em'), findsOneWidget);
    expect(find.textContaining('Outros objetos'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('carregando: cabeçalho e ficha lidos uma vez como "Carregando…"', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, routerAt(biomasObject));

    expect(find.bySemanticsLabel('Carregando…'), findsOneWidget);
    repository.succeed(biomasRecords());
    await settle(tester);
    expect(find.bySemanticsLabel('Carregando…'), findsNothing);
    handle.dispose();
  });

  testWidgets('erro: caixa com "Tentar de novo" primário, que volta ao esqueleto e repete', (
    tester,
  ) async {
    await pump(tester, routerAt(biomasObject));
    repository.fail();
    await settle(tester);

    expect(find.text('Não conseguimos carregar o objeto'), findsOneWidget);
    expect(find.text('Confira sua conexão com a internet e tente de novo.'), findsOneWidget);
    expect(find.bySemanticsLabel('Voltar para Biomas'), findsOneWidget);
    expect(find.bySemanticsLabel('Você está em'), findsOneWidget);
    expect(find.byType(AppSkeleton), findsNothing);
    final retry = tester.widget<AppButton>(
      find.ancestor(of: find.text('Tentar de novo'), matching: find.byType(AppButton)),
    );
    expect(retry.kind, AppButtonKind.primary);
    expect(
      tester
          .widget<Icon>(
            find.descendant(of: find.byType(StateMessageBox), matching: find.byType(Icon)),
          )
          .icon,
      Icons.error_outline,
    );

    await tester.tap(find.text('Tentar de novo'));
    await tester.pump();
    expect(find.byType(AppSkeleton), findsWidgets);
    expect(find.byType(StateMessageBox), findsNothing);
    expect(repository.calls, 2);

    repository.succeed(biomasRecords());
    await settle(tester);
    expect(find.text('aVoar Cerrado'), findsOneWidget);
  });

  for (final location in [
    '/cultura-politica/biomas/nma-bio-01',
    '/representacoes-espaciais/movimentos-terra/re-cg-01',
    '/natureza-meio-ambiente/nao-existe/nma-bio-01',
  ]) {
    testWidgets('$location dá "não encontrada" na hora', (tester) async {
      await pump(tester, routerAt(location));

      expect(find.byType(NotFoundPage), findsOneWidget);
      expect(repository.calls, 0);
    });
  }

  for (final location in [
    '/natureza-meio-ambiente/biomas/nao-existe',
    '/natureza-meio-ambiente/sustentabilidade/nma-bio-01',
  ]) {
    testWidgets('$location dá "não encontrada" depois dos dados', (tester) async {
      await pump(tester, routerAt(location));
      expect(find.byType(NotFoundPage), findsNothing);

      repository.succeed(biomasRecords());
      await settle(tester);
      expect(find.byType(NotFoundPage), findsOneWidget);
      expect(find.text('Este lugar não está no mapa'), findsOneWidget);
    });
  }

  testWidgets('abrir outro objeto volta ao topo e zera "Link copiado"', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pump(tester, routerAt(biomasObject), width: 390);
    tester.view.physicalSize = const Size(390, 800);
    repository.succeed(biomasRecords());
    await settle(tester);

    await tester.tap(find.text('Copiar link'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Link copiado'), findsOneWidget);

    final scrollable = find.byType(Scrollable).first;
    tester.state<ScrollableState>(scrollable).position.jumpTo(1200);
    await tester.pump();

    final card = find.byType(ObjectCard).first;
    await tester.ensureVisible(card);
    await tester.pump();
    await tester.tap(card);
    await settle(tester);

    expect(find.text('Copiar link'), findsOneWidget);
    expect(find.text('Link copiado'), findsNothing);
    expect(tester.state<ScrollableState>(find.byType(Scrollable).first).position.pixels, 0);
  });

  testWidgets('um único h1, um h2 da ficha, um dos outros, e h3 nos grupos e cartões', (
    tester,
  ) async {
    await pump(tester, routerAt(biomasObject));
    repository.succeed(biomasRecords());
    await settle(tester);

    final levels = [
      for (final widget in tester.widgetList<Semantics>(find.byType(Semantics)))
        if (widget.properties.headingLevel case final level? when level > 0) level,
    ];
    expect(levels.where((level) => level == 1), hasLength(1));
    expect(levels.where((level) => level == 2), hasLength(2));
    expect(levels.where((level) => level == 3).length, greaterThanOrEqualTo(7));
    expect(levels.first, 1);
  });

  testWidgets('item "Temas" fica ativo na navbar', (tester) async {
    await pump(tester, routerAt(biomasObject));
    repository.succeed(biomasRecords());
    await settle(tester);

    final item = tester.getSemantics(find.bySemanticsLabel('Temas')).getSemanticsData();
    expect(isMarked(item), isTrue);
  });

  for (final width in [320.0, 390.0, 768.0, 1280.0]) {
    testWidgets('sem overflow em $width', (tester) async {
      await pump(tester, routerAt(biomasObject), width: width);
      expect(tester.takeException(), isNull);

      repository.succeed(biomasRecords());
      await settle(tester);
      expect(tester.takeException(), isNull);
    });
  }
}
