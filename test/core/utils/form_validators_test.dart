import 'package:expogeo/core/utils/validators/form_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('required', () {
    final rule = FormValidators.required('Escreva.');

    test('vazio, nulo e só espaços contam como vazio', () {
      expect(rule(''), 'Escreva.');
      expect(rule(null), 'Escreva.');
      expect(rule('  \n '), 'Escreva.');
    });

    test('texto vale', () => expect(rule(' Ana '), isNull));
  });

  group('email', () {
    final rule = FormValidators.email('Inválido.');

    test('aceita o formato algo@algo.algo, com espaços nas pontas', () {
      expect(rule('nome@exemplo.com'), isNull);
      expect(rule('  nome@exemplo.com.br '), isNull);
    });

    test('recusa o que foge do formato', () {
      for (final value in [
        null,
        '',
        'nome',
        'nome.exemplo.com',
        'nome@exemplo',
        'no me@exemplo.com',
        'nome@exem plo.com',
        'nome@@exemplo.com',
        'a@b@exemplo.com',
      ]) {
        expect(rule(value), 'Inválido.', reason: '$value');
      }
    });
  });
}
