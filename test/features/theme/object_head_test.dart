import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/core/models/subtheme_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/models/theme_model.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/theme/components/object_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/semantics.dart';
import '../catalog/catalog_test_data.dart';

void main() {
  final ThemeModel theme = ThemeDataModel.themes.firstWhere(
    (model) => model.type == ThemeEnum.naturezaMeioAmbiente,
  );
  final SubthemeModel subtheme = theme.subthemes.firstWhere(
    (model) => model.type == SubthemeEnum.biomas,
  );

  CatalogItem itemWith({
    String title = 'Mapa dos biomas',
    String description = 'Um mapa interativo',
    String type = 'site',
    String format = 'html',
  }) => CatalogModel.fromRecords([
    objectWith(
      'NMA_BIO',
      'NMA_BIO_01',
      title: title,
      description: description,
      type: type,
      format: format,
    ),
  ]).items.single;

  Future<void> pump(
    WidgetTester tester, {
    CatalogItem? item,
    bool failed = false,
    double width = 1280,
  }) async {
    tester.view.physicalSize = Size(width, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ObjectHead(theme: theme, subtheme: subtheme, item: item, failed: failed),
              ),
            ),
          ),
        ),
        GoRoute(path: theme.type.route, builder: (context, state) => const Text('tema')),
        GoRoute(path: subtheme.type.route, builder: (context, state) => const Text('subtema')),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('mostra rótulo, título h1 e descrição', (tester) async {
    await pump(tester, item: itemWith());

    expect(find.text('SITE · HTML'), findsOneWidget);
    expect(find.bySemanticsLabel('Site · HTML'), findsOneWidget);
    expectHeading(tester, find.text('Mapa dos biomas'), 1);
    expect(find.text('Um mapa interativo'), findsOneWidget);
  });

  for (final (type, format, label) in [
    ('site', 'outro', 'SITE'),
    ('video', 'video', 'VÍDEO'),
    ('site', 'html', 'SITE · HTML'),
  ]) {
    testWidgets('$type/$format mostra "$label"', (tester) async {
      await pump(
        tester,
        item: itemWith(type: type, format: format),
      );

      expect(find.text(label), findsOneWidget);
    });
  }

  testWidgets('sem descrição, o espaço dela some', (tester) async {
    await pump(tester, item: itemWith(description: '   '));

    final title = tester.getRect(find.text('Mapa dos biomas'));
    final column = tester.getRect(find.byType(ObjectHead));
    expect(column.bottom, title.bottom);
  });

  testWidgets('voltar leva ao subtema, com nome próprio', (tester) async {
    await pump(tester, item: itemWith());

    expect(find.bySemanticsLabel('Voltar para ${subtheme.type.name}'), findsOneWidget);
    await tester.tap(find.text(subtheme.type.name).first);
    await tester.pumpAndSettle();
    expect(find.text('subtema'), findsOneWidget);
  });

  testWidgets('migalhas levam ao subtema e ao tema, e o objeto é a página atual', (tester) async {
    await pump(tester, item: itemWith());

    expect(find.bySemanticsLabel('Você está em'), findsOneWidget);
    expect(find.bySemanticsLabel('Objeto, página atual'), findsOneWidget);

    await tester.tap(find.text(subtheme.type.name).last);
    await tester.pumpAndSettle();
    expect(find.text('subtema'), findsOneWidget);
  });

  testWidgets('migalha do tema leva ao tema', (tester) async {
    await pump(tester, item: itemWith());

    await tester.tap(find.text(theme.title));
    await tester.pumpAndSettle();
    expect(find.text('tema'), findsOneWidget);
  });

  testWidgets('sem objeto, esqueleto fora da leitura, com voltar e migalhas', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester);

    expect(find.byType(AppSkeleton), findsWidgets);
    expect(find.bySemanticsLabel('Voltar para ${subtheme.type.name}'), findsOneWidget);
    expect(find.bySemanticsLabel('Você está em'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('com falha, só voltar e migalhas', (tester) async {
    await pump(tester, failed: true);

    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.bySemanticsLabel('Voltar para ${subtheme.type.name}'), findsOneWidget);
  });

  for (final width in [320.0, 390.0, 768.0, 1280.0]) {
    testWidgets('título longo sem overflow em $width', (tester) async {
      await pump(
        tester,
        item: itemWith(title: 'Título bem longo de objeto digital ' * 3),
        width: width,
      );
      expect(tester.takeException(), isNull);

      await pump(tester, width: width);
      expect(tester.takeException(), isNull);
    });
  }
}
