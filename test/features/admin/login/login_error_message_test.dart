import 'package:expogeo/features/admin/login/infra/errors/auth_failure.dart';
import 'package:expogeo/features/admin/login/presentation/login_error_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('credenciais erradas viram um aviso único, sem dizer qual dado falhou', () {
    for (final failure in const [
      WrongPassword(),
      UserNotFound(),
      InvalidCredentials(),
      InvalidEmailAddress(),
    ]) {
      expect(loginErrorMessage(failure), 'E-mail ou senha não conferem. Confira e tente de novo.');
    }
  });

  test('muitas tentativas e usuário desativado têm mensagem própria', () {
    expect(
      loginErrorMessage(const TooManyRequests()),
      'Muitas tentativas seguidas. Espere alguns minutos e tente de novo.',
    );
    expect(
      loginErrorMessage(const UserDisabled()),
      'Este usuário está desativado. Fale com quem administra o painel.',
    );
  });

  test('servidor, conexão e outros erros pedem para conferir a conexão', () {
    for (final failure in const [ServerError(), AuthFailure(), Forbidden()]) {
      expect(
        loginErrorMessage(failure),
        'Não conseguimos entrar agora. Confira sua conexão e tente de novo.',
      );
    }
  });
}
