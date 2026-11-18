import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/admin/panel/presentation/editor/object_editor_form.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../catalog/catalog_test_data.dart';

ObjectEditorForm filledForm() {
  final form = ObjectEditorForm.create(
    theme: ThemeEnum.naturezaMeioAmbiente,
    subtheme: SubthemeEnum.baciasHidrograficas,
  );
  form.title.text = '  Atlas das águas ';
  form.description.text = 'Mapa das bacias.';
  form.subjects.text = 'Bacias, Rios, , bacias, Brasil';
  form.creator.text = 'ANA';
  form.location.text = 'https://www.ana.gov.br';
  form.type = ContentType.site;
  form.format = ContentFormat.html;
  form.rights.text = 'Licença livre';
  return form;
}

void main() {
  group('novo objeto', () {
    test('começa com os valores padrão, tipo e formato vazios', () {
      final form = ObjectEditorForm.create();
      addTearDown(form.dispose);

      expect(form.language.text, 'Português');
      expect(form.requirements.text, 'Acesso à internet');
      expect(form.preservation.text, 'Atualização do link ao longo do tempo');
      expect(form.type, isNull);
      expect(form.format, isNull);
      expect(form.reviewMonth, isNull);
      expect(form.reviewYear, isNull);
      expect(form.theme, isNull);
      expect(form.subtheme, isNull);
      expect(form.hasChanges, isFalse);
    });

    test('tema e subtema vêm da seleção; subtema de outro tema fica de fora', () {
      final form = ObjectEditorForm.create(
        theme: ThemeEnum.culturaPolitica,
        subtheme: SubthemeEnum.biomas,
      );
      addTearDown(form.dispose);

      expect(form.theme, ThemeEnum.culturaPolitica);
      expect(form.subtheme, isNull);
    });

    test('vazio lista as pendências na ordem da tela', () {
      final form = ObjectEditorForm.create();
      addTearDown(form.dispose);
      form.language.clear();
      form.preservation.clear();

      expect(form.missing().map((problem) => problem.label), [
        'o tema',
        'o subtema',
        'o título',
        'a descrição',
        'os assuntos',
        'o criador',
        'o endereço do recurso',
        'o tipo',
        'o formato',
        'o idioma',
        'os direitos',
        'a ação de preservação',
      ]);
    });
  });

  group('regras', () {
    test('trocar o tema limpa o subtema', () {
      final form = filledForm();
      addTearDown(form.dispose);

      form.theme = ThemeEnum.culturaPolitica;

      expect(form.subtheme, isNull);
      expect(form.missing().map((problem) => problem.field), [EditorField.subtheme]);
    });

    test('endereço sem http(s):// pede o começo certo', () {
      final form = filledForm();
      addTearDown(form.dispose);
      form.location.text = 'www.ana.gov.br';

      expect(form.missing().single.label, 'o endereço do recurso (comece com https://)');
      expect(form.problemOf(EditorField.location), 'Comece o endereço com https:// ou http://.');

      form.location.text = 'HTTP://ana.gov.br';
      expect(form.missing(), isEmpty);
    });

    test('ano de emissão só vale com 4 algarismos', () {
      final form = filledForm();
      addTearDown(form.dispose);

      form.issueYear.text = '202';
      expect(form.missing().single.label, 'o ano de emissão (use 4 algarismos)');

      form.issueYear.text = '2024';
      expect(form.missing(), isEmpty);
    });

    test('próxima revisão: mês e ano juntos, ou nenhum', () {
      final form = filledForm();
      addTearDown(form.dispose);

      form.reviewMonth = 12;
      final problem = form.missing().single;
      expect(problem.label, 'a próxima revisão do link (escolha o mês e o ano)');
      expect(problem.field, EditorField.reviewYear);
      expect(form.problemOf(EditorField.reviewYear), 'Escolha o mês e o ano.');
      expect(form.problemOf(EditorField.reviewMonth), isNull);

      form.reviewYear = 2026;
      expect(form.missing(), isEmpty);
    });

    test('erro abaixo de cada campo', () {
      final form = ObjectEditorForm.create();
      addTearDown(form.dispose);

      expect(form.problemOf(EditorField.title), 'Preencha o título.');
      expect(form.problemOf(EditorField.type), 'Escolha o tipo.');
      expect(form.problemOf(EditorField.subtheme), 'Escolha o subtema.');
      expect(form.problemOf(EditorField.note), isNull);
    });

    test('anos da revisão em volta do atual, com o gravado fora do intervalo', () {
      final form = ObjectEditorForm.create();
      addTearDown(form.dispose);

      expect(form.reviewYears(DateTime(2026, 11, 9)), [2025, 2026, 2027, 2028, 2029, 2030, 2031]);

      form.reviewYear = 2020;
      expect(form.reviewYears(DateTime(2026, 11, 9)).first, 2020);
    });

    test('voltar ao valor de antes não conta como alteração', () {
      final form = ObjectEditorForm.create();
      addTearDown(form.dispose);

      form.title.text = 'Novo';
      expect(form.hasChanges, isTrue);
      form.title.text = '';
      expect(form.hasChanges, isFalse);

      form.type = ContentType.video;
      expect(form.hasChanges, isTrue);
      form.type = null;
      expect(form.hasChanges, isFalse);
    });
  });

  group('montagem', () {
    test('textos aparados, opcionais vazios nulos, assuntos sem vazios nem repetidos', () {
      final form = filledForm();
      addTearDown(form.dispose);
      form.requirements.clear();

      final content = form.build(
        code: 'NMA_BH_06',
        docId: 'NMA_BH_06',
        insertionDate: DateTime(2026, 11, 9),
      );

      expect(content.contentInfo.title, 'Atlas das águas');
      expect(content.contentInfo.subjects, ['Bacias', 'Rios', 'Brasil']);
      expect(content.contentInfo.contentNote, isNull);
      expect(content.intellectualIndicator.collaborator, isNull);
      expect(content.originInfo.requirements, isNull);
      expect(content.registrationInfo.issueYear, isNull);
      expect(content.registrationInfo.registrationRules, isNull);
      expect(content.preservationAction?.operation, 'Atualização do link ao longo do tempo');
      expect(content.preservationAction?.updateDate, isNull);

      final json = content.toJson();
      expect(json['id'], 'NMA_BH_06');
      expect(json['subthemeId'], 'NMA_BH');
      expect(json['originInfo'], {
        'insertionDate': '2026-11-09',
        'language': 'Português',
        'type': 'site',
        'format': 'html',
      });
      expect(json['contentInfo'], isNot(contains('contentNote')));
      expect(json['preservationAction'], {'operation': 'Atualização do link ao longo do tempo'});
    });

    test('revisão gravada no dia 1 do mês', () {
      final form = filledForm()
        ..reviewMonth = 12
        ..reviewYear = 2026
        ..issueYear.text = '2024';
      addTearDown(form.dispose);

      final json = form
          .build(code: 'NMA_BH_06', docId: 'NMA_BH_06', insertionDate: DateTime(2026, 11, 9))
          .toJson();

      expect(json['preservationAction'], containsPair('updateDate', '2026-12-01'));
      expect(json['registrationInfo'], containsPair('issueYear', 2024));
    });
  });

  group('editar', () {
    ContentResponseModel stored(Map<String, dynamic> Function(Map<String, dynamic>) change) =>
        ContentResponseModel.fromJson(change(validContentJson()), 'doc');

    test('abre todos os campos como gravados', () {
      final content = stored(
        (data) => data
          ..['registrationInfo'] = {
            'location': 'https://exemplo.org',
            'issueYear': 2019,
            'registrationRules': 'Regra da curadoria',
          }
          ..['preservationAction'] = {'operation': 'Revisar', 'updateDate': '2026-12-01'},
      );
      final form = ObjectEditorForm.edit(
        theme: ThemeEnum.representacoesEspaciais,
        subtheme: SubthemeEnum.coordenadasGeograficas,
        content: content,
      );
      addTearDown(form.dispose);

      expect(form.title.text, content.contentInfo.title);
      expect(form.subjects.text, 'Coordenadas geográficas, Longitude, Latitude');
      expect(form.note.text, content.contentInfo.contentNote);
      expect(form.collaborator.text, content.intellectualIndicator.collaborator);
      expect(form.issueYear.text, '2019');
      expect(form.registrationRules.text, 'Regra da curadoria');
      expect(form.preservation.text, 'Revisar');
      expect(form.reviewMonth, 12);
      expect(form.reviewYear, 2026);
      expect(form.type, ContentType.site);
      expect(form.format, ContentFormat.texto);
      expect(form.hasChanges, isFalse);
      expect(form.missing(), isEmpty);
    });

    test('objeto gravado pelo diálogo antigo: rótulo e sem preservação', () {
      final content = stored(
        (data) => data
          ..remove('preservationAction')
          ..['originInfo'] = {
            'insertionDate': '2026-11-09T14:22:33.123',
            'language': 'Português',
            'type': 'Vídeo',
            'format': 'HTML',
          },
      );
      final form = ObjectEditorForm.edit(
        theme: ThemeEnum.representacoesEspaciais,
        subtheme: SubthemeEnum.coordenadasGeograficas,
        content: content,
      );
      addTearDown(form.dispose);

      expect(form.type, ContentType.video);
      expect(form.format, ContentFormat.html);
      expect(form.preservation.text, isEmpty);
      expect(form.reviewMonth, isNull);
      expect(form.missing().single.field, EditorField.preservation);
    });

    test('mantém a data de inserção recebida', () {
      final content = stored((data) => data);
      final form = ObjectEditorForm.edit(
        theme: ThemeEnum.representacoesEspaciais,
        subtheme: SubthemeEnum.coordenadasGeograficas,
        content: content,
      );
      addTearDown(form.dispose);

      final built = form.build(
        code: content.id,
        docId: content.docId,
        insertionDate: content.originInfo.insertionDate,
      );

      expect(built.originInfo.insertionDate, content.originInfo.insertionDate);
      expect(built.docId, 'doc');
    });
  });

  test('a prévia usa textos de exemplo nos campos vazios e o tipo Site', () {
    final form = ObjectEditorForm.create();
    addTearDown(form.dispose);

    final preview = form.preview(code: '');

    expect(preview.contentInfo.title, 'Título do objeto');
    expect(preview.contentInfo.description, 'A descrição aparece aqui.');
    expect(preview.intellectualIndicator.creator, 'Criador');
    expect(preview.originInfo.type, ContentType.site);

    form.title.text = 'Atlas';
    expect(form.preview(code: '').contentInfo.title, 'Atlas');
  });
}
