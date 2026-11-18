import 'package:expogeo/core/models/content_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContentType.fromString', () {
    for (final type in ContentType.values) {
      test('${type.name} pelo nome e pelo rótulo', () {
        expect(ContentType.fromString(type.name), type);
        expect(ContentType.fromString(type.value), type);
      });
    }

    test('desconhecido vira outro', () {
      expect(ContentType.fromString('podcast'), ContentType.outro);
      expect(ContentType.fromString(''), ContentType.outro);
    });
  });

  group('ContentFormat.fromString', () {
    for (final format in ContentFormat.values) {
      test('${format.name} pelo nome e pelo rótulo', () {
        expect(ContentFormat.fromString(format.name), format);
        expect(ContentFormat.fromString(format.value), format);
      });
    }

    test('desconhecido vira outro', () {
      expect(ContentFormat.fromString('mp3'), ContentFormat.outro);
    });
  });

  test('toJson grava tipo e formato pelo nome, como os objetos já cadastrados', () {
    final origin = OriginInfo.fromJson({
      'insertionDate': '2025-03-12T00:00:00.000',
      'language': 'Português',
      'type': 'Vídeo',
      'format': 'audio',
    });

    expect(origin.type, ContentType.video);
    expect(origin.format, ContentFormat.audio);
    expect(origin.toJson()['type'], 'video');
    expect(origin.toJson()['format'], 'audio');
  });

  test('datas gravadas só com o dia, e lidas de volta', () {
    final origin = OriginInfo.fromJson({
      'insertionDate': '2024-12-05',
      'language': 'Português',
      'type': 'site',
      'format': 'outro',
    });
    const preservation = PreservationAction(operation: 'Revisar');
    final dated = PreservationAction.fromJson({'operation': 'Revisar', 'updateDate': '2026-12-01'});

    expect(origin.toJson()['insertionDate'], '2024-12-05');
    expect(OriginInfo.fromJson(origin.toJson()).insertionDate, DateTime(2024, 12, 5));
    expect(dated.toJson(), {'operation': 'Revisar', 'updateDate': '2026-12-01'});
    expect(preservation.toJson(), {'operation': 'Revisar'});
  });

  test('data gravada com hora continua sendo lida', () {
    final origin = OriginInfo.fromJson({
      'insertionDate': '2026-11-09T14:22:33.123',
      'language': 'Português',
      'type': 'Site',
      'format': 'HTML',
    });

    expect(origin.insertionDate, DateTime(2026, 11, 9, 14, 22, 33, 123));
    expect(origin.toJson()['insertionDate'], '2026-11-09');
  });
}
