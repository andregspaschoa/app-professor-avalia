/// DTO de entrada para o fluxo de autenticação.
///
/// Transporta as credenciais digitadas pelo usuário da [LoginScreen]
/// até o [AuthRepository.login]. É descartado imediatamente após a
/// validação — nunca persiste em estado ou storage.
///
/// Não usa Freezed: é um objeto de transferência simples, sem
/// necessidade de serialização, copyWith ou geração de código.
class LoginCredentials {
  const LoginCredentials({
    required this.email,
    required this.senha,
  });

  final String email;
  final String senha;
}
