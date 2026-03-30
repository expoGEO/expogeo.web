import 'package:firebase_auth/firebase_auth.dart';

/// Classe base para falhas de autenticação
class AuthFailure {
  final String message;

  const AuthFailure([this.message = 'Ocorreu um erro inesperado. Tente novamente mais tarde.']);

  /// Factory para converter exceções do Firebase em AuthFailure
  factory AuthFailure.fromException(FirebaseAuthException exception) {
    switch (exception.code.toLowerCase()) {
      case 'invalid-credential':
      case 'wrong-password':
        return const WrongPassword();
      case 'invalid-email':
        return const InvalidEmailAddress();
      case 'user-disabled':
        return const UserDisabled();
      case 'user-not-found':
        return const UserNotFound();
      case 'too-many-requests':
        return const TooManyRequests();
      case 'email-already-in-use':
        return const EmailAlreadyInUse();
      case 'permission-denied':
        return const Forbidden();
      default:
        return const ServerError();
    }
  }

  @override
  String toString() => message;
}

class InvalidCredentials extends AuthFailure {
  const InvalidCredentials() : super('Credenciais inválidas');
}

class InvalidEmailAddress extends AuthFailure {
  const InvalidEmailAddress() : super('E-mail inválido');
}

class UserDisabled extends AuthFailure {
  const UserDisabled() : super('Usuário desabilitado');
}

class UserNotFound extends AuthFailure {
  const UserNotFound() : super('Usuário não encontrado');
}

class WrongPassword extends AuthFailure {
  const WrongPassword() : super('Senha incorreta');
}

class TooManyRequests extends AuthFailure {
  const TooManyRequests() : super('Muitas tentativas. Tente novamente mais tarde.');
}

class EmailAlreadyInUse extends AuthFailure {
  const EmailAlreadyInUse() : super('E-mail já está em uso');
}

class Forbidden extends AuthFailure {
  const Forbidden() : super('Acesso negado');
}

class ServerError extends AuthFailure {
  const ServerError() : super('Erro no servidor');
}
