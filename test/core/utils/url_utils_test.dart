import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('displayDomain', () {
    test('tira o www.', () {
      expect(UrlUtils.displayDomain('https://www.ibge.gov.br/x'), 'ibge.gov.br');
    });

    test('mantém subdomínio', () {
      expect(UrlUtils.displayDomain('https://mapas.ibge.gov.br/x?y=1'), 'mapas.ibge.gov.br');
    });

    test('aceita http', () {
      expect(UrlUtils.displayDomain('http://exemplo.org'), 'exemplo.org');
    });

    for (final text in [
      'ibge.gov.br',
      'javascript:alert(1)',
      'texto com espaço',
      'https://a b.c',
    ]) {
      test('devolve "$text" como veio', () => expect(UrlUtils.displayDomain(text), text));
    }

    test('vazio fica vazio', () => expect(UrlUtils.displayDomain('  '), ''));
  });

  group('isOpenable', () {
    test('http e https abrem', () {
      expect(UrlUtils.isOpenable('http://exemplo.org'), isTrue);
      expect(UrlUtils.isOpenable('https://www.exemplo.org/a'), isTrue);
    });

    for (final text in [
      'exemplo.org',
      'javascript:alert(1)',
      'mailto:a@b.c',
      'texto com espaço',
      'https://a b.c',
      'https://',
      '',
    ]) {
      test('"$text" não abre', () => expect(UrlUtils.isOpenable(text), isFalse));
    }
  });
}
