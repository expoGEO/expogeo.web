import 'package:expogeo/core/components/card/object_card.dart';
import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/failing_asset_bundle.dart';
import '../../support/semantics.dart';

ContentModel _content({
  String title = 'aVoar Cerrado',
  String description = 'Iniciativa de educação e divulgação científica sobre as aves do Cerrado.',
  String creator = 'Universidade de Brasília',
  ContentType type = ContentType.site,
  ContentFormat format = ContentFormat.html,
}) {
  return ContentModel(
    id: 'NMA_BIO_01',
    theme: ThemeEnum.naturezaMeioAmbiente,
    subtheme: SubthemeEnum.biomas,
    intellectualIndicator: IntellectualIndicator(creator: creator),
    contentInfo: ContentInfo(title: title, description: description, subjects: const []),
    originInfo: OriginInfo(
      insertionDate: DateTime(2024, 12, 13),
      language: 'Português',
      type: type,
      format: format,
    ),
    registrationInfo: const RegistrationInfo(location: 'https://exemplo.org'),
    rightsInfo: const RightsInfo(rights: 'Licença livre'),
  );
}

void main() {
  late int opened;

  setUp(() => opened = 0);

  Future<void> pump(
    WidgetTester tester, {
    ContentModel? content,
    double width = 1280,
    AssetBundle? bundle,
    int count = 1,
  }) {
    tester.view.physicalSize = Size(width, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final Widget page = Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              for (var i = 0; i < count; i++)
                ObjectCard(
                  content: content ?? _content(),
                  subtheme: SubthemeEnum.biomas,
                  onOpen: () => opened++,
                ),
            ],
          ),
        ),
      ),
    );
    return tester.pumpWidget(
      MaterialApp(
        home: bundle == null ? page : DefaultAssetBundle(bundle: bundle, child: page),
      ),
    );
  }

  testWidgets('mostra tipo · formato, título, subtema e criador', (tester) async {
    await pump(tester);

    expect(find.text('SITE · HTML'), findsOneWidget);
    expect(find.text('aVoar Cerrado'), findsOneWidget);
    expect(find.text('Biomas · Universidade de Brasília'), findsOneWidget);
    expect(find.byIcon(Icons.language), findsOneWidget);
  });

  testWidgets('formato igual ao tipo aparece uma vez só', (tester) async {
    await pump(
      tester,
      content: _content(type: ContentType.video, format: ContentFormat.video),
    );

    expect(find.text('VÍDEO'), findsOneWidget);
  });

  testWidgets('limita a descrição a 2 linhas e o título a 3', (tester) async {
    await pump(
      tester,
      content: _content(title: 'Título ' * 40, description: 'Descrição ' * 80),
    );

    final texts = tester.widgetList<Text>(find.byType(Text)).toList();
    final title = texts.firstWhere((text) => text.data!.startsWith('Título'));
    final description = texts.firstWhere((text) => text.data!.startsWith('Descrição'));
    expect(title.maxLines, 3);
    expect(title.overflow, TextOverflow.ellipsis);
    expect(description.maxLines, 2);
    expect(description.overflow, TextOverflow.ellipsis);
  });

  testWidgets('descrição vazia não deixa texto vazio no cartão', (tester) async {
    await pump(tester, content: _content(description: '  '));

    expect(find.text(''), findsNothing);
    expect(tester.widgetList<Text>(find.byType(Text)).length, 3);
  });

  testWidgets('Tab passa uma vez por cartão e Enter abre', (tester) async {
    await pump(tester, count: 2);
    final cards = find.byType(ObjectCard);

    bool focused(int index) => hasFocus(tester.getSemantics(cards.at(index)));

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect([focused(0), focused(1)], [true, false]);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect([focused(0), focused(1)], [false, true]);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(opened, 1);
  });

  testWidgets('o cartão é um link e o título é cabeçalho de nível 3', (tester) async {
    await pump(tester);

    final card = tester.getSemantics(find.byType(ObjectCard)).getSemanticsData();
    expect(card.flagsCollection.isLink, isTrue);
    expect(canFocus(card), isTrue);
    expect(card.label, 'aVoar Cerrado');

    final title = tester.getSemantics(find.text('aVoar Cerrado')).getSemanticsData();
    expect(title.flagsCollection.isHeader, isTrue);
    expect(title.headingLevel, 3);
  });

  for (final (name, target) in [
    ('ícone', () => find.byIcon(Icons.language)),
    ('descrição', () => find.textContaining('Iniciativa')),
    ('rodapé', () => find.textContaining('Universidade')),
  ]) {
    testWidgets('tocar no $name abre o objeto', (tester) async {
      await pump(tester);

      // O toque cai na camada clicável que cobre o cartão inteiro, não no próprio alvo.
      await tester.tap(target(), warnIfMissed: false);
      await tester.pump();

      expect(opened, 1);
    });
  }

  testWidgets('ilustração que falha mostra o placeholder', (tester) async {
    await pump(tester, bundle: FailingImageBundle());
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();

    expect(find.byIcon(Icons.map_outlined), findsOneWidget);
  });

  testWidgets('título e criador longos cabem em 390 px', (tester) async {
    await pump(
      tester,
      width: 390,
      content: _content(
        title: 'Atlas interativo das unidades de conservação e dos biomas brasileiros ' * 3,
        creator: 'Instituto Brasileiro de Geografia e Estatística e Ministério do Meio Ambiente',
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('o esqueleto tem altura própria e fica fora da árvore de acessibilidade', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(children: [IntrinsicHeight(child: ObjectCardSkeleton())]),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(ObjectCardSkeleton)).height, greaterThan(100));
  });
}
