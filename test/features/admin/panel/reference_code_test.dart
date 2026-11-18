import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/reference_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<String> codes(String prefix, Iterable<int> numbers) => [
    for (final n in numbers) formatCode(prefix, n),
  ];

  group('parseCode', () {
    test('separa prefixo e número', () {
      expect(parseCode('NMA_PAG_06'), (prefix: 'NMA_PAG', number: 6));
      expect(parseCode('NMA_TPCL_10'), (prefix: 'NMA_TPCL', number: 10));
    });

    test('código sem número não é lido', () {
      expect(parseCode('NMA-BIO-01'), isNull);
      expect(parseCode('RE_CG'), isNull);
      expect(parseCode(''), isNull);
    });
  });

  group('nextCode', () {
    test('Bacias Hidrográficas com _01 a _05 vai para _06', () {
      expect(
        nextCode(codes('NMA_BH', [1, 2, 3, 4, 5]), SubthemeEnum.baciasHidrograficas),
        'NMA_BH_06',
      );
    });

    test('Poluição da Água segue o prefixo usado nos objetos, NMA_PAG', () {
      expect(
        nextCode(codes('NMA_PAG', [1, 2, 3, 4, 5, 6]), SubthemeEnum.poluicaoAgua),
        'NMA_PAG_07',
      );
    });

    test('depois de _09 vem _10', () {
      expect(nextCode(codes('NMA_SUS', [8, 9]), SubthemeEnum.sustentabilidade), 'NMA_SUS_10');
    });

    test('número de objeto excluído não volta enquanto houver um maior', () {
      expect(nextCode(['NMA_BH_01', 'NMA_BH_03'], SubthemeEnum.baciasHidrograficas), 'NMA_BH_04');
    });

    test('subtema sem objetos começa em _01 com a sigla da lista', () {
      expect(nextCode(const [], SubthemeEnum.poluicaoAgua), 'NMA_PA_01');
    });

    test('código sem número é ignorado', () {
      expect(nextCode(['NMA-BH-09', 'NMA_BH_02'], SubthemeEnum.baciasHidrograficas), 'NMA_BH_03');
      expect(nextCode(['qualquer'], SubthemeEnum.queimadas), 'NMA_QUE_01');
    });

    test('vale o prefixo mais usado; no empate, o do maior número', () {
      expect(
        nextCode(['NMA_PAG_01', 'NMA_PAG_02', 'NMA_PA_05'], SubthemeEnum.poluicaoAgua),
        'NMA_PAG_06',
      );
      expect(nextCode(['NMA_PAG_01', 'NMA_PA_03'], SubthemeEnum.poluicaoAgua), 'NMA_PA_04');
    });
  });

  test('following dá o número seguinte', () {
    expect(following('NMA_BH_06'), 'NMA_BH_07');
    expect(following('NMA_SUS_99'), 'NMA_SUS_100');
  });
}
