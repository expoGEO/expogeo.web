import 'package:expogeo/features/admin/login/infra/errors/auth_failure.dart';

/// Texto do aviso do login. Credenciais erradas não dizem qual dos dois dados falhou.
String loginErrorMessage(AuthFailure failure) {
  return switch (failure) {
    WrongPassword() ||
    UserNotFound() ||
    InvalidCredentials() ||
    InvalidEmailAddress() => 'E-mail ou senha não conferem. Confira e tente de novo.',
    TooManyRequests() => 'Muitas tentativas seguidas. Espere alguns minutos e tente de novo.',
    UserDisabled() => 'Este usuário está desativado. Fale com quem administra o painel.',
    _ => 'Não conseguimos entrar agora. Confira sua conexão e tente de novo.',
  };
}
