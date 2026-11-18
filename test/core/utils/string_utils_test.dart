import 'package:expogeo/core/utils/string/string_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ignora maiúsculas', () => expect(foldForSearch('CARTOGRAFIA'), 'cartografia'));

  test('ignora acentos', () => expect(foldForSearch('Água Órgão Pêssego'), 'agua orgao pessego'));

  test('troca ç por c', () => expect(foldForSearch('Poluição'), 'poluicao'));

  test('tira espaços das pontas', () => expect(foldForSearch('  mapa  '), 'mapa'));

  test('vazio continua vazio', () {
    expect(foldForSearch(''), '');
    expect(foldForSearch('   '), '');
  });

  for (final code in ['NMA_BH_03', 'nma-bh-03', 'nma_BH-03', '  NMA_BH_03  ']) {
    test('"$code" vira o código do endereço', () {
      expect(referenceCodeSlug(code), 'nma-bh-03');
    });
  }
}
