import 'package:expogeo/core/components/skeleton/app_skeleton.dart';
import 'package:expogeo/features/catalog/infra/models/catalog_model.dart';
import 'package:expogeo/features/theme/components/object_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/semantics.dart';
import '../catalog/catalog_test_data.dart';

void main() {
  CatalogItem itemWith({
    String creator = 'IBGE',
    String? collaborator = 'INPE',
    List<String> subjects = const ['Cerrado', 'Amazônia'],
    String language = 'Português',
    String? requirements = 'Navegador',
    int? year = 2020,
    String? rules = 'Regra gravada',
    String rights = 'Domínio público',
    Object? preservation = const {'operation': 'Revisar o link', 'updateDate': '2026-12-01'},
    String format = 'html',
  }) {
    final record = objectWith(
      'NMA_BIO',
      'NMA_BIO_01',
      creator: creator,
      collaborator: collaborator,
      subjects: subjects,
      format: format,
    );
    final data = record.data;
    (data['originInfo'] as Map<String, dynamic>)
      ..['language'] = language
      ..['requirements'] = requirements
      ..['insertionDate'] = '2025-03-12';
    data['registrationInfo'] = <String, dynamic>{
      'location': 'https://www.exemplo.org/recurso',
      'issueYear': year,
      'registrationRules': rules,
    };
    data['rightsInfo'] = {'rights': rights};
    data['preservationAction'] = preservation;
    return CatalogModel.fromRecords([record]).items.single;
  }

  Future<void> pump(
    WidgetTester tester,
    CatalogItem item, {
    double width = 1280,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = Size(width, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ObjectSheet(item: item),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('mostra todos os campos, lidos em par', (tester) async {
    await pump(tester, itemWith());

    for (final label in [
      'Criador: IBGE',
      'Colaborador: INPE',
      'Assuntos: Cerrado, Amazônia',
      'Tipo: Site',
      'Formato: HTML',
      'Idioma: Português',
      'Requisitos: Navegador',
      'Inserido em: 12 mar 2025',
      'Código de referência: NMA_BIO_01',
      'Ano de emissão: 2020',
      'Regras de registro: Regra gravada',
      'Direitos: Domínio público',
      'Ação de preservação: Revisar o link',
      'Próxima revisão do link: dez 2026',
    ]) {
      expect(find.bySemanticsLabel(label), findsOneWidget, reason: label);
    }
  });

  testWidgets('títulos: h2 na ficha e h3 nos grupos', (tester) async {
    await pump(tester, itemWith());

    expectHeading(tester, find.bySemanticsLabel('Ficha da curadoria'), 2);
    for (final title in ['Autoria', 'Conteúdo', 'Origem', 'Registro', 'Direitos e preservação']) {
      expectHeading(tester, find.bySemanticsLabel(title), 3);
    }
  });

  testWidgets('o código aparece no cabeçalho e no grupo Registro', (tester) async {
    await pump(tester, itemWith());

    expect(find.text('NMA_BIO_01'), findsNWidgets(2));
  });

  for (final blank in ['', '   ']) {
    testWidgets('colaborador "$blank" não aparece', (tester) async {
      await pump(tester, itemWith(collaborator: blank));

      expect(find.text('COLABORADOR'), findsNothing);
    });

    testWidgets('requisitos, idioma e direitos "$blank" não aparecem', (tester) async {
      await pump(tester, itemWith(requirements: blank, language: blank, rights: blank));

      expect(find.text('REQUISITOS'), findsNothing);
      expect(find.text('IDIOMA'), findsNothing);
      expect(find.text('DIREITOS'), findsNothing);
    });

    testWidgets('grupo Autoria sem nenhum campo some', (tester) async {
      await pump(tester, itemWith(creator: blank, collaborator: blank));

      expect(find.text('AUTORIA'), findsNothing);
    });

    testWidgets('grupo Conteúdo só com assunto "$blank" some', (tester) async {
      await pump(tester, itemWith(subjects: [blank]));

      expect(find.text('CONTEÚDO'), findsNothing);
      expect(find.text('ASSUNTOS'), findsNothing);
    });
  }

  testWidgets('sem ano, sem o par do ano', (tester) async {
    await pump(tester, itemWith(year: null));

    expect(find.text('ANO DE EMISSÃO'), findsNothing);
  });

  testWidgets('sem preservação, sem os dois itens', (tester) async {
    await pump(tester, itemWith(preservation: null));

    expect(find.text('AÇÃO DE PRESERVAÇÃO'), findsNothing);
    expect(find.text('PRÓXIMA REVISÃO DO LINK'), findsNothing);
  });

  testWidgets('preservação sem data mostra só a ação', (tester) async {
    await pump(tester, itemWith(preservation: const {'operation': 'Revisar'}));

    expect(find.text('AÇÃO DE PRESERVAÇÃO'), findsOneWidget);
    expect(find.text('PRÓXIMA REVISÃO DO LINK'), findsNothing);
  });

  for (final rules in [null, '', '   ']) {
    testWidgets('regras de registro "$rules" mostram o texto padrão', (tester) async {
      await pump(tester, itemWith(rules: rules));

      expect(find.text(ObjectSheet.defaultRegistrationRules), findsOneWidget);
    });
  }

  testWidgets('formato "Outro" aparece na ficha', (tester) async {
    await pump(tester, itemWith(format: 'outro'));

    expect(find.bySemanticsLabel('Formato: Outro'), findsOneWidget);
  });

  Rect rectOf(WidgetTester tester, String text) => tester.getRect(find.text(text));

  testWidgets('em 1280, três colunas e título do grupo à esquerda', (tester) async {
    await pump(tester, itemWith());

    final type = rectOf(tester, 'TIPO');
    expect(rectOf(tester, 'FORMATO').top, type.top);
    expect(rectOf(tester, 'IDIOMA').top, type.top);
    expect(rectOf(tester, 'REQUISITOS').top, greaterThan(type.top));
    expect(rectOf(tester, 'REQUISITOS').left, type.left);
    expect(rectOf(tester, 'ORIGEM').right, lessThan(type.left));
  });

  testWidgets('em 768, duas colunas e título do grupo à esquerda', (tester) async {
    await pump(tester, itemWith(), width: 768);

    final type = rectOf(tester, 'TIPO');
    expect(rectOf(tester, 'FORMATO').top, type.top);
    expect(rectOf(tester, 'IDIOMA').top, greaterThan(type.top));
    expect(rectOf(tester, 'ORIGEM').right, lessThan(type.left));
  });

  testWidgets('em 390, uma coluna e título do grupo acima', (tester) async {
    await pump(tester, itemWith(), width: 390);

    final type = rectOf(tester, 'TIPO');
    expect(rectOf(tester, 'FORMATO').top, greaterThan(type.top));
    expect(rectOf(tester, 'FORMATO').left, type.left);
    expect(rectOf(tester, 'ORIGEM').top, lessThan(type.top));
    expect(rectOf(tester, 'ORIGEM').left, type.left);
  });

  testWidgets('grupo com menos pares que colunas divide a largura', (tester) async {
    await pump(tester, itemWith());

    final creator = rectOf(tester, 'CRIADOR');
    final collaborator = rectOf(tester, 'COLABORADOR');
    final type = rectOf(tester, 'TIPO');
    final format = rectOf(tester, 'FORMATO');
    expect(collaborator.left - creator.left, greaterThan(format.left - type.left));
  });

  for (final width in [320.0, 390.0, 768.0, 1024.0, 1280.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('valores longos sem overflow em $width a ${scale * 100}%', (tester) async {
        await pump(
          tester,
          itemWith(
            creator: 'Instituto Brasileiro de Geografia e Estatística ' * 3,
            language: 'Português, Inglês, Espanhol, Francês, Guarani, Tupi ' * 2,
            subjects: ['Assunto bem longo de uma curadoria ' * 3, 'Outro'],
          ),
          width: width,
          textScale: scale,
        );

        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('esqueleto fica fora da leitura e sem overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: ObjectSheetSkeleton())),
      ),
    );

    expect(find.byType(AppSkeleton), findsWidgets);
    expect(find.bySemanticsLabel(RegExp('.+')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
