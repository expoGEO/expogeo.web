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

  test('toJson continua gravando o rótulo', () {
    final origin = OriginInfo.fromJson({
      'insertionDate': '2025-03-12T00:00:00.000',
      'language': 'Português',
      'type': 'Vídeo',
      'format': 'audio',
    });

    expect(origin.type, ContentType.video);
    expect(origin.format, ContentFormat.audio);
    expect(origin.toJson()['type'], 'Vídeo');
    expect(origin.toJson()['format'], 'Áudio');
  });
}
