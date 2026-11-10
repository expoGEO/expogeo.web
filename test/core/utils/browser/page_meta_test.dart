import 'package:expogeo/core/utils/browser/page_meta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PageMeta', () {
    test('titled acrescenta o nome do site ao título', () {
      final meta = PageMeta.titled(title: 'Sobre a expoGEO', description: 'x', path: '/sobre');
      expect(meta.title, 'Sobre a expoGEO · expoGEO');
    });

    test('canonicalUrl junta origem e caminho', () {
      const meta = PageMeta(title: 't', description: 'd', path: '/sobre');
      expect(meta.canonicalUrl('https://expogeo.com.br'), 'https://expogeo.com.br/sobre');
    });

    test('canonicalUrl da home termina em barra', () {
      const meta = PageMeta(title: 't', description: 'd', path: '/');
      expect(meta.canonicalUrl('https://expogeo.com.br'), 'https://expogeo.com.br/');
    });

    test('canonicalUrl tira a barra final para não duplicar o endereço', () {
      const meta = PageMeta(title: 't', description: 'd', path: '/sobre/');
      expect(meta.canonicalUrl('https://expogeo.com.br'), 'https://expogeo.com.br/sobre');
    });
  });

  group('summarize', () {
    test('mantém o texto curto e junta quebras de linha', () {
      expect(summarize('Um  texto\ncurto.'), 'Um texto curto.');
    });

    test('corta em palavra inteira e termina com reticências', () {
      final text = List.filled(40, 'geografia').join(' ');
      final result = summarize(text, max: 50);
      expect(result.length, lessThanOrEqualTo(50));
      expect(result, endsWith('geografia…'));
    });

    test('não deixa pontuação antes das reticências', () {
      final result = summarize('${'a' * 20}, ${'b' * 20}. ${'c' * 20}', max: 47);
      expect(result, isNot(contains('.…')));
      expect(result, isNot(contains(',…')));
    });
  });
}
