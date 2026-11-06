import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/theme/components/object_row.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/fake_url_launcher.dart';
import '../../support/semantics.dart';
import '../catalog/catalog_test_data.dart';

void main() {
  const biomas = 'NMA_BIO';

  CatalogItem item(CatalogRecord record) => CatalogModel.fromRecords([record]).items.single;

  CatalogItem full({
    String title = 'Mapa dos biomas',
    String description = 'Mapa interativo dos biomas brasileiros.',
    String creator = 'IBGE',
    int? year = 2019,
    List<String> subjects = const ['Biomas', 'Mapa', 'Cerrado', 'Amazônia'],
    String location = 'https://www.ibge.gov.br/biomas',
  }) => item(
    objectWith(
      biomas,
      'NMA_BIO_01',
      title: title,
      description: description,
      creator: creator,
      year: year,
      subjects: subjects,
      type: 'video',
      format: 'html',
      location: location,
    ),
  );

  Future<void> pump(
    WidgetTester tester,
    CatalogItem object, {
    String route = '/ficha',
    double width = 1280,
    double textScale = 1,
    FocusNode? focusNode,
  }) async {
    tester.view.physicalSize = Size(width, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: PageContent(
                  child: ObjectRow(item: object, detailsRoute: route, primaryFocusNode: focusNode),
                ),
              ),
            ),
          ),
        ),
        GoRoute(path: '/ficha', builder: (context, state) => const Text('ficha')),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  }

  testWidgets('mostra todos os campos', (tester) async {
    await pump(tester, full());

    expect(find.text('VÍDEO · HTML'), findsOneWidget);
    expect(find.bySemanticsLabel('Vídeo · HTML'), findsOneWidget);
    expect(find.text('Mapa dos biomas'), findsOneWidget);
    expect(find.text('Mapa interativo dos biomas brasileiros.'), findsOneWidget);
    expect(find.text('IBGE'), findsOneWidget);
    expect(find.text('2019'), findsOneWidget);
    expect(find.text('ibge.gov.br'), findsOneWidget);
    for (final subject in ['Biomas', 'Mapa', 'Cerrado', 'Amazônia']) {
      expect(find.text(subject), findsOneWidget);
    }
  });

  testWidgets('sem ano, criador, assuntos nem descrição não deixa buraco', (tester) async {
    await pump(tester, full(year: null, creator: ' ', subjects: const [], description: ' '));

    expect(find.text('2019'), findsNothing);
    expect(find.text('ibge.gov.br'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final title = tester.getRect(find.text('Mapa dos biomas'));
    final domain = tester.getRect(find.text('ibge.gov.br'));
    expect(domain.top - title.bottom, AppTheme.dimensions.components.objectRowTextGap);
  });

  testWidgets('5 assuntos mostram 4, e vazios não contam', (tester) async {
    await pump(tester, full(subjects: const ['A', ' ', 'B', 'C', 'D', 'E']));

    expect(find.text('D'), findsOneWidget);
    expect(find.text('E'), findsNothing);
  });

  testWidgets('o título leva à ficha', (tester) async {
    await pump(tester, full());

    await tester.tap(find.text('Mapa dos biomas'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('ficha'), findsOneWidget);
  });

  testWidgets('"Ver ficha" leva à ficha', (tester) async {
    await pump(tester, full());

    await tester.tap(find.text('Ver ficha'));
    await tester.pumpAndSettle();
    expect(find.text('ficha'), findsOneWidget);
  });

  testWidgets('título: um ponto de foco, com o h3 dentro do link', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    await pump(tester, full(), focusNode: node);

    expectHeading(tester, find.text('Mapa dos biomas'), 3);
    final link = tester.getSemantics(find.bySemanticsLabel('Mapa dos biomas').first);
    expect(link.getSemanticsData().flagsCollection.isLink, isTrue);
    expect(link.getSemanticsData().flagsCollection.isFocusable, isTrue);

    node.requestFocus();
    await tester.pump();
    expect(link.getSemanticsData().flagsCollection.isFocused, isTrue);
    final others = tester.widgetList<InkWell>(find.byType(InkWell));
    expect(others.where((ink) => identical(ink.focusNode, node)), hasLength(1));
  });

  testWidgets('"Acessar" abre o endereço e avisa a nova aba', (tester) async {
    final opened = fakeUrlLauncher();
    await pump(tester, full());

    expect(find.bySemanticsLabel('Acessar, abre em nova aba'), findsOneWidget);
    await tester.tap(find.text('Acessar'));
    await tester.pump();
    expect(opened, ['https://www.ibge.gov.br/biomas']);
  });

  testWidgets('endereço inválido mostra o texto e não mostra "Acessar"', (tester) async {
    await pump(tester, full(location: 'ibge.gov.br/biomas'));

    expect(find.text('ibge.gov.br/biomas'), findsOneWidget);
    expect(find.text('Acessar'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('endereço vazio não mostra domínio nem "Acessar"', (tester) async {
    await pump(tester, full(location: ''));

    expect(find.text('Acessar'), findsNothing);
    expect(find.text('IBGE'), findsOneWidget);
    expect(find.text(''), findsNothing);
  });

  testWidgets('hover troca o rótulo para o laranja forte e dá fundo', (tester) async {
    await pump(tester, full());
    Color? labelColor() => tester.widget<Text>(find.text('VÍDEO · HTML')).style?.color;
    expect(labelColor(), AppTheme.colors.accent);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.text('Mapa interativo dos biomas brasileiros.')));
    await tester.pump();

    expect(labelColor(), AppTheme.colors.accentStrong);
    final title = tester.widget<Text>(find.text('Mapa dos biomas'));
    expect(title.style?.color, AppTheme.colors.accentStrong);
    expect(title.style?.decoration, isNull);

    await mouse.moveTo(tester.getCenter(find.text('Mapa dos biomas')));
    await tester.pump();
    expect(
      tester.widget<Text>(find.text('Mapa dos biomas')).style?.decoration,
      TextDecoration.underline,
    );
  });

  testWidgets('em 1280, ações à direita e centralizadas na altura', (tester) async {
    await pump(tester, full());

    final text = tester.getRect(find.text('Mapa interativo dos biomas brasileiros.'));
    final action = tester.getRect(find.text('Acessar'));
    expect(action.left, greaterThan(text.left));
    final row = tester.getRect(find.byType(ObjectRow));
    expect(action.center.dy, closeTo(row.center.dy, 2));
    expect(
      find.byWidgetPredicate((w) => w is Container && w.constraints?.maxWidth == 44),
      findsOneWidget,
    );
  });

  for (final width in [768.0, 390.0]) {
    testWidgets('em $width, ações abaixo do texto, na coluna dele', (tester) async {
      await pump(tester, full());
      await pump(tester, full(), width: width);

      final tag = tester.getRect(find.text('Amazônia'));
      final title = tester.getRect(find.text('Mapa dos biomas'));
      final action = tester.getRect(find.byType(AppButton).first);
      expect(action.top, greaterThan(tag.bottom));
      expect(action.left, title.left);
      expect(
        find.byWidgetPredicate((w) => w is Container && w.constraints?.maxWidth == 36),
        findsOneWidget,
      );
    });
  }

  for (final width in [320.0, 390.0, 600.0, 768.0, 1024.0, 1280.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('texto longo sem overflow em $width a ${scale * 100}%', (tester) async {
        await pump(
          tester,
          full(
            description: 'Descrição muito longa e sem nenhum corte na lista. ' * 12,
            location: 'https://www.observatorio-nacional-de-biomas-do-brasil.org.br/x',
          ),
          width: width,
          textScale: scale,
        );

        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('descrição longa não é cortada', (tester) async {
    final description = ('Descrição longa. ' * 40).trim();
    await pump(tester, full(description: description));

    final text = tester.widget<Text>(find.text(description));
    expect(text.maxLines, isNull);
    expect(text.overflow, isNull);
  });

  testWidgets('esqueleto fica fora da leitura e sem overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PageContent(child: ObjectRowSkeleton())),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
