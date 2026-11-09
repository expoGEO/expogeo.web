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
}
