/// Hierarquia de falhas de domínio do Professor Avalia.
///
/// Todos os repositórios retornam [Result<T, Failure>] ao invés de
/// lançar exceções genéricas. Isso mantém o error handling explícito
/// e testável na camada de apresentação.
sealed class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Falha de conectividade (sem internet ou timeout).
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sem conexão com a internet.']);
}

/// Recurso não encontrado (404).
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso não encontrado.']);
}

/// Erro de autenticação (401 / 403).
final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Sessão expirada. Faça login novamente.']);
}

/// Erro ao processar dados (parse JSON, etc.).
final class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Erro ao processar os dados recebidos.']);
}

/// Erro interno inesperado.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Ocorreu um erro inesperado.']);
}

/// Erro de validação de dados de entrada.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
