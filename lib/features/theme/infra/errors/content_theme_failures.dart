/// Classe abstrata para todas as falhas relacionadas a conteúdos de tema
abstract class ContentThemeFailure implements Exception {
  final String message;

  ContentThemeFailure(this.message);

  @override
  String toString() => message;
}

/// Falha ao buscar conteúdos
class FetchFailure extends ContentThemeFailure {
  FetchFailure(super.message);
}

/// Falha ao criar conteúdo
class CreateFailure extends ContentThemeFailure {
  CreateFailure(super.message);
}

/// Falha ao atualizar conteúdo
class UpdateFailure extends ContentThemeFailure {
  UpdateFailure(super.message);
}

/// Falha ao deletar conteúdo
class DeleteFailure extends ContentThemeFailure {
  DeleteFailure(super.message);
}

/// Falha genérica
class GenericFailure extends ContentThemeFailure {
  GenericFailure(super.message);
}

/// Subtema não encontrado
class SubthemeNotFoundException extends ContentThemeFailure {
  SubthemeNotFoundException(super.message);
}
