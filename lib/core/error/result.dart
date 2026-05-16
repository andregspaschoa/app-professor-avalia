/// Tipo Result para error handling explícito e sem exceções.
///
/// Todos os repositórios retornam [Result<T, E>] ao invés de lançar
/// exceções genéricas, tornando os caminhos de falha visíveis e
/// obrigatoriamente tratados em tempo de compilação (exhaustive switch).
///
/// Uso típico:
/// ```dart
/// final result = await authRepository.login(credentials);
/// switch (result) {
///   case Ok(:final value) => // usa value (ProfessorModel)
///   case Err(:final error) => // trata error (Failure)
/// }
/// ```
sealed class Result<T, E> {
  const Result();
}

/// Resultado de sucesso — carrega o valor esperado.
final class Ok<T, E> extends Result<T, E> {
  const Ok(this.value);
  final T value;
}

/// Resultado de falha — carrega o erro tipado.
final class Err<T, E> extends Result<T, E> {
  const Err(this.error);
  final E error;
}
