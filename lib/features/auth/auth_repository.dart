import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../core/error/result.dart';
import 'login_credentials.dart';
import 'model/auth_model.dart';

/// Fonte de dados de autenticação para o MVP.
///
/// Lê `assets/mock/professores.json`, valida as credenciais e retorna
/// o [ProfessorModel] do professor autenticado — sem expor senha ou
/// dados sensíveis ao restante do app.
///
/// Contrato de retorno:
/// - [Ok<ProfessorModel>]  → autenticação bem-sucedida.
/// - [Err<AuthFailure>]    → e-mail não encontrado, senha inválida ou conta inativa.
/// - [Err<ParseFailure>]   → JSON malformado.
/// - [Err<UnexpectedFailure>] → qualquer outro erro interno.
///
/// TODO(2.x): substituir por chamada real à API quando o backend estiver pronto.
/// A assinatura pública permanece idêntica — apenas a implementação muda.
class AuthRepository {
  static const String _mockAssetPath = 'assets/mock/professores.json';

  /// Autentica o professor com as [credentials] fornecidas.
  ///
  /// Simula um delay de rede realista definido em [AppConstants.fakeNetworkDelay].
  ///
  /// Nota MVP: a comparação é feita diretamente contra o campo `senha_hash`
  /// do JSON (que armazena a senha em texto para fins de demo). Em produção,
  /// `senha_hash` seria um bcrypt hash e a comparação usaria `bcrypt.verify()`.
  Future<Result<ProfessorModel, Failure>> login(
    LoginCredentials credentials,
  ) async {
    // Simula latência de rede para UX realista.
    await Future.delayed(AppConstants.fakeNetworkDelay);

    try {
      final raw = await rootBundle.loadString(_mockAssetPath);
      final data = json.decode(raw) as List<dynamic>;
      final professores = data.cast<Map<String, dynamic>>();

      // Busca por e-mail (insensível a maiúsculas).
      final match = professores.where(
        (p) =>
            (p['email'] as String).toLowerCase() ==
            credentials.email.trim().toLowerCase(),
      ).firstOrNull;

      if (match == null) {
        return const Err(AuthFailure('E-mail não encontrado.'));
      }

      if (match['senha_hash'] != credentials.senha) {
        return const Err(AuthFailure('Senha incorreta.'));
      }

      if (match['ativo'] == false) {
        return const Err(
          AuthFailure('Conta inativa. Entre em contato com a escola.'),
        );
      }

      return Ok(ProfessorModel.fromJson(match));
    } on FormatException {
      return const Err(ParseFailure());
    } catch (_) {
      return const Err(UnexpectedFailure());
    }
  }
}
