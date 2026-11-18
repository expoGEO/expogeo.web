import 'dart:convert';

import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../catalog/catalog_test_data.dart';

void main() {
  Map<String, dynamic> withPreservation(Object? value) {
    final data = validContentJson();
    if (value == null) {
      data.remove('preservationAction');
    } else {
      data['preservationAction'] = value;
    }
    return data;
  }

  test('lê a preservação de preservationAction', () {
    final content = ContentResponseModel.fromJson(
      withPreservation({'operation': 'Revisar o link', 'updateDate': '2026-12-01'}),
      'doc',
    );

    expect(content.preservationAction?.operation, 'Revisar o link');
    expect(content.preservationAction?.updateDate, DateTime(2026, 12));
  });

  test('sem a chave, sem preservação', () {
    final content = ContentResponseModel.fromJson(withPreservation(null), 'doc');

    expect(content.preservationAction, isNull);
  });

  for (final (label, value) in [
    ('data malformada', {'operation': 'Revisar', 'updateDate': 'ontem'}),
    ('valor que não é mapa', 'texto'),
  ]) {
    test('$label mantém o objeto, sem preservação', () {
      final content = ContentResponseModel.fromJson(withPreservation(value), 'doc');

      expect(content.id, isNotEmpty);
      expect(content.preservationAction, isNull);
    });
  }

  test('tipo e formato gravados pelo rótulo são reconhecidos', () {
    final data = validContentJson();
    (data['originInfo'] as Map<String, dynamic>)
      ..['type'] = 'Site'
      ..['format'] = 'HTML';

    final content = ContentResponseModel.fromJson(data, 'doc');

    expect(content.originInfo.type.name, 'site');
    expect(content.originInfo.format.name, 'html');
  });

  group('gravação no formato dos objetos já cadastrados', () {
    // Copiado do seed do ambiente de testes (NMA_BH_03), como está gravado no Firestore.
    Map<String, dynamic> seedRecord() =>
        jsonDecode(r'''
{
  "id": "NMA_BH_03",
  "themeId": "NMA",
  "themeTitle": "Natureza e Meio Ambiente",
  "subthemeId": "NMA_BH",
  "subthemeTitle": "Bacias Hidrográficas",
  "intellectualIndicator": {
    "creator": "Serviço Geológico do Brasil - SGB",
    "collaborator": "Serviço Geológico do Brasil - SGB"
  },
  "contentInfo": {
    "title": "Sistema de Informações de Águas Subterrâneas",
    "description": "O SIAGAS é um sistema de informações de águas subterrâneas, desenvolvido pelo Serviço Geológico do Brasil - SGB, constituído por uma base de dados de poços permanentemente atualizada, e de módulos capazes de realizar consultas, pesquisas, extração e geração de relatórios",
    "subjects": ["Bacias hidrográficas", "Brasil", "WebSIG"],
    "contentNote": "O SIAGAS, desenvolvido e mantido pelo SGB a partir do mapeamento e pesquisa hidrogeológica em todo o país, permite a gestão adequada da informação hidrogeológica e a sua integração com outros sistemas"
  },
  "originInfo": {
    "insertionDate": "2025-09-16",
    "language": "Português",
    "type": "site",
    "format": "outro",
    "requirements": "Acesso à internet"
  },
  "registrationInfo": {
    "location": "https://siagasweb.sgb.gov.br/layout/visualizar_mapa.php",
    "registrationRules": "Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO"
  },
  "rightsInfo": {"rights": "Licença livre"},
  "preservationAction": {
    "operation": "Atualização do link ao longo do tempo",
    "updateDate": "2026-12-01"
  }
}
''')
            as Map<String, dynamic>;

    test('ler e gravar um objeto do seed devolve o mesmo documento, na mesma ordem', () {
      final record = seedRecord();
      final written = ContentResponseModel.fromJson(record, 'NMA_BH_03').toJson();

      expect(written, record);
      expect(written.keys.toList(), record.keys.toList());
      for (final key in record.keys) {
        if (record[key] is Map) {
          expect((written[key] as Map).keys.toList(), (record[key] as Map).keys.toList());
        }
      }
    });

    test('objeto montado do zero tem as mesmas chaves e tipos de valor do seed', () {
      final content = ContentResponseModel(
        docId: 'NMA_BH_06',
        id: 'NMA_BH_06',
        theme: ThemeEnum.naturezaMeioAmbiente,
        subtheme: SubthemeEnum.baciasHidrograficas,
        intellectualIndicator: const IntellectualIndicator(creator: 'ANA', collaborator: 'IBGE'),
        contentInfo: const ContentInfo(
          title: 'Atlas das águas',
          description: 'Mapa das bacias.',
          subjects: ['Bacias'],
          contentNote: 'Nota',
        ),
        originInfo: OriginInfo(
          insertionDate: DateTime(2026, 11, 9, 14, 22),
          language: 'Português',
          type: ContentType.video,
          format: ContentFormat.html,
          requirements: 'Acesso à internet',
        ),
        registrationInfo: const RegistrationInfo(
          location: 'https://www.exemplo.org',
          registrationRules: 'Regra',
        ),
        rightsInfo: const RightsInfo(rights: 'Licença livre'),
        preservationAction: PreservationAction(
          operation: 'Atualização do link ao longo do tempo',
          updateDate: DateTime(2026, 12),
        ),
      );

      final written = content.toJson();
      final record = seedRecord();

      Object kind(Object? value) => switch (value) {
        Map() => {for (final entry in value.entries) entry.key: kind(entry.value)},
        List() => 'lista',
        String() => 'texto',
        int() => 'número',
        _ => '$value',
      };
      Object shape(Map<String, dynamic> map) => kind(map);

      expect(shape(written), shape(record));
      expect(written.keys.toList(), record.keys.toList());
      expect(written['themeId'], 'NMA');
      expect(written['subthemeId'], 'NMA_BH');
      expect(written['themeTitle'], 'Natureza e Meio Ambiente');
      expect(written['subthemeTitle'], 'Bacias Hidrográficas');
      expect(written['originInfo'], containsPair('insertionDate', '2026-11-09'));
      expect(written['originInfo'], containsPair('type', 'video'));
      expect(written['originInfo'], containsPair('format', 'html'));
      expect(written['preservationAction'], containsPair('updateDate', '2026-12-01'));
    });

    test('a sigla gravada de cada subtema do site é lida de volta como o mesmo subtema', () {
      for (final theme in ThemeDataModel.themes) {
        for (final subtheme in theme.subthemes) {
          final data = validContentJson()
            ..['themeId'] = theme.type.id
            ..['subthemeId'] = subtheme.type.id;
          final content = ContentResponseModel.fromJson(data, 'doc');

          expect(content.theme, theme.type);
          expect(content.subtheme, subtheme.type, reason: subtheme.type.id);
        }
      }
    });
  });
}
