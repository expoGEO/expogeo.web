abstract class ContentFailure {
  final String message;

  ContentFailure(this.message);

  @override
  String toString() => message;
}

class AuthenticationFailure extends ContentFailure {
  AuthenticationFailure([super.message = 'Não autenticado']);
}

class FetchFailure extends ContentFailure {
  FetchFailure([super.message = 'Erro ao buscar dados']);
}

class CreateFailure extends ContentFailure {
  CreateFailure([super.message = 'Erro ao criar conteúdo']);
}

class UpdateFailure extends ContentFailure {
  UpdateFailure([super.message = 'Erro ao atualizar conteúdo']);
}

class DeleteFailure extends ContentFailure {
  DeleteFailure([super.message = 'Erro ao deletar conteúdo']);
}

class GenericFailure extends ContentFailure {
  GenericFailure([super.message = 'Erro desconhecido']);
}

class SubthemeNotFoundException extends ContentFailure {
  SubthemeNotFoundException([super.message = 'Subtema não encontrado']);
}
