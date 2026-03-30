/// Classe base para falhas de conteúdo
abstract class ContentFailure {
  final String message;

  ContentFailure(this.message);

  @override
  String toString() => message;
}

/// Falha de autenticação
class AuthenticationFailure extends ContentFailure {
  AuthenticationFailure([super.message = 'Não autenticado']);
}

/// Falha ao buscar dados
class FetchFailure extends ContentFailure {
  FetchFailure([super.message = 'Erro ao buscar dados']);
}

/// Falha ao criar dados
class CreateFailure extends ContentFailure {
  CreateFailure([super.message = 'Erro ao criar conteúdo']);
}

/// Falha ao atualizar dados
class UpdateFailure extends ContentFailure {
  UpdateFailure([super.message = 'Erro ao atualizar conteúdo']);
}

/// Falha ao deletar dados
class DeleteFailure extends ContentFailure {
  DeleteFailure([super.message = 'Erro ao deletar conteúdo']);
}

/// Falha genérica
class GenericFailure extends ContentFailure {
  GenericFailure([super.message = 'Erro desconhecido']);
}

/// Falha quando subtema não é encontrado
class SubthemeNotFoundException extends ContentFailure {
  SubthemeNotFoundException([super.message = 'Subtema não encontrado']);
}
